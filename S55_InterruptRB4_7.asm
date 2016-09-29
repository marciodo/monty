;**********************************************
;Simulação com interrupção de RB4 - RB7
	    
		LIST    P=16F84A	;Tipo de dispositivo
		INCLUDE "p16f84a.inc"	;Definição de registros
		__config 0x3FF9
	
		ORG	0		;Vetor de reset
		goto	INICIO
		ORG	4		;Posição do vetor de interrupção
		goto	INT
		ORG	5
					;Programa principal
			
INICIO:		bsf	STATUS, RP0	;Banco 1
		movlw	0xF0		;RB4-7 entradas e resto saída
		movwf	TRISB
		clrf	TRISA		;Porta A saída em todos os bits
		movlw	b'01000000'	;Interrupção será na borda de subida
		movwf	OPTION_REG
		bcf	STATUS, RP0	;Banco 0
		
		clrf	PORTB		;Limpa porta B
		
		movlw	b'10001000'	;Primeiro bit ativa interrupções
					;e segundo bit ativa RB4-7
		movwf	INTCON		
					
NADA:		sleep			;Estado de repouso
		goto	NADA		;Ao voltar da interrupção, volta
					;a ficar em repouso
					
					;Programa de tratamento da interrupção
					
INT:		swapf	PORTB, W	;O valor dos bits de mais peso se passa
					;aos bits de menos peso
		movwf	PORTA		;Passa o valor dos alarmes à PORTA
		bsf	PORTA, 4	;Ativa-se o zumbidor, situado em RA4
    
		bcf	INTCON, INTF	;Desativa flag de interrupção
		retfie
		
		END