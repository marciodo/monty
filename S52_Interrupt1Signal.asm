;**********************************************
;Simulação com 1 interrupção
	    
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
		movlw	0xFF		;Porta B entrada
		movwf	TRISB		;Porta B entrada em todos os bits
		clrf	TRISA		;Porta A saída em todos os bits
		movlw	b'01000000'	;Interrupção será na borda de subida
		movwf	OPTION_REG
		bcf	STATUS, RP0	;Banco 0
		
		movlw	b'10010000'	;Primeiro bit ativa interrupções
					;e segundo bit ativa RB0/INT
		movwf	INTCON		
					
NADA:		sleep			;Estado de repouso
		goto	NADA		;Ao voltar da interrupção, volta
					;a ficar em repouso
					
					;Programa de tratamento da interrupção
					
INT:		btfss	PORTB, 1	;Salta se RB1 estiver ativo
		goto	ZEROS		;É zero
		goto	UNS		;É 1
		
ZEROS:		movlw	00		;Move-se zeros
		goto	SEGUIR
		
UNS:		movlw	b'00011111'	;Move-se uns
		goto	SEGUIR
		
SEGUIR:		movwf	PORTA		;à Porta A
		bcf	INTCON, INTF	;Desativa flag de interrupção
		retfie
		
		END