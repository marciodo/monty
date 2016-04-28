;Área de constantes
STATUS		EQU	0x03		;Registro de estado
PORTA		EQU	0x05		;Porta A
PORTB		EQU	0x06		;Porta B
OPTION_REG	EQU	0x01		;Timer0 e Option
INTCON		EQU	0x0B

EECON1		EQU	88h		;Etiquetas de registros
EECON2		EQU	89h		;para a EEPROM
EEDATA		EQU	08h
EEADR		EQU	09h
		
;Etiquetas de bits
RP0		EQU	5
EEIE		EQU	6
WREN		EQU	2
WR		EQU	1
RD		EQU	0
F		EQU	1
W		EQU	0
Z	        EQU	2    


