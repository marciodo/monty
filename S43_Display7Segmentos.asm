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
	
	    ORG	    0		; O programa começa no
	    goto    INICIO	; endereço 0
	
INICIO	    bsf	    STATUS, RP0 ; Passa-se ao banco 1
	    movlw   B'00000000' ; Porta B saída
	    movwf   TRISB
	    movlw   B'00000111' ; RA0-RA2 entradas, resto saída
	    movwf   TRISA
	    bcf	    STATUS, RP0 ; Mudança banco 0
	
LOOP	    movf    PORTA, W    ; Lê o valor dos interruptores
	    call    BIN_7SEG    ; Chama a rotina de transformação
	    movwf   PORTB	; Escreve no display
	    goto    LOOP
	
BIN_7SEG    addwf   PCL, F	; Soma-se o valor do índice PCL
	    retlw   3F		; Devolve-se o 0 transformado
	    retlw   06		; Devolve-se o 1 transformado
	    retlw   5B		; Devolve-se o 2 transformado
	    retlw   4F		; Devolve-se o 3 transformado
	    retlw   66		; Devolve-se o 4 transformado
	    retlw   6D		; Devolve-se o 5 transformado
	    retlw   7D		; Devolve-se o 6 transformado
	    retlw   07		; Devolve-se o 7 transformado
	    
	    END