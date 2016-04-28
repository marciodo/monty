;**********************************************
;Equação: (A+B)-C
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    INCLUDE "p16f84a.inc";Definição de registros	
	    
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
	    
LOOP:	    clrwdt
	    btfss   PORTA, 0
	    goto    LOOP
	    bcf	    PORTB, 2
	    bsf	    PORTB, 0
	    
Espera_b_1: clrwdt
	    btfss   PORTA, 2
	    goto    Espera_b_1
	    bsf	    PORTB, 1
	    
Espera_c:   clrwdt
	    btfss   PORTA, 3
	    goto    Espera_c
	    bcf	    PORTB, 0
	    
Espera_b_2: clrwdt
	    btfss   PORTA, 2
	    goto    Espera_b_2
	    bcf	    PORTB, 1
	    
Espera_a:   clrwdt
	    btfss   PORTA, 1
	    goto    Espera_a
	    bsf	    PORTB, 2
	    goto    LOOP
	    
	    END			;Fim do programa