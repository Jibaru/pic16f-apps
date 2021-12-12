list p=16f628A		; Define el procesador
#include <p16f628A.inc> ; Contiene las Variable del Procesador
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_ON & _PWRTE_ON & _INTOSC_OSC_NOCLKOUT & _LVP_OFF & _MCLRE_ON

    ; INPUTS
    ; I0 = B2
    ; I1 = B3
    ; I2 = B4
    ; I3 = B5
    ;
    ; OUTPUTS
    ;    A
    ;    --
    ; F |  | B
    ;    -- G
    ; E |  | C
    ;    --
    ;    D
    ;
    ; A = A0 = /[/I1./I3.(I0./I2 + /I0.I2)]
    ; B = A1 = /[I2.(I0./I1 + /I0.I1)]
    ; C = A2 = /[/I0.I1./I2./I3]
    ; D = B7 = I3 + /[/[I1./I2]./[I0./I1.I2]./[/I0./I2]./[/I0.I1]]
    ; E = B6 = /[/[/I0./I2]./[/I0.I1]]
    ; F = B0 = /[/[/I0./I1]./[/I1.I2]./[/I0.I2]./I3]
    ; G = B1 = I3 + I2 + I1

    I0		EQU	2
    PORT_I0	EQU	PORTB

    I1		EQU	3
    PORT_I1	EQU	PORTB

    I2		EQU	4
    PORT_I2	EQU	PORTB

    I3		EQU	5
    PORT_I3	EQU	PORTB

    OUT_A	EQU	0
    PORT_A	EQU	PORTA

    OUT_B	EQU	1
    PORT_B	EQU	PORTA

    OUT_C	EQU	2
    PORT_C	EQU	PORTA

    OUT_D	EQU	7
    PORT_D	EQU	PORTB

    OUT_E	EQU	6
    PORT_E	EQU	PORTB

    OUT_F	EQU	0
    PORT_F	EQU	PORTB

    OUT_G	EQU	1
    PORT_G	EQU	PORTB

    ORG	    0x00	; Aquí comienza el PROGRAMA
    GOTO    INICIO	; Salto a inicio de mi programa.

INICIO
    BSF	    STATUS, RP0	; Coloco rp0 a 1 y salto al banco 1, para usar los registros tri
    ; Disposición del puerto A y B (1: input, 0: output)
    ; A: 00000000 = 0
    ; B: 00011110 = ??
    MOVLW   b'00000000'	; Carga la disposición del puerto A al registro W
    MOVWF   TRISA	; Carga el contenido del registro W a TRISA
    MOVLW   b'00111100'	; Carga la disposición del puerto B al registro W
    MOVWF   TRISB	; Carga el contenido del registro W a TRISB
    BCF	    STATUS, RP0	; Coloco rp0 a 0 y regreso al banco 0

LIMPIAR_OUT
    BCF	    PORT_A, OUT_A
    BCF	    PORT_B, OUT_B
    BCF	    PORT_C, OUT_C
    BCF	    PORT_D, OUT_D
    BCF	    PORT_E, OUT_E
    BCF	    PORT_F, OUT_F
    BCF	    PORT_G, OUT_G

GUARDAR_I0
    CLRW
    BTFSC   PORT_I0, I0
    MOVLW   0x1		; Se ejecuta solo si I0 es 1
    MOVWF   0x20

GUARDAR_COMP_IO
    COMF    0x20, 0	; /I0 -> Work File
    MOVWF   0x30	; /I0 -> 0x30

GUARDAR_I1
    CLRW
    BTFSC   PORT_I1, I1
    MOVLW   0x1		; Se ejecuta solo si I1 es 1
    MOVWF   0x21

GUARDAR_COMP_I1
    COMF    0x21, 0	; /I1 -> Work File
    MOVWF   0x31	; /I1 -> 0x31

GUARDAR_I2
    CLRW
    BTFSC   PORT_I2, I2
    MOVLW   0x1		; Se ejecuta solo si I2 es 1
    MOVWF   0x22

GUARDAR_COMP_I2
    COMF    0x22, 0	; /I2 -> Work File
    MOVWF   0x32	; /I2 -> 0x32

GUARDAR_I3
    CLRW
    BTFSC   PORT_I3, I3
    MOVLW   0x1		; Se ejecuta solo si I3 es 1
    MOVWF   0x23

GUARDAR_COMP_I3
    COMF    0x23, 0	; /I3 -> Work File
    MOVWF   0x33	; /I3 -> 0x33

COMP_M1
    ; /[I1./I2]
    CLRW		; Limpiando el Working File
    CLRF    0x34
    MOVF    0x21, 0	; I1 -> Work File
    ANDWF   0x32, 0	; I1./I2 -> Work File
    MOVWF   0x34	; I1./I2 -> 0x34
    COMF    0x34, 1	; /[I1./I2] -> 0x34

