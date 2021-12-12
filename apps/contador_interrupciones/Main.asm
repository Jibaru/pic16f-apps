LIST P=PIC16F628
INCLUDE <P16F628.INC>

    VAR1    EQU	    0x6F
    ORG	    0x00
    GOTO    INICIO
    ORG	    0x04
    GOTO    INTERRUP
INICIO ;Configurando Puerto B
    BSF	    STATUS, RP0
    CLRF    TRISB
    BSF	    TRISB,0
    BCF	    STATUS, RP0
    ;Configurar Interrupción
    BSF	    INTCON, GIE ; Hab.Int.General
    BSF	    INTCON, INTE ; Hab.Int. RB0
    BSF	    STATUS, RP0
    BCF	    OPTION_REG, INTEDG; BAJADA
    BCF	    STATUS, RP0
    CLRF    PORTB
    CLRF    VAR1

BUCLE
    NOP
    NOP
    GOTO    BUCLE

INTERRUP
    BCF	    INTCON,1
    INCF    VAR1,1
    MOVLW   0x0A
    XORWF   VAR1,0
    BTFSS   STATUS,Z
    GOTO    PRES
    CLRF    VAR1

PRES
    SWAPF   VAR1, W
    MOVWF   PORTB
    RETFIE

END


