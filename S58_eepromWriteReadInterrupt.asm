;**********************************************
;Escrita de EEPROM com interrupção
	    
		LIST    P=16F84A	;Tipo de dispositivo
		RADIX	HEX		;Sistema de numeração hexadecimal
		INCLUDE "p16f84a.inc"	;Definição de registros
		; CONFIG
		__config 0xFFFB
		;__CONFIG _FOSC_EXTRC & _WDTE_OFF & _PWRTE_OFF & _CP_OFF
			    
;Variáveis
EEADR_VAR	EQU	0X0C
EEDATA_VAR	EQU	0x0D
	
		ORG	0		;Vetor de reset
		goto    INICIO
		ORG	4		;Vetor de interrupçã
		goto	INTER
		ORG	5		;Saltamos o vetor
					;de interrupção
			
;Começo do programa
INICIO:		bsf	STATUS, RP0	;Banco 1
		clrf	TRISB		;Porta B saída em todos os bits
		movlw	0x1F		;Porta A entrada
		movwf	TRISA
		bcf	STATUS, RP0	;Banco 0
		
OPCAO:		btfss	PORTA, 4	;Opção a tomar
		goto	ESCREVER	;Se RA4=0, escreve
		goto	LER		;Se RA4=1, lê
		
ESCREVER:	movlw	03		;Endereço a escrever
		movwf	EEADR_VAR	;vai em variável auxiliar
		movf	PORTA, W	;Valor na Porta A
		movwf	EEDATA_VAR	;vai em variável auxiliar
		movlw	b'11000000'	;Bit 7 = GIE (Global Interrupt Enable)
					;Bit 6 = EEIE (EE Write Complete Interrupt Enable)
		movwf	INTCON
		call	ESCREVER_EEPROM
		goto	OPCAO
		
LER:		movlw	03
		movwf	EEADR_VAR	;Endereço 3 da EEPROM na variável aux
		call	LER_EEPROM
		movf	EEDATA_VAR, W	;Conteúdo da EEPROM para W 
		movwf   PORTB		;Transfere para Porta B
		goto	OPCAO
    
ESCREVER_EEPROM:movf	EEADR_VAR, W	;Move o endereço		
		movwf	EEADR		;ao seu registro
		movf	EEDATA_VAR, W	;Move o dado
		movwf	EEDATA		;ao seu registro
		bsf	STATUS, RP0	;Banco 1
		bcf	INTCON, GIE	;Proibem-se interrupções
		bsf	EECON1, WREN	;Fornece permissão de escrita
					;na EEPROM
		;Sequência de segurança obrigatória para gravar na EEPROM:
		;escrever 55h e AAh em EECON2
		movlw	0x55
		movwf	EECON2
		movlw	0xAA
		movwf	EECON2
		bsf	INTCON, GIE	;Permitem-se interrupções
		bsf	EECON1, WR	;Comando para salvar na EEPROM
		sleep			;Vai-se ao estado de repouso do qual
					;se sairá com uma interrupção
		return
		
LER_EEPROM:	movf	EEADR_VAR, W
		movwf	EEADR		;Endereço colocado em EEADR_VAR será lido
		bsf	STATUS, RP0	;Banco 1
		bsf	EECON1, RD	;Comando para ler EEPROM
		bcf	STATUS, RP0	;Banco 0
		movf	EEDATA, W
		movwf	EEDATA_VAR	;Move conteúdo da EEPROM para EEDATA_VAR
		return
		
INTER:		bcf	EECON1, EEIF	;Desce a bandeira
		bcf	EECON1, WREN	;Desabilitação de escrita
		bcf	STATUS, RP0	;Banco 0
		retfie			;Volta da interrupção
		
FIM:		
		END			;Fim do programa