;**********************************************
;Escrita de EEPROM
	    
		LIST    P=16F84A	;Tipo de dispositivo
		INCLUDE "p16f84a.inc"	;Defini��o de registros
			    
;Vari�veis
EEADR_VAR	EQU	0X0C
EEDATA_VAR	EQU	0x0D
	
		ORG	0		;Vetor de reset
		goto    INICIO
	    
		ORG	5		;Saltamos o vetor
					;de interrup��o
			
;Come�o do programa
INICIO:		bsf	STATUS, RP0	;Banco 1
		clrf	TRISB		;Porta B sa�da em todos os bits
		movlw	0x1F		;Porta A entrada
		movwf	TRISA
		bcf	STATUS, RP0	;Banco 0
		
OPCAO:		btfss	PORTA, 4	;Op��o a tomar
		goto	ESCREVER	;Se RA4=0, escreve
		goto	LER		;Se RA4=1, l�
		
ESCREVER:	movlw	03		;Endere�o a escrever
		movwf	EEADR_VAR	;vai em vari�vel auxiliar
		movf	PORTA, W	;Valor na Porta A
		movwf	EEDATA_VAR	;vai em vari�vel auxiliar
		call	ESCREVER_EEPROM
		goto	OPCAO
		
LER:		movlw	03
		movwf	EEADR_VAR	;Endere�o 3 da EEPROM na vari�vel aux
		call	LER_EEPROM
		movf	EEDATA_VAR, W	;Conte�do da EEPROM para W 
		movwf   PORTB		;Transfere para Porta B
		goto	OPCAO
    
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
		
LER_EEPROM:	movf	EEADR_VAR, W
		movwf	EEADR		;Endere�o colocado em EEADR_VAR ser� lido
		bsf	STATUS, RP0	;Banco 1
		bsf	EECON1, RD	;Comando para ler EEPROM
		bcf	STATUS, RP0	;Banco 0
		movf	EEDATA, W
		movwf	EEDATA_VAR	;Move conte�do da EEPROM para EEDATA_VAR
		return
		
FIM:		
		END			;Fim do programa