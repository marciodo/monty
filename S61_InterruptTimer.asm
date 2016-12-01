;**********************************************
;Simulação com 1 interrupção
	    
		LIST    P=16F84A	;Tipo de dispositivo
		RADIX	HEX		;Sistema de numeração hexadecimal
		INCLUDE "p16f84a.inc"	;Definição de registros
		 __config 0xFFFB
		;__CONFIG _FOSC_EXTRC & _WDTE_OFF & _PWRTE_OFF & _CP_OFF
	
		ORG	0		;Vetor de reset
		goto	INICIO
		ORG	4		;Posição do vetor de interrupção
		goto	INT
		ORG	5
		
;Programa de tratamento de interrupção
INT:		movf	PORTB, 0
		xorlw	b'00000010'	;Inverte o valor do led em RB1
		movwf	PORTB
		movlw	b'00111101'	;Carrega o valor 256-195 (para 195 ms)...
		movwf	TMR0		;... em Timer 0
		bcf	INTCON, T0IF	;Zera bandeira de interrupção
		retfie			;Retorna da interrupção

		
;Programa principal	
INICIO:		bsf	STATUS, RP0	;Banco 1
		movlw	b'00000000'	;Porta B saída em todos os bits
		movwf	TRISB	
		movlw	b'00000001'	;RA0 entrada, resto saída
		movwf	TRISA		;Porta A saída em todos os bits
		movlw	b'00000111'	;TMR0 com divisor de 256
		movwf	OPTION_REG
		bcf	STATUS, RP0	;Banco 0
		
		movlw	b'10100000'	;Primeiro bit ativa interrupções gerais
					;e segundo bit ativa interrupção por timer
		movwf	INTCON		
		movlw	b'00111101'	;Carrega o valor 256-195 (para 195 ms)...
		movwf	TMR0		;... em Timer 0
					
LOOP:		btfss	PORTA, 0	;Salta se RA0=1
		goto	DESLIGAR
		goto	LIGAR
		
DESLIGAR:	bcf	PORTB, 0
		goto	LOOP
		
LIGAR:		bsf	PORTB, 0
		goto	LOOP
		
		END