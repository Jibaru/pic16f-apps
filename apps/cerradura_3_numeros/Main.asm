list p=16f628A
#include <p16f628A.inc>
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_ON & _PWRTE_ON & _INTOSC_OSC_NOCLKOUT & _LVP_OFF & _MCLRE_ON

    ORG	    0x00	; Origen de mem. programa
    GOTO    INICIO	; a inicio

; Diseñar e implementar una cerradura electrónica activado con el ingreso de 3
; número secuenciales (Los números pueden ser fijos y aleatorios) y después de
; tres intentos errados prenda una luz y no permita un siguiente intento.

    DIRV1   EQU	0x20
    DIRV2   EQU	0x21
    DIRV3   EQU	0x22

    VERIF   EQU	0x28
    CONT    EQU	0x2A

    TIEMPO1 EQU	0X40
    TIEMPO2 EQU	0X41
    TIEMPO3 EQU	0X42

INICIO
    BSF	    STATUS, RP0	; 0 1 (Banco 1)
    MOVLW   B'00101111'
    MOVWF   TRISB
    MOVLW   0x0
    MOVWF   TRISA
    BCF	    STATUS, RP0	; 0 0 (Banco 0)

LIMPIA
    MOVLW   0x0
    MOVWF   PORTB
    MOVLW   0x0
    MOVWF   PORTA

; Se establecen los 3 valores con los que se comprobará, el valor del contador,
; y la dirección donde empezará a almacenarse los valores ingresados (se
; accederá mediante direccionamiento indirecto)
ESTABLECE
    MOVLW   0x04
    MOVWF   DIRV1
    MOVLW   0x05
    MOVWF   DIRV2
    MOVLW   0x01
    MOVWF   DIRV3
    MOVLW   0x03	; Numero de intentos
    MOVWF   CONT

VAL_INICIAL
    MOVLW   0x03	; Numero de numeros ingresados
    MOVWF   VERIF
    BCF	    STATUS, IRP
    MOVLW   0x24
    MOVWF   FSR
    CALL    MUESTRA_CONT

INGRESA
    BTFSS   PORTB, 5	; Test a bit de boton validacion
    GOTO    INGRESA
    MOVF    PORTB, W
    MOVWF   0x30	; Auxiliar
    BCF	    0x30, 5	; Limpia bit 5
    MOVF    0x30, W
    MOVWF   INDF
    INCF    FSR, F
    CALL    RETARDO
    DECFSZ  VERIF, F
    GOTO    INGRESA

VALIDA
    MOVLW   0x24
    MOVWF   FSR
    MOVF    DIRV1, W
    XORWF   INDF, W
    BTFSS   STATUS, Z
    GOTO    FALLO
    CLRW
    ;GOTO    CORRECTO
    INCF    FSR
    MOVF    DIRV2, W
    XORWF   INDF, W
    BTFSS   STATUS, Z
    GOTO    FALLO
    CLRW
    ;GOTO    CORRECTO
    INCF    FSR
    MOVF    DIRV3, W
    XORWF   INDF, W
    BTFSS   STATUS, Z
    GOTO    FALLO
    GOTO    CORRECTO

CORRECTO
    BSF	    PORTB, 6
    GOTO    CORRECTO

FALLO
    DECFSZ  CONT, F
    GOTO    VAL_INICIAL
    CALL    MUESTRA_CONT
    GOTO    FIN_ERROR

FIN_ERROR
    BSF	    PORTB, 7
    GOTO    FIN_ERROR

MUESTRA_CONT
    MOVF    CONT, W
    MOVWF   PORTA
    RETURN

RETARDO ; 2 c
    MOVLW   d'5'	; 1c --> Valor de N
    MOVWF   TIEMPO1	; 1c
ARRIBA
    MOVLW   d'255'	; 1c * N --> Valor de M
    MOVWF   TIEMPO2	; 1c * N
BUCLE1
    MOVLW   d'200'	; --> 1c * N * M --> Valor de P
    MOVWF   TIEMPO3	; --> 1c * N * M
REPITE1
    DECFSZ  TIEMPO3, 1	; --> (P-1) * M * N + 2M * N
    GOTO    REPITE1	; --> (P-1) * M * N * 2
    DECFSZ  TIEMPO2, 1	; --> (M-1) * N + 2N
    GOTO    BUCLE1	; --> (M-1) * 2 * N
    DECFSZ  TIEMPO1, 1	; --> (N-1) + 2c
    GOTO    ARRIBA	; --> (N-1) * 2
    RETURN		; 2c

END