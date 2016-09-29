;**********************************************
;Simula��o com 1 interrup��o
	    
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
		movlw	0xFF		;Porta B entrada
		movwf	TRISB		;Porta B entrada em todos os bits
		clrf	TRISA		;Porta A sa�da em todos os bits
		movlw	b'01000000'	;Interrup��o ser� na borda de subida
		movwf	OPTION_REG
		bcf	STATUS, RP0	;Banco 0
		
		movlw	b'10010000'	;Primeiro bit ativa interrup��es
					;e segundo bit ativa RB0/INT
		movwf	INTCON		
					
NADA:		sleep			;Estado de repouso
		goto	NADA		;Ao voltar da interrup��o, volta
					;a ficar em repouso
					
					;Programa de tratamento da interrup��o
					
INT:		btfss	PORTB, 1	;Salta se RB1 estiver ativo
		goto	ZEROS		;� zero
		goto	UNS		;� 1
		
ZEROS:		movlw	00		;Move-se zeros
		goto	SEGUIR
		
UNS:		movlw	b'00011111'	;Move-se uns
		goto	SEGUIR
		
SEGUIR:		movwf	PORTA		;� Porta A
		bcf	INTCON, INTF	;Desativa flag de interrup��o
		retfie
		
		END