COMP_M2
    ; /[I0./I1.I2]
    CLRW		; Limpiando el Working File
    CLRF    0x35
    MOVF    0x20, 0	; I0 -> Work File
    ANDWF   0x31, 0	; I0./I1 -> Work File
    ANDWF   0x22, 0	; I0./I1.I2 -> Work File
    MOVWF   0x35	; I0./I1.I2 -> 0x35
    COMF    0x35, 1	; /[I0./I1.I2] -> 0x35

COMP_M3
    ; /[/I0./I2]
    CLRW		; Limpiando el Working File
    CLRF    0x36
    MOVF    0x30, 0	; /I0 -> Work File
    ANDWF   0x32, 0	; /I0./I2 -> Work File
    MOVWF   0x36	; /I0./I2 -> 0x36
    COMF    0x36, 1	; /[/I0./I2] -> 0x36

COMP_M4
    ; /[/I0.I1]
    CLRW		; Limpiando el Working File
    CLRF    0x37
    MOVF    0x30, 0	; /I0 -> Work File
    ANDWF   0x21, 0	; /I0.I1 -> Work File
    MOVWF   0x37	; /I0.I1 -> 0x37
    COMF    0x37, 1	; /[/I0.I1] -> 0x37

COMP_M5
    ; /[/I1.I2]
    CLRW
    CLRF    0x38
    MOVF    0x31, 0	; /I1 -> Work File
    ANDWF   0x22, 0	; /I1.I2 -> Work File
    MOVWF   0x38	; /I1.I2 -> 0x38
    COMF    0x38, 1	; /[/I1.I2] -> 0x38

COMP_M6
    ; /[/I0.I2]
    CLRW
    CLRF    0x39
    MOVF    0x30, 0	; /I0 -> Work File
    ANDWF   0x22, 0	; /I0.I2 -> Work File
    MOVWF   0x39	; /I0.I2 -> 0x39
    COMF    0x39, 1	; /[/I0.I2] -> 0x39

COMP_M7
    ; /[/I0./I1]
    CLRW		; Limpiando el Working File
    CLRF    0x3A
    MOVF    0x30, 0	; /I0 -> Work File
    ANDWF   0x31, 0	; /I0./I1 -> Work File
    MOVWF   0x3A	; /I0./I1 -> 0x3A
    COMF    0x3A, 1	; /[/I0./I1] -> 0x3A

OPERAR_A
    ; A = /[/I1./I3.(I0./I2 + /I0.I2)]
    CLRW		; Limpiando el Working File (Por si aca :v)
    MOVF    0x32, 0	; /I2 -> Work File
    ANDWF   0x20, 0	; I0./I2 -> Work File
    MOVWF   0x40	; I0./I2 -> 0x40
    MOVF    0x30, 0	; /I0 -> Work File
    ANDWF   0x22, 0	; /I0.I2 -> Work File
    IORWF   0x40, 0	; (I0./I2 + /I0.I2) -> Work File
    ANDWF   0x33, 0	; (I0./I2 + /I0.I2)./I3 -> Work File
    ANDWF   0x31, 0	; /I1./I3.(I0./I2 + /I0.I2) -> Work File
    MOVWF   0x40	; /I1./I3.(I0./I2 + /I0.I2) -> 0x40
    COMF    0x40, 1	; /[/I1./I3.(I0./I2 + /I0.I2)] -> 0x40
    BTFSS   0x40, 0
    BCF	    PORT_A, OUT_A ; Skip si es 1
    BTFSC   0x40, 0
    BSF	    PORT_A, OUT_A ; Skip si es 0
    CLRF    0x40

OPERAR_B
    ; B = /[I2.(I0./I1 + /I0.I1)]
    CLRW		; Limpiando el Working File (Por si aca :v)
    MOVF    0x31, 0	; /I1 -> Work File
    ANDWF   0x20, 0	; I0./I1 -> Work File
    MOVWF   0x40	; I0./I1 -> 0x40
    MOVF    0x30, 0	; /I0 -> Work File
    ANDWF   0x21, 0	; /I0.I1 -> Work File
    IORWF   0x40, 0	; (I0./I1 + /I0.I1) -> Work File
    ANDWF   0x22, 0	; I2.(I0./I1 + /I0.I1) -> Work File
    MOVWF   0x40	; I2.(I0./I1 + /I0.I1) -> 0x40
    COMF    0x40, 1	; /[I2.(I0./I1 + /I0.I1)] -> 0x40
    BTFSS   0x40, 0
    BCF	    PORT_B, OUT_B; Skip si es 1
    BTFSC   0x40, 0
    BSF	    PORT_B, OUT_B; Skip si es 0
    CLRF    0x40

