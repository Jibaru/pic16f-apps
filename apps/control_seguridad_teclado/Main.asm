list p=16f628A		; Define el procesador
#include <p16f628A.inc> ; Contiene las Variable del Procesador
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_ON & _PWRTE_ON & _INTOSC_OSC_NOCLKOUT & _LVP_OFF & _MCLRE_ON

    CUENTA	EQU 0X20
    VALOR	EQU 0X21

    TIEMPO1	EQU 0X45
    TIEMPO2	EQU 0X46

    ORG	    0x00
    GOTO    PEPITO

PEPITO
    ; CONFIGURACION DE PUERTOS
    BSF	    STATUS,RP0
    MOVLW   B'00000000'
    MOVWF   TRISA
    MOVLW   B'11110000'
    MOVWF   TRISB
    BCF	    STATUS,RP0
    CLRF    PORTA
    CLRF    PORTB
    MOVLW   0X03
    MOVWF   CUENTA
    GOTO    BUCLE

BUCLE
    CALL    MOSTRAR_CONTADOR
    CALL    RETARDO
    ; OBTENER VALOR DE TECLADO
REVISA_A1
    BSF	    PORTB, 0
    BCF	    PORTB, 1
    BCF	    PORTB, 2
    BCF	    PORTB, 3
    BTFSS   PORTB, 4	    ; REVISION COLUMNA 1
    GOTO    REVISA_B1	    ; SI PORTB[4] == 0
    MOVLW   D'1'	    ; EL VALOR ES 1
    MOVWF   VALOR
    GOTO    DISPLAY

REVISA_B1
    BCF	    PORTB, 0
    BSF	    PORTB, 1
    BCF	    PORTB, 2
    BCF	    PORTB, 3
    BTFSS   PORTB, 4	    ; REVISION COLUMNA 1
    GOTO    REVISA_C1	    ; SI PORTB[4] == 0
    MOVLW   D'4'	    ; EL VALOR ES 4
    MOVWF   VALOR
    GOTO    DISPLAY

REVISA_C1
    BCF	    PORTB, 0
    BCF	    PORTB, 1
    BSF	    PORTB, 2
    BCF	    PORTB, 3
    BTFSS   PORTB, 4	    ; REVISION COLUMNA 1
    GOTO    REVISA_A2	    ; SI PORTB[4] == 0
    MOVLW   D'7'	    ; EL VALOR ES 7
    MOVWF   VALOR
    GOTO    DISPLAY

REVISA_A2
    BSF	    PORTB, 0
    BCF	    PORTB, 1
    BCF	    PORTB, 2
    BCF	    PORTB, 3
    BTFSS   PORTB, 5	    ; REVISION COLUMNA 1
    GOTO    REVISA_B2	    ; SI PORTB[5] == 0
    MOVLW   D'2'	    ; EL VALOR ES 2
    MOVWF   VALOR
    GOTO    DISPLAY

REVISA_B2
    BCF	    PORTB, 0
    BSF	    PORTB, 1
    BCF	    PORTB, 2
    BCF	    PORTB, 3
    BTFSS   PORTB, 5	    ; REVISION COLUMNA 1
    GOTO    REVISA_C2	    ; SI PORTB[5] == 0
    MOVLW   D'5'	    ; EL VALOR ES 5
    MOVWF   VALOR
    GOTO    DISPLAY

REVISA_C2
    BCF	    PORTB, 0
    BCF	    PORTB, 1
    BSF	    PORTB, 2
    BCF	    PORTB, 3
    BTFSS   PORTB, 5	    ; REVISION COLUMNA 1
    GOTO    REVISA_D2	    ; SI PORTB[5] == 0
    MOVLW   D'8'	    ; EL VALOR ES 8
    MOVWF   VALOR
    GOTO    DISPLAY

REVISA_D2
    BCF	    PORTB, 0
    BCF	    PORTB, 1
    BCF	    PORTB, 2
    BSF	    PORTB, 3
    BTFSS   PORTB, 5	    ; REVISION COLUMNA 1
    GOTO    REVISA_A3	    ; SI PORTB[5] == 0
    MOVLW   D'0'	    ; EL VALOR ES 0
    MOVWF   VALOR
    GOTO    DISPLAY

REVISA_A3
    BSF	    PORTB, 0
    BCF	    PORTB, 1
    BCF	    PORTB, 2
    BCF	    PORTB, 3
    BTFSS   PORTB, 6	    ; REVISION COLUMNA 1
    GOTO    REVISA_B3	    ; SI PORTB[6] == 0
    MOVLW   D'3'	    ; EL VALOR ES 3
    MOVWF   VALOR
    GOTO    DISPLAY

REVISA_B3
    BCF	    PORTB, 0
    BSF	    PORTB, 1
    BCF	    PORTB, 2
    BCF	    PORTB, 3
    BTFSS   PORTB, 6	    ; REVISION COLUMNA 1
    GOTO    REVISA_C3	    ; SI PORTB[6] == 0
    MOVLW   D'6'	    ; EL VALOR ES 6
    MOVWF   VALOR
    GOTO    DISPLAY

REVISA_C3
    BCF	    PORTB, 0
    BCF	    PORTB, 1
    BSF	    PORTB, 2
    BCF	    PORTB, 3
    BTFSS   PORTB, 6	    ; REVISION COLUMNA 1
    GOTO    BUCLE	    ; SI PORTB[6] == 0
    MOVLW   D'9'	    ; EL VALOR ES 9
    MOVWF   VALOR
    GOTO    DISPLAY

    ; MOSTRAR VALOR EN DISPLAY
DISPLAY
    ;MOVLW   B'11111111'
    ;ANDWF   VALOR, W
    ;MOVWF   PORTA
    ; VALIDAR VALOR DE TECLADO
VALIDAR_VALOR
    MOVLW   0X03		    ; VALOR = 3
    SUBWF   VALOR, W
    BTFSC   STATUS, Z		    ; Salta si Z = 0
    GOTO    CORRECTO		    ; Z = 1, 3 = VALOR
    GOTO    DECREMENTAR_CONTADOR	    ; Z = 0, 3 != VALOR

    ; SI ES VALIDO ENCENDER ALARMA
CORRECTO
    BSF	    PORTA, 6
    GOTO    CORRECTO

    ; SI NO ES VALIDA CUENTA
DECREMENTAR_CONTADOR
    DECFSZ  CUENTA, F
    GOTO    BUCLE
    GOTO    BUCLE_ERROR

BUCLE_ERROR
    CALL    MOSTRAR_CONTADOR
    BSF	    PORTA, 7
    GOTO    BUCLE_ERROR

MOSTRAR_CONTADOR
    MOVLW   B'11111111'
    ANDWF   CUENTA, W
    MOVWF   PORTA
    RETURN

; ciclos(p, q) = 7 + p + (p - 1) * (5 + q + 2*q)
RETARDO			    ; 2 call
    MOVLW   D'200'	    ; 1, VALOR DE p
    MOVWF   TIEMPO1	    ; 1
LAZO1B
    DECFSZ  TIEMPO1, F	    ; (p - 1) + 2
    GOTO    LAZO2B	    ; (p - 1) * (5 + q + 2*q)
    RETURN		    ; 2

			    ; ciclos(q) = 5 + q + 2*q
LAZO2B			    ; 2 goto
    MOVLW   D'255'	    ; 1, VALOR DE q
    MOVWF   TIEMPO2	    ; 1
LAZO3B
    DECFSZ  TIEMPO2, F	    ; (q - 1) + 2
    GOTO    LAZO3B	    ; (q - 1) * 2
    GOTO    LAZO1B	    ; 2

END