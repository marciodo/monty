;**********************************************
;Dado de 6 lados no display de 7 segmentos
	    
		LIST    P=16F84A	;Tipo de dispositivo
		INCLUDE "p16f84a.inc"	;Defini��o de registros
	    
NUMERO		EQU	0x0c
Delay_Cont	EQU	0x0d
Temporal	EQU	0x0e
	    
		ORG	0		;Vetor de reset
		goto    INICIO

		ORG	5		;Saltamos o vetor
					;de interrup��o
	    
;Come�o do programa
INICIO:		clrf    PORTB
		bsf	STATUS, RP0	;Banco 1
		clrf    TRISB		;Porta B sa�da
		movlw   b'00011111'	;5 pinos de A para entrada
		movwf   TRISA
		movlw	b'00000111'	;Divide-se o timer por 256 obtendo
					;265 us por pulso
		movwf	OPTION_REG
		bcf	STATUS, RP0	;Banco 0
		
LOOP:		clrwdt
		btfss	PORTA, 0	;Salta se RA0 = true
		goto	LOOP
		movf	TMR0, W		;Pega o valor de TMR0 (aleat�rio)
					;e coloca em W
		movwf	NUMERO		;Armazena o dado aleat�rio em NUMERO
		call	Delay_20_ms	;Espera passar efeito rebote
		
;Subtrai 6 n vezes at� que o resultado seja menor que 6. O final do c�digo
;corresponde ao resto da divis�o por 6. Se tiv�ssemos armazenado a
;quantidade de vezes que o loop rodou, ter�amos o resultado da divis�o.
Divide:		movlw	d'6'
		subwf	NUMERO, W	;Subtrai 6 de NUMERO
		movwf	NUMERO		;Armazena de volta em NUMERO
		sublw	d'5'		;Subrtrai 5 de W, sem afetar NUMERO
		btfss	STATUS, C	;Verifica se W � maior que 0.
					;Se for, a divis�o por 6 ainda n�o
					;terminou e fazemos mais um la�o.
		goto	Divide
		incf	NUMERO, F	;O resultado anterior vai de 0 a 5.
					;Aqui incrementamos para obter algo
					;entre 1 e 6.
					
Dado:		movlw	d'6'
		movwf	Temporal
RA0_1:		clrwdt
		btfss	PORTA, 0	;Salta se RA0 = True
		goto	SAIDA
		movf	Temporal, W	;Valor de Temporal em W corresponde
					;� posi��o dentro da tabela
		call	TABELA
		movwf	PORTB		;Joga o valor da tabela no display
		movlw	d'1'
		movwf	Delay_Cont
		call	Delay_var	;Aguarda 50 ms
		decfsz	Temporal, F	;Decrementa Temporal e salta se zero
		goto	RA0_1		;Se n�o for zero, continua decremento
		goto	Dado		;Se for zero pula para Dado para
					;reabastecer com 6
		call	Delay_20_ms	;Aguarda 20 ms para eliminar rebote
		
TABELA:		addwf   PCL, F		;Adiciona o valor em W no contador da
					;sub-rotina para saltar ao valor
					;desejado na tabela.
		retlw   b'00111111'
		retlw   b'00000110'
		retlw   b'01011011'
		retlw   b'01001111'
		retlw   b'01100110'
		retlw   b'01101101'
		retlw   b'01111101'
	  
;Temporiza��o de 20ms para tirar efeito rebote da chave mec�nica
Delay_20_ms:	bcf	INTCON, T0IF	;Limpa a flag de interrup��o de TMR0
		movlw	0xb1		;256-78, para contar 78 x 256 us = 20 ms
		movwf	TMR0
Delay_20_ms_1:	clrwdt
		btfss	INTCON, T0IF	;Salta se houver interrup��o de TMR0
		goto	Delay_20_ms_1
		return
		
;Temporiza��o de 50ms para mudar de um n�mero para outro no display
Delay_var:	bcf	INTCON, T0IF	;Limpa a flag de interrup��o de TMR0
		movlw   0x3c		;256-196, para contar 196 x 256 us = 50 ms
		movwf	TMR0
Intervalo:	clrwdt
		btfss	INTCON, T0IF	;Salta se houver interrup��o de TMR0
		goto	Intervalo
		;Delay_Cont � usado para multiplicar a quantidade de 50 ms
		;que se deseja
		decfsz	Delay_Cont, F	;Decrementa contador e salta se for 0
		goto	Delay_var
		return

SAIDA:		movf	NUMERO, W	;N�mero aleat�rio vai para W, para
					;puxar dado correspondente na tabela
		call	TABELA
		movwf	PORTB		;Coloca o valor da tabela no display
		movlw	d'60'		;60 vai ser usado para multiplicar os
					;50 ms...
		movwf	Delay_Cont	;... que se armazena em Delay_Cont
		call	Delay_var	;Aguarda 60 * 50 ms = 3 s
		clrf	PORTB		;Limpa display
		
		goto	LOOP
		
		END			;Fim do programa
