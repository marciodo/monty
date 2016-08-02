;**********************************************
;Leitura de EEPROM simulada
	    
		LIST    P=16F84A	;Tipo de dispositivo
		INCLUDE "p16f84a.inc";Defini��o de registros
		
EEADR_VAR	EQU	0x0D		;Registro de prop�sito
					;geral
EEDATA_VAR	EQU	0x0E
	    
		ORG	0		;Vetor de reset
		goto    INICIO
	    
;Come�o do programa
INICIO:		bsf	STATUS, RP0	;Banco 1
		clrf	PORTB		;Porta B sa�da em todos os bits
		bcf	STATUS, RP0	;Banco 0
	
		movlw	03
		movwf	EEADR_VAR	;Endere�o 3 da EEPROM na vari�vel aux
		call	LER_EEPROM
		movf	EEDATA_VAR, W	;Conte�do da EEPROM para W 
		movwf   PORTB		;Transfere para Porta B		
		goto	INICIO
    
LER_EEPROM:	movf	EEADR_VAR, W
		movwf	EEADR		;Endere�o colocado em EEADR_VAR ser� lido
		bsf	STATUS, RP0	;Banco 1
		bsf	EECON1, RD	;Comando para ler EEPROM
		bcf	STATUS, RP0	;Banco 0
		movf	EEDATA, W
		movwf	EEDATA_VAR	;Move conte�do da EEPROM para EEDATA_VAR
		return
	    
		END			;Fim do programa