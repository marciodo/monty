;**********************************************
;A + B em 16 bits
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    INCLUDE "p16f84a.inc";Definição de registros

;Registros de propósito geral
DADO_A_L    EQU	    0x10
DADO_A_H    EQU	    0x11
DADO_B_L    EQU	    0x12
DADO_B_H    EQU	    0X13
RESULTADO_L EQU	    0x14
RESULTADO_H EQU	    0x15
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO

	    ORG	    5		;Saltamos o vetor
				;de interrupção
	    
;Começo do programa
INICIO:	    movf    DADO_A_L, W
	    addwf   DADO_B_L, W
	    movwf   RESULTADO_L
	    movf    DADO_A_H, W
	    btfsc   STATUS, C
	    addlw   1
	    addwf   DADO_B_H, W
	    movwf   RESULTADO_H
	    
STOP:	    nop
	    nop
	    
	    END			;Fim do programa