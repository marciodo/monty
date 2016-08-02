;**********************************************
;Escrita de EEPROM
	    
		LIST    P=16F84A	;Tipo de dispositivo
		INCLUDE "p16f84a.inc";Defini��o de registros
			    
		ORG	0		;Vetor de reset
		goto    INICIO
	    
		ORG	5		;Saltamos o vetor
					;de interrup��o
	    
;Vari�veis
EEADR_VAR	EQU	0X0C
EEDATA_VAR	EQU	0x0D
			
;Come�o do programa
INICIO:		movlw	03		;Endere�o a escrever
		movwf	EEADR_VAR	;vai em vari�vel auxiliar
		movlw	27		;Dado a escrever
		movwf	EEDATA_VAR	;vai em vari�vel auxiliar
		call	ESCREVER_EEPROM
		goto	FIM
    
ESCREVER_EEPROM:movf	EEADR_VAR, W	;Move o endere�o		
		movwf	EEADR		;ao seu registro
		movf	EEDATA_VAR, W	;Move o dado
		movwf	EEDATA		;ao seu registro
		bsf	STATUS, RP0	;Banco 1
		bsf	EECON1, WREN	;Fornece permiss�o de escrita
					;na EEPROM
		;Sequ�ncia de seguran�a obrigat�ria para gravar na EEPROM:
		;escrever 55h e AAh em EECON2
		movlw	0x55
		movwf	EECON2
		movlw	0xAA
		movwf	EECON2
		bsf	EECON1, WR	;Comando para salvar na EEPROM
COMPROVAR:	btfss	EECON1, EEIF	;Terminou?
		goto	COMPROVAR	;N�o, seguir comprovando
		bcf	EECON1, EEIF	;Sim, descer bandeira
		bcf	EECON1, WREN	;Desabilita��o de escrita
		return
	    
FIM:		
		END			;Fim do programa