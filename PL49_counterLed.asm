;**********************************************
;Programa que incrementa um contador a cada vez
;que a chave 1 vai e volta, mostrando resultado
;em 8 leds.
	    
		LIST    P=16F84A	;Tipo de dispositivo
	    
;Área de constantes
STATUS		EQU	0x03
PORTA		EQU	0x05
PORTB		EQU	0x06
RP0		EQU	0x05
OPTION_REG	EQU	0x01		;Timer0 e Option
INTCON		EQU	0x0B
CONTADOR	EQU	0x0D		;Registro de propósito
					;geral
	    
		ORG	0		;Vetor de reset
		goto    INICIO
	    
		ORG	5		;Saltamos o vetor
					;de interrupção
	    
;Começo do programa
INICIO:		bsf	STATUS, RP0	;Banco 1
		movlw   0x01
		movwf   PORTA		;Bit 1 da porta A entrada
		clrf    PORTB		;Porta B saída
		movlw   b'00000111'
		movwf   OPTION_REG	;Divide-se o timer por 256 obtendo 
					;265 us por pulso
		bcf	STATUS, RP0	;Banco 0
		clrf    PORTB		;Zera saída
		clrf    CONTADOR	;Zera o contador
	    
LOOP:		btfss   PORTA, 0	;Espera chave 1 ir a 1
		goto    LOOP
		call    ANTIREBOTES
	    
LOOP2:		btfsc   PORTA, 0	;Espera chave 1 ir a 0
		goto    LOOP2
		call    ANTIREBOTES
	    
		incf    CONTADOR, F	;Incrementa contador
		movf    CONTADOR, W	;Transfere contador a W
		movwf   PORTB		;Contador vai à saída
	    
		goto    LOOP
	    
;Rotina para solucionar, por software, os problemas
;de rebotes dos interruptores
ANTIREBOTES:	bcf	INTCON, 2	;Zera flag de interrupção do timer
		movlw   0xB0
		movwf   OPTION_REG	;Move 176 para o timer, que irá contar até
					;255, ou seja, conta 79 pulsos de 256 us,
					;ou 20 ms.
					
DEL:		btfss	INTCON, 2	;Verifica se houve interrupção de timer
		goto	DEL
		return
	    
		END			;Fim do programa