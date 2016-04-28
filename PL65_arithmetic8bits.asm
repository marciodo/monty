;**********************************************
;Equação: (A+B)-C
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    INCLUDE "p16f84a.inc";Definição de registros

;Registros de propósito geral
DADO_A	    EQU	    0x0C
DADO_B	    EQU	    0x0D
DADO_C	    EQU	    0x0E
RESULTADO   EQU	    0x0F	
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO

	    ORG	    5		;Saltamos o vetor
				;de interrupção
	    
;Começo do programa
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    clrf    PORTB	;Porta B saída
	    bcf	    STATUS, RP0	;Banco 0
	    
	    movlw   .6
	    movwf   DADO_A
	    movlw   .25
	    movwf   DADO_B
	    movlw   .10
	    movwf   DADO_C
	    movf    DADO_A, W
	    addwf   DADO_B, W
	    movwf   RESULTADO
	    movf    DADO_C, W
	    subwf   RESULTADO, F
	    movf    RESULTADO, W
	    movwf   PORTB
	    
LOOP:	    goto    LOOP
	    
	    END			;Fim do programa