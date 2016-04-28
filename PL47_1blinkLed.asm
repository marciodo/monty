;**********************************************
;Programa que pisca o led D1 a cada segundo
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    
;�rea de constantes
STATUS	    EQU	    0x03
PORTA	    EQU	    0x05
PORTB	    EQU	    0x06
RP0	    EQU	    0x05
OPTION_REG  EQU	    0x01	;Timer0 e Option
INTCON	    EQU	    0x0B
TEMPO1	    EQU	    0x0C	;Registro de prop�sito
				;geral
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO
	    
	    ORG	    5		;Saltamos o vetor
				;de interrup��o
	    
;Come�o do programa
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    clrf    PORTB	;Porta B sa�da
	    movlw   b'00000111'
	    movwf   OPTION_REG	;Divide-se o timer por 256 obtendo 
				;256 us por pulso
	    bcf	    STATUS, RP0	;Banco 0
	    clrf    PORTB	;Zera sa�da
	    
LOOP:	    bsf	    PORTB, 0	;Acende o led
	    call    DELAY1S	;Aguarda 1 s
	    bcf	    PORTB, 0	;Apaga o led
	    call    DELAY1S	;Aguarda 1 s
	    goto    LOOP
	    
DELAY1S:    bcf	    STATUS, RP0 ;Banco 0
	    movlw   0x64
	    movwf   TEMPO1	;N�mero 100 no registrador TEMPO1
	    call    DEL10
	    return
	    
DEL10:	    bcf	    INTCON, 2	;Zera flag de interrup��o do timer
	    movlw   0xD8
	    movwf   OPTION_REG	;Move 216 para o timer, que ir� contar at�
				;255, ou seja, conta 39 pulsos de 256 us,
				;ou 9.984 ms.
	   
DEL10_1:    btfss   INTCON, 2	;Verifica se houve interrup��o de timer
	    goto    DEL10_1
	    decfsz  TEMPO1, 1	;Somente entra no return ap�s repeti��o de
				;100 vezes os 9.984 ms.
	    goto    DEL10
	    return
	    
	    END			;Fim do programa