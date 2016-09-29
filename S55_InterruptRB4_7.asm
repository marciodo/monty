;**********************************************
;Simula��o com interrup��o de RB4 - RB7
	    
		LIST    P=16F84A	;Tipo de dispositivo
		INCLUDE "p16f84a.inc"	;Defini��o de registros
		__config 0x3FF9
	
		ORG	0		;Vetor de reset
		goto	INICIO
		ORG	4		;Posi��o do vetor de interrup��o
		goto	INT
		ORG	5
					;Programa principal
			
INICIO:		bsf	STATUS, RP0	;Banco 1
		movlw	0xF0		;RB4-7 entradas e resto sa�da
		movwf	TRISB
		clrf	TRISA		;Porta A sa�da em todos os bits
		movlw	b'01000000'	;Interrup��o ser� na borda de subida
		movwf	OPTION_REG
		bcf	STATUS, RP0	;Banco 0
		
		clrf	PORTB		;Limpa porta B
		
		movlw	b'10001000'	;Primeiro bit ativa interrup��es
					;e segundo bit ativa RB4-7
		movwf	INTCON		
					
NADA:		sleep			;Estado de repouso
		goto	NADA		;Ao voltar da interrup��o, volta
					;a ficar em repouso
					
					;Programa de tratamento da interrup��o
					
INT:		swapf	PORTB, W	;O valor dos bits de mais peso se passa
					;aos bits de menos peso
		movwf	PORTA		;Passa o valor dos alarmes � PORTA
		bsf	PORTA, 4	;Ativa-se o zumbidor, situado em RA4
    
		bcf	INTCON, INTF	;Desativa flag de interrup��o
		retfie
		
		END