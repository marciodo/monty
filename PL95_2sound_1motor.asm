;**********************************************
;Muda o sentido do motor de acordo com a leitura 
;de duas entradas óticas.
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    INCLUDE "p16f84a.inc";Definição de registros
	    
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO
	    
	    ORG	    5
	    
;Começo do programa
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    clrf    TRISA	;Portas A saída
	    movlw   b'00000011' ;RB0 e RB1 = entrada
	    movwf   TRISB
	    bcf	    STATUS, RP0	;Banco 0
	    
LOOP:	    btfss   PORTB, 0	;Salta se RB0 = True
	    goto    PRETO_DIR
	    goto    BRANCO_DIR
	    
PRETO_DIR:  btfss   PORTB, 1	;Salta se RB1 = True
	    goto    PARAR
	    goto    DIREITA
	    
BRANCO_DIR: btfss   PORTB, 1	;Salta se RB1 = True
	    goto    ESQUERDA
	    goto    PARAR	    
	    
PARAR:	    clrf    PORTA	;Para ambos os motores
	    goto    LOOP
	    
;Com RA0 e RA1 com sinais opostos o motor move em uma direcao ou outra
DIREITA:    bsf	    PORTA, 0	;RA0 recebe True
	    bcf	    PORTA, 1	;RA1 recebe False
	    goto    LOOP
	    
ESQUERDA:   bcf	    PORTA, 0	;RA0 recebe False
	    bsf	    PORTA, 1	;RA1 recebe True
	    goto    LOOP

	    END	    ;Fim do programa