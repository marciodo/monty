;**********************************************
;Gira um motor de acordo com a leitura da entrada
;ótica.
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    INCLUDE "p16f84a.inc";Definição de registros
	    
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO
	    
	    ORG	    5
	    
;Começo do programa
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    movlw   b'00010000' ;RA4 = entrada
	    movwf   TRISA
	    bcf	    STATUS, RP0	;Banco 0
	    
LOOP:	    btfss   PORTA, 4	;Salta se RA4 = True
	    goto    ADIANTE
	    goto    PARADO
	    
PARADO:	    clrf    PORTA
	    goto    LOOP
	    
ADIANTE:    bsf	    PORTA, 0	;RA0 recebe True
	    goto    LOOP

	    END	    ;Fim do programa