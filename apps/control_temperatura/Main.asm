#include <P16f877A.inc>

__CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF

    OPER1	EQU 0X20
    OPER2	EQU 0X21

    VALOR	EQU 0X30

    UNIDAD	EQU 0X31
    DECENA      EQU 0X32
    CENTENA     EQU 0X33

    TIEMPO1	EQU 0X45
    TIEMPO2	EQU 0X46

    GRADOA	EQU 0X10    ; 16 EN DECIMAL
    GRADOB	EQU 0X16    ; 22 EN DECIMAL

    ORG	    0x00
    GOTO    INICIO

INICIO
    ; Puertos
    BSF	    STATUS, RP0
    MOVLW   B'00000001'
    MOVWF   TRISA
    CLRF    TRISB
    CLRF    TRISC
    CLRF    TRISE
    MOVLW   B'00000011'
    MOVWF   TRISD
    MOVLW   B'01000010'	    ; Los ultimos 4 bits indican la conf. analogica
    MOVWF   ADCON1	    ; Configuración entradas analógicas
    BCF	    STATUS, RP0
    BSF	    ADCON0, 7
    BCF	    ADCON0, 6	    ; FOSC / 64
    BCF	    ADCON1, 7	    ; JUSTIFICACION IZQUIERDA
    CLRF    PORTB
    CLRF    PORTC
    CLRF    PORTE
    CLRF    PORTD
    BSF	    ADCON0, 0

CONFIGURACION_CANAL
    ; SELECCIÓN DE CANAL
    ; AN0 = 000
    BCF	    ADCON0, 3
    BCF	    ADCON0, 4
    BCF	    ADCON0, 5
SELECCION_ADC
    ; GO ADC
    BSF	    ADCON0, 2	    ; GO/DONE
PROGRAMA
    BTFSC   ADCON0, 2
    GOTO    PROGRAMA
    MOVF    ADRESH, W
    CALL    CONVIERTE_A_TEMP_REAL
    MOVF    UNIDAD, W
    CALL    INDEXADO
    MOVWF   PORTB
    BSF	    PORTC, 0
    BCF	    PORTC, 1
    BCF	    PORTC, 2	; UNIDAD
    CALL    RETARDO
    MOVF    DECENA, W
    CALL    INDEXADO
    MOVWF   PORTB
    BCF	    PORTC, 0
    BSF	    PORTC, 1
    BCF	    PORTC, 2	; DECENA
    CALL    RETARDO
    MOVF    CENTENA, W
    CALL    INDEXADO
    MOVWF   PORTB
    BCF	    PORTC, 0
    BCF	    PORTC, 1
    BSF	    PORTC, 2	; CENTENA
    CALL    RETARDO
    GOTO    OPCIONES

OPCIONES
    MOVF    PORTD, W	; CAPTURA OPCIONES DE CONTROL
    ADDWF   PCL, F
    GOTO    APAGA
    GOTO    REVISA_GRADOA
    GOTO    REVISA_GRADOB
    GOTO    ENCIENDE

APAGA
    BCF	    PORTE, 0
    GOTO    SELECCION_ADC

ENCIENDE
    BSF	    PORTE, 0
    GOTO    SELECCION_ADC

REVISA_GRADOA
    MOVF    VALOR, W
    MOVWF   OPER1
    MOVLW   GRADOA
    MOVWF   OPER2
    GOTO    COMPARA

REVISA_GRADOB
    MOVF    VALOR, W
    MOVWF   OPER1
    MOVLW   GRADOB
    MOVWF   OPER2
    GOTO    COMPARA

COMPARA
    MOVF    OPER1, W
    SUBWF   OPER2, W
    BTFSS   STATUS, C	    ; Salta si C = 1
    GOTO    ENCIENDE	    ; Si C = 0, OPER1 > OPER2
    BTFSC   STATUS, Z	    ; Salta si Z = 0
    GOTO    ENCIENDE	    ; Si C = 1 y Z = 1, OPER1 = OPER2
    GOTO    APAGA	    ; Si C = 1 y Z = 0, OPER1 < OPER2

;;;;;;;;; CONVERSION DE DIGITAL CONVERTIDO A REAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CONVIERTE_A_TEMP_REAL
    MOVWF   VALOR    ; GUARDAMOS EL VALOR CONVERTIDO DEL CONVERSOR ANALOGICO
    ADDWF   VALOR, F ; MULTIPLICAMOS POR 2 (SEGUN LA FORMULA) OSEA, SUMAMOS SU MISMO VALOR

;;;;;;;;; OBTENCION DE DIGITOS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OBTENER_DIGITOS
    ; DIGITOS
    CLRF    UNIDAD
    CLRF    DECENA
    CLRF    CENTENA
    MOVF    VALOR, W
    MOVWF   0X34
    INCF    0x34, F
CONTEO
    DECFSZ  0X34, F
    GOTO    UNI
    RETURN		    ; si 0x34 es cero
UNI
    INCF    UNIDAD, F
    MOVLW   D'10'	    ; VALOR 10
    XORWF   UNIDAD, W
    BTFSC   STATUS, Z	    ; Salta si es 0 (no es 10)
    GOTO    DEC
    GOTO    CONTEO

DEC
    CLRF    UNIDAD
    INCF    DECENA, F
    MOVLW   D'10'	    ; VALOR 10
    XORWF   DECENA, W
    BTFSC   STATUS, Z	    ; Salta si es 0 (no es 10)
    GOTO    CENT
    GOTO    CONTEO

CENT
    CLRF    DECENA
    INCF    CENTENA, F
    GOTO    CONTEO

INDEXADO
    ADDWF   PCL, F
    RETLW   B'00000010'	    ; 0
    RETLW   B'10011110'	    ; 1
    RETLW   B'00100100'	    ; 2
    RETLW   B'00001100'	    ; 3
    RETLW   B'10011000'	    ; 4
    RETLW   B'01001000'	    ; 5
    RETLW   B'01000000'	    ; 6
    RETLW   B'00000010'	    ; 7
    RETLW   B'00000000'	    ; 8
    RETLW   B'00001000'	    ; 9


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