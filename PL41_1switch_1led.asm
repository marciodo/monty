;**********************************************
;Programa que acende e apaga o led d1 da placa
;de entradas e saídas em função do estado
;do interruptor sw3.
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    
;Área de constantes
STATUS	    EQU	    0x03
PORTA	    EQU	    0x05
PORTB	    EQU	    0x06
RP0	    EQU	    0x05
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO
	    
	    ORG	    5
	    
;Começo do programa
INICIO:	    bsf	    STATUS, RP0
	    clrf    PORTB
	    movlw   b'00000100'
	    movwf   PORTA
	    bcf	    STATUS, RP0
	    clrf    PORTB
	    
LOOP:	    btfss   PORTA, 2
	    goto    APAGAR
	    goto    ACENDER
	    
ACENDER:    bsf	    PORTB, 0
	    goto    LOOP
	    
APAGAR:	    bcf	    PORTB, 0
	    goto    LOOP

	    END	    ;Fim do programa