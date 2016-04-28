;**********************************************
;Uso de watchdog e sleep para anti-rebotes
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    INCLUDE "P16F84A.inc.asm";Definição de registros

;Registros de propósito geral
CONTADOR    EQU	    0x0C	
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO

	    ORG	    5		;Saltamos o vetor
				;de interrupção
	    
;Começo do programa
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    clrf    PORTB	;Porta B saída
	    bsf	    PORTA, 0
	    movlw   b'00001111'	
	    movwf   OPTION_REG	;Divide-se o contador do watchdog
				;por 256 obtendo 256 us por pulso
	    bcf	    STATUS, RP0	;Banco 0
	    
LOOP:	    btfss   PORTA, 0	;Espera A0 ir a 1
	    goto    LOOP
	    sleep
	    
LOOP2:	    btfsc   PORTA, 0	;Espera A0 ir a 0
	    goto    LOOP2
	    sleep
	    
	    incf    CONTADOR, F
	    movf    CONTADOR, W
	    movwf   PORTB
	    goto    LOOP
	    
	    END			;Fim do programa