;**********************************************
;Simula��o com v�rias interrup��es
	    
		LIST    P=16F84A	;Tipo de dispositivo
		RADIX	HEX		;Sistema de numera��o hexadecimal
		INCLUDE "p16f84a.inc"	;Defini��o de registros
		 __config 0xFFFB
		;__CONFIG _FOSC_EXTRC & _WDTE_OFF & _PWRTE_OFF & _CP_OFF
	
;Vari�veis
EEADR_VAR	EQU	0X0C
EEDATA_VAR	EQU	0x0D
SALVAR_VAR	EQU	0x0E
	
		ORG	0		;Vetor de reset
		goto	INICIO
		ORG	4		;Posi��o do vetor de interrup��o
		goto	INT
		ORG	5
		
;Programa de tratamento de interrup��o
INT:		btfsc	INTCON, RBIF	;Salta se interrup��o n�o for por RB4-7
		goto	T_RB4_RB7
		btfsc	INTCON, INTF	;Salta se interrup��o n�o for por RB0
		goto	T_RB0		
		btfsc	INTCON, T0IF	;Salta se interrup��o n�o for por TMR0
		goto	T_TMR0
		goto	T_EEPROM	;Se n�o foi nenhuma das anteriores, � por EEPROM
    
T_RB4_RB7:	swapf	PORTB, W	;O valor dos bits de mais peso passa aos
					;bits de menor peso
		andlw	b'00001111'	;Exclui-se o valor dos bits mais significativos
		movwf	PORTA		;Coloca-se o valor dos alarmes em PORTA
		movlw	b'00111101'	;Carrega o valor 256-195 (para 195 ms)...
		movwf	TMR0		;... em Timer 0
		bsf	INTCON, T0IE	;Ativa interrup��o do TMR0
		bsf	SALVAR_VAR, 0	;Escreve 1 em SALVAR_VAR
		bsf	PORTA, 4	;Ativa alarme sonoro em RA4
		goto	VOLTAR
		
T_RB0:		bcf	PORTA, 4	;Desativa alarme sonoro
		bcf	INTCON, T0IE	;Destativa interrup��o do TMR0
		bcf	INTCON, RBIE	;Destativa interrup��o das portas RB4-7
		goto	VOLTAR
		
T_TMR0:		movf	PORTA, W	;L� PORTA
		xorlw	b'00010000'	;Inverte sa�da do alarme sonoro
		movwf	PORTA
		movlw	b'00111101'	;Carrega o valor 256-195 (para 195 ms)...
		movwf	TMR0		;... em Timer 0
		goto	VOLTAR
		
T_EEPROM:	bcf	SALVAR_VAR, 0	;Limpa indica��o de SALVAR_VAR depois que dado
					;j� est� gravado na EEPROM
		goto	VOLTAR
		
VOLTAR:		movf	INTCON, W
		andlw	b'11110000'	;Remove os bits menos significativos, 
					;correspondentes �s bandeiras de interrup��o
		movwf	INTCON
		bsf	STATUS, RP0	;Banco 1
		bcf	EECON1, EEIF	;Desce bandeira de interrup��o de EEPROM
		bcf	STATUS, RP0	;Banco 0
		retfie			;Retorna da interrup��o

		
;Programa principal	
INICIO:		bsf	STATUS, RP0	;Banco 1
		movlw	0xFF		;Porta B entrada em todos os bits
		movwf	TRISB	
		movlw	00		;Porta A entrada em todos os bits
		movwf	TRISA
		movlw	b'01000111'	;TMR0 com divisor de 256 e borda de subida...
		movwf	OPTION_REG	;... para interrup��o.
		movlw	b'11011000'	;Primeiro bit ativa interrup��es gerais
					;e demais outras interrup��es
		movwf	INTCON
		bcf	STATUS, RP0	;Banco 0
					
LOOP:		btfss	SALVAR_VAR, 0	;Salta se SALVAR_VAR=1
		goto	LOOP
		goto	SALVAR
		
SALVAR:		movlw	03
		movwf	EEADR_VAR	;Endere�o 3 da EEPROM na vari�vel aux
		swapf	PORTB, W	;Passa-se o valor a escrever, que s�o
					;os bits de mais peso
		andlw	b'00001111'	;Exclui-se o valor dos bits mais
					;significativos
		movwf	EEDATA_VAR	;a uma vari�vel auxiliar
		call	ESCREVER_EEPROM
    
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
		bcf	EECON1, WREN	;Desabilita��o da escrita
		bcf	STATUS, RP0	;Banco 0
		return
		
		END