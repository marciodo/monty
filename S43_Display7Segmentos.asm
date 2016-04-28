	    LIST    P=16F84A
	    RADIX   HEX

W	    EQU	    0
F	    EQU	    1
PCL	    EQU	    0x02
STATUS	    EQU	    0x03
PORTA	    EQU	    0x05
PORTB	    EQU	    0x06
RP0	    EQU	    0x05
TRISA	    EQU	    0x85
TRISB	    EQU	    0x86
	
	    ORG	    0		; O programa come�a no
	    goto    INICIO	; endere�o 0
	
INICIO	    bsf	    STATUS, RP0 ; Passa-se ao banco 1
	    movlw   B'00000000' ; Porta B sa�da
	    movwf   TRISB
	    movlw   B'00000111' ; RA0-RA2 entradas, resto sa�da
	    movwf   TRISA
	    bcf	    STATUS, RP0 ; Mudan�a banco 0
	
LOOP	    movf    PORTA, W    ; L� o valor dos interruptores
	    call    BIN_7SEG    ; Chama a rotina de transforma��o
	    movwf   PORTB	; Escreve no display
	    goto    LOOP
	
BIN_7SEG    addwf   PCL, F	; Soma-se o valor do �ndice PCL
	    retlw   3F		; Devolve-se o 0 transformado
	    retlw   06		; Devolve-se o 1 transformado
	    retlw   5B		; Devolve-se o 2 transformado
	    retlw   4F		; Devolve-se o 3 transformado
	    retlw   66		; Devolve-se o 4 transformado
	    retlw   6D		; Devolve-se o 5 transformado
	    retlw   7D		; Devolve-se o 6 transformado
	    retlw   07		; Devolve-se o 7 transformado
	    
	    END