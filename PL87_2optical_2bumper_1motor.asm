;**********************************************
;Muda o sentido do motor de acordo com a leitura 
;de dois bumpers e para o motor de acordo com a
;leitura de duas entradas óticas.
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    INCLUDE "p16f84a.inc";Definição de registros
	    
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO
	    
	    ORG	    5
	    
;Começo do programa
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    clrf    TRISA	;Portas A saída
	    movlw   b'00001111' ;RB0 a 3 = entrada
	    movwf   TRISB
	    bcf	    STATUS, RP0	;Banco 0
	    
LOOP:	    btfsc   PORTB, 2	;Salta se bumper 1 = False
	    goto    ATRAS
	    
	    btfsc   PORTB, 3	;Salta se bumper 2 = False
	    goto    ATRAS
	    
	    btfss   PORTB, 0	;Salta se ótico 1 = preto(True)
	    goto    PARAR
	    
	    btfss   PORTB, 1	;Salta se ótico 2 = preto(True)
	    goto    PARAR
	    goto    ADIANTE
	    
;****************************************************************	    
	    
PARAR:	    clrf    PORTA	;Para ambos os motores
	    goto    LOOP
	    
;Com RA0 e RA1 com sinais opostos o motor move em uma direcao ou outra
ADIANTE:    bsf	    PORTA, 0	;RA0 recebe True
	    bcf	    PORTA, 1	;RA1 recebe False
	    goto    LOOP
	    
ATRAS:	    bcf	    PORTA, 0	;RA0 recebe False
	    bsf	    PORTA, 1	;RA1 recebe True
	    goto    LOOP

	    END	    ;Fim do programa