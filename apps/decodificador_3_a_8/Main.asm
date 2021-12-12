list p=16f628A
#include <p16f628A.inc>
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_ON & _PWRTE_ON & _INTOSC_OSC_NOCLKOUT & _LVP_OFF & _MCLRE_ON

    I1	    EQU 0X20
    I2	    EQU 0X21
    I3	    EQU 0X22

    N_I1    EQU 0X23
    N_I2    EQU 0X24
    N_I3    EQU 0X25

    ORG 0x00
    GOTO INICIO

INICIO
    BSF	    STATUS, RP0	    ; Saltar al banco 1
    MOVLW   b'00000111'	    ; Cargar literal al registro de trabajo W
    MOVWF   TRISA	    ; Configurar puerto A con la conf. de W
    CLRF    TRISB	    ; Configurar puerto B como todos los pines salida
    BCF	    STATUS, RP0	    ; Volver al banco 0
    GOTO    GUARDAR_I1

GUARDAR_I1
    CLRW
    BTFSC   PORTA, 0
    MOVLW   0x1		; Se ejecuta solo si PORTA[0] es 1
    MOVWF   I1
    COMF    I1, W
    MOVWF   N_I1

GUARDAR_I2
    CLRW
    BTFSC   PORTA, 1
    MOVLW   0x1		; Se ejecuta solo si PORTA[1] es 1
    MOVWF   I2
    COMF    I2, W
    MOVWF   N_I2

GUARDAR_I3
    CLRW
    BTFSC   PORTA, 2
    MOVLW   0x1		; Se ejecuta solo si PORTA[2] es 1
    MOVWF   I3
    COMF    I3, W
    MOVWF   N_I3

GENERAR_S1
    ; S1 = /I1./I2./I3
    CLRW
    MOVF    N_I1, W
    ANDWF   N_I2, W
    ANDWF   N_I3, W
    MOVWF   0X40
    BTFSC   0X40, 0
    BSF	    PORTB, 0	; Si 0X40 es 1
    BTFSS   0X40, 0
    BCF	    PORTB, 0	; Si 0x40 es 0
    CLRF    0X40

GENERAR_S2
    ; S2 = /I1./I2.I3
    CLRW
    MOVF    N_I1, W
    ANDWF   N_I2, W
    ANDWF   I3, W
    MOVWF   0X40
    BTFSC   0X40, 0
    BSF	    PORTB, 1	; Si 0X40 es 1
    BTFSS   0X40, 0
    BCF	    PORTB, 1	; Si 0x40 es 0
    CLRF    0X40

GENERAR_S3
    ; S3 = /I1.I2./I3
    CLRW
    MOVF    N_I1, W
    ANDWF   I2, W
    ANDWF   N_I3, W
    MOVWF   0X40
    BTFSC   0X40, 0
    BSF	    PORTB, 2	; Si 0X40 es 1
    BTFSS   0X40, 0
    BCF	    PORTB, 2	; Si 0x40 es 0
    CLRF    0X40

GENERAR_S4
    ; S4 = /I1.I2.I3
    CLRW
    MOVF    N_I1, W
    ANDWF   I2, W
    ANDWF   I3, W
    MOVWF   0X40
    BTFSC   0X40, 0
    BSF	    PORTB, 3	; Si 0X40 es 1
    BTFSS   0X40, 0
    BCF	    PORTB, 3	; Si 0x40 es 0
    CLRF    0X40

GENERAR_S5
    ; S5 = I1./I2./I3
    CLRW
    MOVF    I1, W
    ANDWF   N_I2, W
    ANDWF   N_I3, W
    MOVWF   0X40
    BTFSC   0X40, 0
    BSF	    PORTB, 4	; Si 0X40 es 1
    BTFSS   0X40, 0
    BCF	    PORTB, 4	; Si 0x40 es 0
    CLRF    0X40

GENERAR_S6
    ; S6 = I1./I2.I3
    CLRW
    MOVF    I1, W
    ANDWF   N_I2, W
    ANDWF   I3, W
    MOVWF   0X40
    BTFSC   0X40, 0
    BSF	    PORTB, 5	; Si 0X40 es 1
    BTFSS   0X40, 0
    BCF	    PORTB, 5	; Si 0x40 es 0
    CLRF    0X40

GENERAR_S7
    ; S7 = I1.I2./I3
    CLRW
    MOVF    I1, W
    ANDWF   I2, W
    ANDWF   N_I3, W
    MOVWF   0X40
    BTFSC   0X40, 0
    BSF	    PORTB, 6	; Si 0X40 es 1
    BTFSS   0X40, 0
    BCF	    PORTB, 6	; Si 0x40 es 0
    CLRF    0X40

GENERAR_S8
    ; S8 = I1.I2.I3
    CLRW
    MOVF    I1, W
    ANDWF   I2, W
    ANDWF   I3, W
    MOVWF   0X40
    BTFSC   0X40, 0
    BSF	    PORTB, 7	; Si 0X40 es 1
    BTFSS   0X40, 0
    BCF	    PORTB, 7	; Si 0x40 es 0
    CLRF    0X40
    GOTO    GUARDAR_I1

END