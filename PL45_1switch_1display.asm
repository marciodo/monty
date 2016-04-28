;**********************************************
;Programa que utiliza o display 7 segmentos
;para mostrar o valor do interruptor sw3
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    
;�rea de constantes
STATUS	    EQU	    0x03
PORTA	    EQU	    0x05
PORTB	    EQU	    0x06
RP0	    EQU	    0x05
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO
	    
	    ORG	    5		;Saltamos o vetor
				;de interrup��o
	    
;Come�o do programa
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    clrf    PORTB
	    movlw   b'00000100'
	    movwf   PORTA
	    bcf	    STATUS, RP0	;Banco 0
	    
LOOP:	    btfss   PORTA, 2
	    goto    ZERO
	    goto    UM
	    
ZERO:	    movlw   b'00111111'	;C�digo 0
	    movwf   PORTB
	    goto    LOOP
	    
UM:	    movlw   b'00000110'	;C�digo 1
	    movwf   PORTB
	    goto    LOOP
	    
	    END			;Fim do programa