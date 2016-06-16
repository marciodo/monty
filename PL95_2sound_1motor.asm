;**********************************************
;Ativa o motor quando um movimento é detectado 
;nos sensores ultrassônicos e desativa quando
;um som é detectado no microfone.
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    INCLUDE "p16f84a.inc";Definição de registros
	    
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO
	    
	    ORG	    5
	    
;Começo do programa
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    clrf    TRISA	;Portas A saída
	    movlw   b'00110000' ;RB4 e 5 = entrada
	    movwf   TRISB
	    bcf	    STATUS, RP0	;Banco 0                                                                                                                                                                                                                      
	    clrf    PORTA
	    
MOVIMENTO:  btfsc   PORTB, 4	;Salta se movimento detectado (False no ultrassom)
	    goto    MOVIMENTO
	    movlw   0x01
	    movwf   PORTA	;Ativa uma saída para mover o motor
	    
SOM:	    btfss   PORTB, 5	;Salta se som detectado (True no microfone)
	    goto    SOM
	    clrf    PORTA	;Limpa saída para parar motor
	    goto    MOVIMENTO

	    END	    ;Fim do programa