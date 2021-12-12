; SISTEMA DE CONTROL PRINCIPAL
list p=16f628A
#include <p16f628A.inc>
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_ON & _PWRTE_ON & _INTOSC_OSC_NOCLKOUT & _LVP_OFF & _MCLRE_ON

    TIEMPO1 EQU	0X20
    TIEMPO2 EQU	0X21
    TIEMPO3 EQU	0X22

    VALT1   EQU	0X30
    VALT2   EQU	0X31
    VALT3   EQU	0X32

    ORG	    0x00
    GOTO    INICIO

INICIO
    ; Puertos
    BSF	    STATUS, RP0
    MOVLW   B'10000000'
    MOVWF   TRISA
    MOVLW   B'00000001'
    MOVWF   TRISB
    BCF	    STATUS, RP0
    CLRF    PORTA
    CLRF    PORTB
    GOTO    BUCLE

BUCLE
    BTFSC   PORTA, 7
    GOTO    PROGRAMA
    GOTO    BUCLE

PROGRAMA
    ;PASO 1
    MOVLW   B'10010010'
    MOVWF   PORTB
    BCF	    PORTA, 0
    CALL    RETARDO_12S
    ;PASO 2
    BSF	    PORTB, 6
    CALL    RETARDO_5S
    ;PASO 3
    MOVLW   B'00100100'
    MOVWF   PORTB
    CALL    RETARDO_MEDS
    ;PASO 4
    BSF	    PORTB, 3
    BSF	    PORTA, 0
    CALL    RETARDO_12S
    ;PASO 5
    BSF	    PORTB, 6
    CALL    RETARDO_5S
    ;PASO 3
    MOVLW   B'00100010'
    MOVWF   PORTB
    BCF	    PORTA, 0
    CALL    RETARDO_MEDS
    GOTO    PROGRAMA

RETARDO_MEDS
    MOVLW   D'77'
    MOVWF   VALT1
    MOVLW   D'229'
    MOVWF   VALT2
    MOVLW   D'8'
    MOVWF   VALT3
    CALL    RETARDO
    RETURN

RETARDO_5S
    MOVLW   D'78'
    MOVWF   VALT1
    MOVLW   D'174'
    MOVWF   VALT2
    MOVLW   D'121'
    MOVWF   VALT3
    CALL    RETARDO
    RETURN

RETARDO_12S
    MOVLW   D'99'
    MOVWF   VALT1
    MOVLW   D'193'
    MOVWF   VALT2
    MOVLW   D'208'
    MOVWF   VALT3
    CALL    RETARDO
    RETURN

; Calculo: tiempo(M, N, P) = 5+4N+4MN+3PMN
; Frecuencia de reloj; 4Mhz pic16f628a
; 1 ciclo de reloj = 1/4 = 0.25 micro seg.
; 1 ciclo de instruccion = 4 ciclos de reloj = 1 microsegundo
RETARDO			; 2 c
    MOVF    VALT1, W	; 1c --> Valor de N
    MOVWF   TIEMPO1	; 1c
ARRIBA
    MOVF    VALT2, W	; 1c * N --> Valor de M
    MOVWF   TIEMPO2	; 1c * N
BUCLE1
    MOVF    VALT3, W	; --> 1c * N * M --> Valor de P
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