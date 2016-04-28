;**********************************************
;Escrita de EEPROM
	    
		LIST    P=16F84A	;Tipo de dispositivo
	    
;Área de constantes
STATUS		EQU	0x03		;Registro de estado
PORTA		EQU	0x05		;Porta A
PORTB		EQU	0x06		;Porta B
OPTION_REG	EQU	0x01		;Timer0 e Option
INTCON		EQU	0x0B

EECON1		EQU	88h		;Etiquetas de registros
EECON2		EQU	89h		;para a EEPROM
EEDATA		EQU	08h
EEADR		EQU	09h

;Etiquetas de bits
RP0		EQU	5
EEIE		EQU	6
WREN		EQU	2
WR		EQU	1
RD		EQU	0
		
TEMPO1		EQU	0x0D		;Registro de propósito
					;geral
	    
		ORG	0		;Vetor de reset
		goto    INICIO
	    
		ORG	5		;Saltamos o vetor
					;de interrupção
	    
;Começo do programa
INICIO:		bsf	STATUS, RP0	;Banco 1
		movlw   b'00011111'	;5 pinos de A como entrada
		movwf   PORTA		
		movlw   b'00000111'
		movwf   OPTION_REG	;Divide-se o timer por 256 obtendo 
					;265 us por pulso
		call	DADO
		call	WRITE
		goto	FIM
		
FIM:		goto	FIM
    
DADO:		bcf	STATUS, RP0	;Banco 0
		movlw	b'00000000'	;Endereço 0 da EEPROM
		movwf	EEADR
		movf	PORTA, W
		movwf	EEDATA		;Conteúdo de A para ser gravado
					;na EEPROM
		return
		
WRITE:		bsf	STATUS, RP0	;Banco 1
		bsf	EECON1, WREN	;Fornece permissão de escrita
					;na EEPROM
		;Sequência de segurança obrigatória para gravar na EEPROM:
		;escrever 55h e AAh em EECON2
		movlw	0x55
		movwf	EECON2
		movlw	0xAA
		movwf	EECON2
		bsf	EECON1, WR	;Comando para salvar na EEPROM
		bcf	STATUS, RP0	;Banco 0
		call	DEL10		;Aguarda 10 ms para salvar o dado
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