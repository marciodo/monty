;**********************************************
;Ativa o motor quando um movimento � detectado 
;nos sensores ultrass�nicos e desativa quando
;um som � detectado no microfone.
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    INCLUDE "p16f84a.inc";Defini��o de registros
	    
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO
	    
	    ORG	    5
	    
;Come�o do programa
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    clrf    TRISA	;Portas A sa�da
	    movlw   b'00110000' ;RB4 e 5 = entrada
	    movwf   TRISB
	    bcf	    STATUS, RP0	;Banco 0                                                                                                                                                                                                                      
	    clrf    PORTA
	    
MOVIMENTO:  btfsc   PORTB, 4	;Salta se movimento detectado (False no ultrassom)
	    goto    MOVIMENTO
	    movlw   0x01
	    movwf   PORTA	;Ativa uma sa�da para mover o motor
	    
SOM:	    btfss   PORTB, 5	;Salta se som detectado (True no microfone)
	    goto    SOM
	    clrf    PORTA	;Limpa sa�da para parar motor
	    goto    MOVIMENTO

	    END	    ;Fim do programa