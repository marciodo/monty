;**********************************************
;Move o motor de acordo com o sensor ótico e o
;estado do bumper.
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    INCLUDE "p16f84a.inc";Definição de registros
	    
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO
	    
	    ORG	    5
	    
;Começo do programa
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    movlw   b'00010000' ;RA4 = entrada óptico
	    movwf   TRISA
	    movlw   b'00000100' ;RB2 = entrada bumper
	    movwf   TRISB
	    bcf	    STATUS, RP0	;Banco 0
	    
LOOP:	    btfsc   PORTB, 2	;Salta se bumper = False
	    goto    PARAR
	    btfss   PORTA, 4	;Salta se óptico = True
	    goto    PARAR
	    goto    ADIANTE	    
	    
PARAR:	    clrf    PORTA	;Para o motor
	    goto    LOOP
	    
ADIANTE:    bsf	    PORTA, 0	;Move o motor, setando RA0
	    goto    LOOP

	    END	    ;Fim do programa