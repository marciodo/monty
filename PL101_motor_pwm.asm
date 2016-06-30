;**********************************************
;Varia a velocidade do motor com PWM, baseado
;no status do bumper.
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    RADIX   HEX
	    
	    INCLUDE "p16f84a.inc";Definição de registros
	    
;Área de constantes
TEMP	    EQU	    0x0E	;Variável auxiliar
VELOCIDADE  EQU	    0x0F
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO
	    
	    ORG	    5		;Saltamos o vetor
				;de interrupção
	    
;**********************************************	    
				
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    clrf    TRISA	;Porta A saída
	    movlw   b'00000100' ;RB2 = entrada bumper
	    movwf   TRISB
	    movlw   b'00000011'
	    movwf   OPTION_REG	;Divide-se o timer por 16 obtendo 
				;16 us por pulso
	    bcf	    STATUS, RP0	;Banco 0
	    
VEL:	    movlw   .255	; 255 loops de 624 us = 159.12 ms
	    btfss   PORTB, 2	; Salta se o bumper estiver pressionado,
				; mantendo 255 em W
	    movlw   .02		; 2 loops de 624 us = 1.248 ms
	    
	    movwf   VELOCIDADE	; Armazena em VELOCIDADE
	    
	    movwf   TEMP	; Transfere o tempo de movimentação para TEMP
	    movlw   b'00000001'
	    movwf   PORTA	; Ativa o motor
	    call    DELAY10	; Aguarda TEMP vezes 624 us
	    
	    movf    VELOCIDADE, W
	    movwf   TEMP	; Transfere o tempo de pausa para TEMP
	    clrf    PORTA	; Para o motor
	    call    DELAY10	; Aguarda TEMP vezes 624 us

	    goto    VEL
	    
;**********************************************
;Rotinas de delay
DELAY10:    bcf	    INTCON, 2	;Zera flag de interrupção do timer
	    movlw   0xD8
	    movwf   OPTION_REG	;Move 216 para o timer, que irá contar até
				;255, ou seja, conta 39 pulsos de 16 us,
				;ou 624 us.
	   
DELAY_10:   btfss   INTCON, 2	;Verifica se houve interrupção de timer
	    goto    DELAY_10
	    decfsz  TEMP, 1	;Somente entra no return após repetição de
				;TEMP vezes os 624 us.
	    goto    DELAY10
	    return	    
	    
	    END			;Fim do programa