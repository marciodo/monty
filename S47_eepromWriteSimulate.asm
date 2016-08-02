;**********************************************
;Escrita de EEPROM
	    
		LIST    P=16F84A	;Tipo de dispositivo
		INCLUDE "p16f84a.inc";Definição de registros
			    
		ORG	0		;Vetor de reset
		goto    INICIO
	    
		ORG	5		;Saltamos o vetor
					;de interrupção
	    
;Variáveis
EEADR_VAR	EQU	0X0C
EEDATA_VAR	EQU	0x0D
			
;Começo do programa
INICIO:		movlw	03		;Endereço a escrever
		movwf	EEADR_VAR	;vai em variável auxiliar
		movlw	27		;Dado a escrever
		movwf	EEDATA_VAR	;vai em variável auxiliar
		call	ESCREVER_EEPROM
		goto	FIM
    
ESCREVER_EEPROM:movf	EEADR_VAR, W	;Move o endereço		
		movwf	EEADR		;ao seu registro
		movf	EEDATA_VAR, W	;Move o dado
		movwf	EEDATA		;ao seu registro
		bsf	STATUS, RP0	;Banco 1
		bsf	EECON1, WREN	;Fornece permissão de escrita
					;na EEPROM
		;Sequência de segurança obrigatória para gravar na EEPROM:
		;escrever 55h e AAh em EECON2
		movlw	0x55
		movwf	EECON2
		movlw	0xAA
		movwf	EECON2
		bsf	EECON1, WR	;Comando para salvar na EEPROM
COMPROVAR:	btfss	EECON1, EEIF	;Terminou?
		goto	COMPROVAR	;Não, seguir comprovando
		bcf	EECON1, EEIF	;Sim, descer bandeira
		bcf	EECON1, WREN	;Desabilitação de escrita
		return
	    
FIM:		
		END			;Fim do programa