;**********************************************
;Programa que espera uma combinação
;dos interruptores de entrada sw1-sw5
;para ligar todos os leds: D1-D8.
;A combinação a introduzir é 1-0-1-0-1
	    
	    LIST    P=16F84A	;Tipo de dispositivo
	    
;Área de constantes
STATUS	    EQU	    0x03
PORTA	    EQU	    0x05
PORTB	    EQU	    0x06
RP0	    EQU	    0x05
Z	    EQU	    0X02
	    
	    ORG	    0		;Vetor de reset
	    goto    INICIO
	    
	    ORG	    5		;Saltamos o vetor
				;de interrupção
	    
;Começo do programa
INICIO:	    bsf	    STATUS, RP0	;Banco 1
	    clrf    PORTB
	    movlw   b'00011111'
	    movwf   PORTA
	    bcf	    STATUS, RP0	;Banco 0
	    clrf    PORTB
	    
;Loop que espera a combinação 1-0-1-0-1
LOOP:	    movf    PORTA, W
	    andlw   b'00011111'
	    xorlw   b'00010101'
	    btfss   STATUS, Z
	    goto    LOOP
	    
	    movlw   0xFF
	    movwf   PORTB
	    
FIM:	    goto FIM
    
 ;Clicar o reset para voltar
 ;a executar o programa
 
	    END			;Fim do programa