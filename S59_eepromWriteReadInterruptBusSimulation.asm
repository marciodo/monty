;**********************************************
;Escrita de EEPROM com interrup��o, simulando contador de pessoas no �nibus
	    
		LIST    P=16F84A	;Tipo de dispositivo
		RADIX	HEX		;Sistema de numera��o hexadecimal
		INCLUDE "p16f84a.inc"	;Defini��o de registros
		; CONFIG
		 __config 0xFFFB
		;__CONFIG _FOSC_EXTRC & _WDTE_OFF & _PWRTE_OFF & _CP_OFF
			    
;Vari�veis
EEADR_VAR	EQU	0X0C
EEDATA_VAR	EQU	0x0D
	
		ORG	0		;Vetor de reset
		goto    INICIO
		ORG	4		;Vetor de interrup��
		goto	INTER
		ORG	5		;Saltamos o vetor
					;de interrup��o
			
;Come�o do programa
INICIO:		bsf	STATUS, RP0	;Banco 1
		clrf	TRISB		;Porta B sa�da em todos os bits
		movlw	0x1F		;Porta A entrada
		movwf	TRISA
		bcf	STATUS, RP0	;Banco 0
		movlw	b'11000000'	;Bit 7 = GIE (Global Interrupt Enable)
					;Bit 6 = EEIE (EE Write Complete Interrupt Enable)
		movwf	INTCON
		
		call	LER		;L� EEPROM e mostra na porta B
		
OPCAO:		btfss	PORTA, 0	;Op��o a tomar
		goto	SOMAR		;Se RA0=0, n�o � o in�cio da semana
		goto	INICIAR		;Se RA0=1, � o in�cio da semana
		
SOMAR:		btfss	PORTA, 1	;Apertou-se o bot�o?
		goto	SOMAR		;N�o, continua esperando
		incf	EEDATA_VAR, F	;Sim, aumentar contador de pessoas e gravar na EEPROM
		call	ESCREVER
		goto	SOMAR		;Continuar contando pessoas
		
INICIAR:	clrf	EEDATA_VAR	;Iniciar contador
		call	ESCREVER
		goto	SOMAR		;Come�a a contagem
		
LER:		movlw	00
		movwf	EEADR_VAR	;Endere�o 0 da EEPROM na vari�vel aux
		call	LER_EEPROM
		movf	EEDATA_VAR, W	;Conte�do da EEPROM para W 
		movwf   PORTB		;Transfere para Porta B
		return
		
LER_EEPROM:	movf	EEADR_VAR, W
		movwf	EEADR		;Endere�o colocado em EEADR_VAR ser� lido
		bsf	STATUS, RP0	;Banco 1
		bsf	EECON1, RD	;Comando para ler EEPROM
		bcf	STATUS, RP0	;Banco 0
		movf	EEDATA, W
		movwf	EEDATA_VAR	;Move conte�do da EEPROM para EEDATA_VAR
		return
		
ESCREVER:	movlw	00		;Endere�o a escrever
		movwf	EEADR_VAR	;vai em vari�vel auxiliar
		call	ESCREVER_EEPROM
		return
    
ESCREVER_EEPROM:movf	EEADR_VAR, W	;Move o endere�o		
		movwf	EEADR		;ao seu registro
		movf	EEDATA_VAR, W	;Move o dado
		movwf	EEDATA		;ao seu registro
		bsf	STATUS, RP0	;Banco 1
		bcf	INTCON, GIE	;Proibem-se interrup��es
		bsf	EECON1, WREN	;Fornece permiss�o de escrita
					;na EEPROM
		;Sequ�ncia de seguran�a obrigat�ria para gravar na EEPROM:
		;escrever 55h e AAh em EECON2
		movlw	0x55
		movwf	EECON2
		movlw	0xAA
		movwf	EECON2
		bsf	INTCON, GIE	;Permitem-se interrup��es
		bsf	EECON1, WR	;Comando para salvar na EEPROM
		sleep			;Vai-se ao estado de repouso do qual
					;se sair� com uma interrup��o
		return
		
INTER:		bcf	EECON1, EEIF	;Desce a bandeira
		bcf	EECON1, WREN	;Desabilita��o de escrita
		bcf	STATUS, RP0	;Banco 0
		retfie			;Volta da interrup��o
		
FIM:		
		END			;Fim do programa