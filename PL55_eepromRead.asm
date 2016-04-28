;**********************************************
;Leitura de EEPROM
	    
		LIST    P=16F84A	;Tipo de dispositivo
	    
;Área de constantes
STATUS		EQU	0x03		;Registro de estado
PORTA		EQU	0x05		;Porta A
PORTB		EQU	0x06		;Porta B
OPTION_REG	EQU	0x01		;Timer0 e Option
INTCON		EQU	0x0B

EECON1		EQU	88h		;Etiquetas de registros
EEDATA		EQU	08h		;para a EEPROM
EEADR		EQU	09h

;Etiquetas de bits
RP0		EQU	5
RD		EQU	0
		
TEMPO1		EQU	0x0D		;Registro de propósito
					;geral
	    
		ORG	0		;Vetor de reset
		goto    INICIO
	    
		ORG	5		;Saltamos o vetor
					;de interrupção
	    
;Começo do programa
INICIO:		bsf	STATUS, RP0	;Banco 1
		clrf	PORTB		;Porta B saída em todos os bits
		bcf	STATUS, RP0	;Banco 0
		clrf	EEADR		;Endereço 0 da EEPROM
		call	READ
		movf	EEDATA, W	;Conteúdo da EEPROM para W 
		movwf   PORTB		;Transfere para Porta B
		
FIM:		goto	FIM
    
READ:		bsf	STATUS, RP0	;Banco 1
		bsf	EECON1, RD	;Comando para ler EEPROM
		bcf	STATUS, RP0	;Banco 0
		return
	    
		END			;Fim do programa