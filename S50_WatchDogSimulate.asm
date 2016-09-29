;**********************************************
;Simulação com watch dog
	    
		LIST    P=16F84A	;Tipo de dispositivo
		INCLUDE "p16f84a.inc"	;Definição de registros
		__config 0x3FFD
	
		ORG	0		;Vetor de reset
			
		bsf	STATUS, RP0	;Banco 1
		clrf	TRISB		;Porta B saída em todos os bits
		movlw	b'00011111'	;Porta A entrada
		movwf	TRISA
		movlw	b'00001000'	;Timer para o watchdog
		movwf	OPTION_REG
		bcf	STATUS, RP0	;Banco 0
		
		clrf	PORTB		;Limpa porta B
		
LOOP:		clrwdt			;Iniciação do cão de guarda
		comf	PORTA, W	;Complemento da porta A e
					;armazenamento em W
		movwf	PORTB		;Move W para porta B
		goto	LOOP
		
		END