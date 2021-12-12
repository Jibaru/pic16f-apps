list p=16f628A
#include <p16f628A.inc>
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_ON & _PWRTE_ON & _INTOSC_OSC_NOCLKOUT & _LVP_OFF & _MCLRE_ON

    OPER1   EQU 0X20
    OPER2   EQU 0X21
    CODIGO  EQU	0X22

    ORG	    0x00
    GOTO    INICIO

INICIO
    BSF	    STATUS, RP0	    ; Saltar al banco 1
    MOVLW   b'00001111'	    ; Cargar literal al registro de trabajo W
    MOVWF   TRISA	    ; Configurar puerto A con la conf. de W
    MOVLW   b'00011000'	    ; Cargar literal al registro de trabajo W
    MOVWF   TRISB	    ; Configurar puerto B con la conf. de W
    BCF	    STATUS, RP0	    ; Volver al banco 0
    CLRF    PORTA
    CLRF    PORTB
    GOTO    PROGRAMA

PROGRAMA
CAPTURA_OPER1
    MOVLW   B'000000011'
    ANDWF   PORTA, W
    MOVWF   OPER1

CAPTURA_OPER2
    MOVF    PORTA, W
    MOVWF   OPER2
    RRF	    OPER2, F
    RRF	    OPER2, F
    MOVLW   B'00000011'
    ANDWF   OPER2, F

CAPTURA_CODIGO
    MOVF    PORTB, W
    MOVWF   CODIGO
    RRF	    CODIGO, F
    RRF	    CODIGO, F
    RRF	    CODIGO, F
    MOVLW   B'00000011'
    ANDWF   CODIGO, W
    GOTO    OPERACIONES

OPERACIONES
    ADDWF   PCL, F  ; puntero del programa + valor del codigo (en W)
    GOTO    LIMPIA  ;0
    GOTO    SUMA    ;1
    GOTO    RESTA   ;2
    GOTO    COMPARA ;3

LIMPIA
    CLRF    PORTB
    GOTO    PROGRAMA

SUMA
    MOVF    OPER1, W
    ADDWF   OPER2, W
    MOVWF   PORTB
    GOTO    PROGRAMA

RESTA
    MOVF    OPER2, W
    SUBWF   OPER1, W
    MOVWF   PORTB
    GOTO    PROGRAMA

COMPARA
    MOVF    OPER1, W
    SUBWF   OPER2, W
    BTFSS   STATUS, C	; Salta si C = 1
    GOTO    MAYOR	; Si C = 0, OPER1 > OPER2
    BTFSC   STATUS, Z	; Salta si Z = 0
    GOTO    IGUAL	; Si C = 1 y Z = 1, OPER1 = OPER2
    GOTO    MENOR	; Si C = 1 y Z = 0, OPER1 < OPER2

MAYOR
    BCF	    PORTB, 1
    BCF	    PORTB, 2
    BSF	    PORTB, 0	; C1 = 1
    GOTO    PROGRAMA

MENOR
    BCF	    PORTB, 0
    BCF	    PORTB, 2
    BSF	    PORTB, 1	; C2 = 1
    GOTO    PROGRAMA

IGUAL
    BCF	    PORTB, 0
    BCF	    PORTB, 1
    BSF	    PORTB, 2	; C0 = 1
    GOTO    PROGRAMA

END