OPERAR_C
    ; C = /[/I0.I1./I2./I3]
    CLRW		; Limpiando el Working File (Por si aca :v)
    MOVF    0x30, 0	; /I0 -> Work File
    ANDWF   0x21, 0	; /I0.I1 -> Work File
    ANDWF   0x32, 0	; /I0.I1./I2 -> Work File
    ANDWF   0x33, 0	; /I0.I1./I2./I3 -> Work File
    MOVWF   0x40	; /I0.I1./I2./I3 -> 0x40
    COMF    0x40, 1	; /[/I0.I1./I2./I3] -> 0x40
    BTFSS   0x40, 0
    BCF	    PORT_C, OUT_C; Skip si es 1
    BTFSC   0x40, 0
    BSF	    PORT_C, OUT_C; Skip si es 0
    CLRF    0x40

OPERAR_D
    ; D = I3 + /[/[I1./I2]./[I0./I1.I2]./[/I0./I2]./[/I0.I1]]
    CLRW		; Limpiando el Work File
    MOVF    0x34, 0	; /[I1./I2] -> Work File
    ANDWF   0x35, 0	; /[I1./I2]./[I0./I1.I2] -> Work File
    ANDWF   0x36, 0	; /[I1./I2]./[I0./I1.I2]./[/I0./I2] -> Work File
    ANDWF   0x37, 0	; /[I1./I2]./[I0./I1.I2]./[/I0./I2]./[/I0.I1] -> Work File
    MOVWF   0x40	; /[I1./I2]./[I0./I1.I2]./[/I0./I2]./[/I0.I1] -> 0x40
    COMF    0x40, 1	; /[/[I1./I2]./[I0./I1.I2]./[/I0./I2]./[/I0.I1]] -> 0x40
    CLRW
    MOVF    0x23, 0	; I3 -> Work File
    IORWF   0x40, 1	; I3 + /[/[I1./I2]./[I0./I1.I2]./[/I0./I2]./[/I0.I1]] -> 0x40
    BTFSS   0x40, 0
    BCF	    PORT_D, OUT_D; Skip si es 1
    BTFSC   0x40, 0
    BSF	    PORT_D, OUT_D; Skip si es 0
    CLRF    0x40

OPERAR_E
    ; E = /[/[/I0./I2]./[/I0.I1]]
    CLRW		; Limpiando el Working File (Por si aca :v)
    MOVF    0x36, 0	; /[/I0./I2] -> Work File
    ANDWF   0x37, 0	; /[/I0./I2]./[/I0.I1] -> Work File
    MOVWF   0x40	; /[/I0./I2]./[/I0.I1] -> 0x40
    COMF    0x40, 1	; /[/[/I0./I2]./[/I0.I1]] -> 0x40
    BTFSS   0x40, 0
    BCF	    PORT_E, OUT_E; Skip si es 1
    BTFSC   0x40, 0
    BSF	    PORT_E, OUT_E; Skip si es 0
    CLRF    0x40
    CLRF    0x41

OPERAR_F
    ; F = /[/[/I0./I1]./[/I1.I2]./[/I0.I2]./I3]
    CLRW		; Limpiando el Working File
    MOVF    0x3A, 0	; /[/I0./I1] -> Work File
    ANDWF   0x38, 0	; /[/I0.I1]./[/I1.I2] -> Work File
    ANDWF   0x39, 0	; /[/I0.I1]./[/I1.I2]./[/I0.I2] -> Work File
    ANDWF   0x33, 0	; /[/I0.I1]./[/I1.I2]./[/I0.I2]./I3 -> Work File
    MOVWF   0x40	; /[/I0.I1]./[/I1.I2]./[/I0.I2]./I3 -> 0x40
    COMF    0x40, 1	; /[/[/I0.I1]./[/I1.I2]./[/I0.I2]./I3] -> 0x40
    BTFSS   0x40, 0
    BCF	    PORT_F, OUT_F; Skip si es 1
    BTFSC   0x40, 0
    BSF	    PORT_F, OUT_F; Skip si es 0
    CLRF    0x40

OPERAR_G
    ; G = I3 + I2 + I1
    CLRW		; Limpiando el Working File
    MOVF    0x23, 0	; I3 -> Work File
    IORWF   0x22, 0	; I3 + I2 -> Work File
    IORWF   0x21, 0	; I3 + I2 + I1 -> Work File
    MOVWF   0x40	; I3 + I2 + I1 -> 0x40
    BTFSS   0x40, 0
    BCF	    PORT_G, OUT_G; Skip si es 1
    BTFSC   0x40, 0
    BSF	    PORT_G, OUT_G; Skip si es 0
    CLRF    0x40
    GOTO    GUARDAR_I0

END


