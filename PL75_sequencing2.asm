;**********************************************
;Sequenciamento de tarefas - simulação conta-peças
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    INCLUDE "p16f84a.inc";Definição de registros	
	  
CONTA_PECA  EQU	    0x0c
  
	    ORG	    0		;Vetor de reset
	    goto    INICIO

	    ORG	    5		;Saltamos o vetor
				;de interrupção
	  
;Começo do programa
INICIO:	    clrf    PORTB
	    bsf	    STATUS, RP0	;Banco 1
	    clrf    TRISB	;Porta B saída
	    movlw   b'00011111'	;5 pinos de A para entrada
	    movwf   TRISA
	    bcf	    STATUS, RP0	;Banco 0
	    
LOOP_0:	    clrf    PORTB	;Zera saídas
LOOP:	    clrwdt
	    movlw   d'10'
	    movwf   CONTA_PECA	;Inicia registro com 10
	    btfss   PORTA, 0	;Salta se RA0 = true
	    goto    LOOP_0	;Fica no loop esperando RA0
	    
	    bcf	    PORTB, 0	;Desativa RB0
	    bsf	    PORTB, 1	;Ativa RB1
	    
NAO_RECIPIENTE:
	    clrwdt
	    btfss   PORTA, 2	;Salta se RA2 = true
	    goto    NAO_RECIPIENTE ;Fica no loop esperando RA2
	    
	    bsf	    PORTB, 0	;Ativa RB0
	    bcf	    PORTB, 1	;Desativa RB1
	    bcf	    PORTB, 2	;Desativa RB2
	    
PECA_0:	    clrwdt
	    btfss   PORTA, 1	;Salta se RA1 = true
	    goto    PECA_0	;Fica no loop esperando RA1
	    
PECA_1:	    clrwdt
	    btfsc   PORTA, 1	;Salta se RA1 = false
	    goto    PECA_1	;Fica no loop esperando RA1
	    decfsz  CONTA_PECA, F ;Decrementa e salta se zero
	    goto    PECA_0	;Espera nova mudança da chave
	    bcf	    PORTB, 0	;Desativa RB0
	    bsf	    PORTB, 1	;Ativa RB1
	    bsf	    PORTB, 2	;Ativa RB2
	    
SIM_RECIPIENTE:
	    clrwdt
	    btfsc   PORTA, 2	;Salta se RA2 = false
	    goto    SIM_RECIPIENTE ;Fica no loop esperando RA2
	    
	    goto    LOOP
	    
	    END			;Fim do programa
