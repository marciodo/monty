;**********************************************
;Varia a velocidade do motor com PWM, baseado
;no status do bumper.
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    RADIX   HEX
	    
	    INCLUDE "p16f84a.inc";Defini��o de registros
	    
;�rea de constantes
TEMP	    EQU	    0x0E	;Vari�vel auxiliar
VELOCIDADE  EQU	    0x0F
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO
	    
	    ORG	    5		;Saltamos o vetor
				;de interrup��o
	    
;**********************************************
;Rotinas de delay
DELAY10:    bcf	    INTCON, 2	;Zera flag de interrup��o do timer
	    movlw   0xD8
	    movwf   OPTION_REG	;Move 216 para o timer, que ir� contar at�
				;255, ou seja, conta 39 pulsos de 256 us,
				;ou 9.984 ms.
	   
DELAY_10:   btfss   INTCON, 2	;Verifica se houve interrup��o de timer
	    goto    DELAY_10
	    decfsz  TEMP, 1	;Somente entra no return ap�s repeti��o de
				;x vezes os 9.984 ms.
	    goto    DELAY10
	    return

;**********************************************	    
				
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    clrf    PORTA	;Porta A sa�da
	    clrf    PORTB	;Porta B sa�da
	    movlw   b'00000010'
	    movwf   OPTION_REG	;Divide-se o timer por 256 obtendo 
				;256 us por pulso
	    bcf	    STATUS, RP0	;Banco 0
	    
;**********************************************
	    
	    movlw   .02
	    movwf   VELOCIDADE
	    
;**********************************************
	    
VEL:	    movf    VELOCIDADE, W
	    movwf   TEMP
	    movlw   b'00000001'
	    movwf   PORTA
	    call    DELAY10
	    
	    movf    VELOCIDADE, W
	    movwf   TEMP
	    clrf    PORTA
	    call    DELAY10
	    
	    goto    VEL
	    
	    END			;Fim do programa