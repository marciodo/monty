;**********************************************
;Rota��o sequencial dos leds na sa�da da porta B
		
		LIST    P=16F84A	;Tipo de dispositivo
		INCLUDE "p16f84a.inc"	;Defini��o de registros
	    
Contador	EQU	0x0c
	    
		ORG	0		;Vetor de reset
		goto    INICIO

		ORG	5		;Saltamos o vetor
					;de interrup��o

;**********************************************
;ROTINA DE DELAY DE 250 MS
Delay:		movlw	.10
		movwf	Contador	;Repetir� 10 vezes um temporizador de 25 ms
Delay_0:	bcf	INTCON, T0IF	;Limpa a flag de interrup��o de TMR0
		movlw	0x3c		;255-60, para contar 195 x 128 us = 24.960 ms
		movwf	TMR0		;pois estamos usando pre-scaler de 128
Delay_1:	clrwdt
		btfss	INTCON, T0IF	;Salta se houver interrup��o de TMR0
		goto	Delay_1
		decfsz	Contador, F	;Decrementa contador e salta se for 0
		goto	Delay_0
		return
					
;**********************************************
;COME�O DO PROGRAMA PRINCIPAL
INICIO:		clrf    PORTB
		bsf	STATUS, RP0	;Banco 1
		clrf    TRISB		;Porta B sa�da
		movlw   b'00011111'	;5 pinos de A para entrada
		movwf   TRISA
		movlw	b'00000110'	;Divide-se o timer por 128 obtendo
					;128 us por pulso
		movwf	OPTION_REG
		bcf	STATUS, RP0	;Banco 0
		
		bsf	STATUS, C	;Ativa flag de carry on
		
LOOP:		call	Delay		;Aguarda 25 ms
		btfsc	PORTA, 0	;Salta se RA0 = false
		goto	A_DIREITA
A_ESQUERDA:	rlf	PORTB, F	;Rola bits para esquerda, pegando 
					;bit de carry on
		goto	LOOP
A_DIREITA:	rrf	PORTB, F	;Rola bits para direita
		goto	LOOP
		
		END			;Fim do programa