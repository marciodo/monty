;**********************************************
;Simula leitura de sensores e manipula��o de
;motores.
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    INCLUDE "P16F84A.inc";Defini��o de registros

;Registros de prop�sito geral
AUX	    EQU	    0x0C	
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO

	    ORG	    5		;Saltamos o vetor
				;de interrup��o
	    
;Come�o do programa
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    clrf    PORTB	;Porta B sa�da
	    movlw   b'00000011'	
	    movwf   PORTA
	    bcf	    STATUS, RP0	;Banco 0
	    
LOOP:	    movf    PORTA, W
	    andlw   b'00000011'	;Separa �ltimos 2 bits para an�lise
	    movwf   AUX
	    xorlw   b'00000000'
	    btfsc   STATUS, Z
	    goto    DIANTE
	    movf    AUX, W
	    xorlw   b'00000001'
	    btfsc   STATUS, Z
	    goto    DIREITA
	    movf    AUX, W
	    xorlw   b'00000010'
	    btfsc   STATUS, Z
	    goto    ESQUERDA
	    movf    AUX, W
	    xorlw   b'00000011'
	    btfsc   STATUS, Z
	    goto    ATRAS
	    goto    LOOP
	    
DIANTE:	    movlw   b'00000011'
	    movwf   PORTB
	    goto    LOOP
	    
ATRAS:	    movlw   b'00001100'
	    movwf   PORTB
	    goto    LOOP
	    
DIREITA:    movlw   b'00000110'
	    movwf   PORTB
	    goto    LOOP
	    	    
ESQUERDA:   movlw   b'00001001'
	    movwf   PORTB
	    goto    LOOP
	    
	    END			;Fim do programa