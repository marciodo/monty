;**********************************************
;Leitura de EEPROM simulada
	    
		LIST    P=16F84A	;Tipo de dispositivo
		INCLUDE "p16f84a.inc";Definição de registros
		
EEADR_VAR	EQU	0x0D		;Registro de propósito
					;geral
EEDATA_VAR	EQU	0x0E
	    
		ORG	0		;Vetor de reset
		goto    INICIO
	    
;Começo do programa
INICIO:		bsf	STATUS, RP0	;Banco 1
		clrf	PORTB		;Porta B saída em todos os bits
		bcf	STATUS, RP0	;Banco 0
	
		movlw	03
		movwf	EEADR_VAR	;Endereço 3 da EEPROM na variável aux
		call	LER_EEPROM
		movf	EEDATA_VAR, W	;Conteúdo da EEPROM para W 
		movwf   PORTB		;Transfere para Porta B		
		goto	INICIO
    
LER_EEPROM:	movf	EEADR_VAR, W
		movwf	EEADR		;Endereço colocado em EEADR_VAR será lido
		bsf	STATUS, RP0	;Banco 1
		bsf	EECON1, RD	;Comando para ler EEPROM
		bcf	STATUS, RP0	;Banco 0
		movf	EEDATA, W
		movwf	EEDATA_VAR	;Move conteúdo da EEPROM para EEDATA_VAR
		return
	    
		END			;Fim do programa