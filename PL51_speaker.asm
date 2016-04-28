;**********************************************
;Toca o speaker.
	    
		LIST    P=16F84A	;Tipo de dispositivo
	    
;Área de constantes
STATUS		EQU	0x03		;Registro de estado
PORTA		EQU	0x05		;Porta A
PORTB		EQU	0x06		;Porta B
RP0		EQU	0x05
OPTION_REG	EQU	0x01		;Timer0 e Option
INTCON		EQU	0x0B
TEMPO1		EQU	0x0D		;Registro de propósito
					;geral
	    
		ORG	0		;Vetor de reset
		goto    INICIO
	    
		ORG	5		;Saltamos o vetor
					;de interrupção
	    
;Começo do programa
INICIO:		bsf	STATUS, RP0	;Banco 1
		movlw   b'01111111'	;Pino B7 saída
		movwf   PORTB		
		movlw   b'00000111'
		movwf   OPTION_REG	;Divide-se o timer por 256 obtendo 
					;265 us por pulso
		bcf	STATUS, RP0	;Banco 0
		clrf    PORTB		;Zera saída
	    
LOOP:		bsf	PORTB, 7	;Ativa pino B7
		call	DELAY1S
		bcf	PORTB, 7	;Desativa pino B7
		call	DELAYMS
		goto	LOOP
		
DELAY1S:	bcf     STATUS, RP0	;Banco 0
		movlw   0x64
		movwf   TEMPO1		;Número 100 no registrador TEMPO1
		call    DEL10
		return
		
DELAYMS:	bcf	STATUS, RP0	;Banco 0
		movlw	.50
		movwf	TEMPO1		;Número 50 no registrador TEMPO1
		call	DEL10
		return
	    
DEL10:		bcf	INTCON, 2	;Zera flag de interrupção do timer
		movlw   0xD8
		movwf   OPTION_REG	;Move 216 para o timer, que irá contar até
					;255, ou seja, conta 39 pulsos de 256 us,
					;ou 9.984 ms.
	   
DEL10_1:	btfss   INTCON, 2	;Verifica se houve interrupção de timer
		goto    DEL10_1
		decfsz  TEMPO1, 1	;Somente entra no return após repetição de
					;100 vezes os 9.984 ms.
		goto    DEL10
		return
	    
		END			;Fim do programa