; SISTEMA DE CONTROL SENSORES
#include <P16f877A.inc>

__CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF

    PRIMERO	EQU 0X20
    SEGUNDO	EQU 0X21
    RESULTADO	EQU 0X22

    UNIDAD	EQU 0X31
    DECENA      EQU 0X32
    CENTENA     EQU 0X33

    TIEMPO1	EQU 0X45
    TIEMPO2	EQU 0X46

    V_44PSI	EQU B'01110000'	    ; 44PSI
    V_87PSI	EQU B'11100000'	    ; 87PSI

    ORG	    0x00
    GOTO    INICIO

INICIO
    ; Puertos
    BSF	    STATUS, RP0
    MOVLW   B'00101111'
    MOVWF   TRISA
    CLRF    TRISB
    CLRF    TRISC
    CLRF    TRISD
    MOVLW   0X01
    MOVWF   TRISE
    MOVLW   B'01000010'	    ; Los ultimos 4 bits indican la conf. analogica
    MOVWF   ADCON1	    ; Configuración entradas analógicas
    BCF	    STATUS, RP0
    BSF	    ADCON0, 7
    BCF	    ADCON0, 6	    ; FOSC / 64
    BCF	    ADCON1, 7	    ; JUSTIFICACION IZQUIERDA
    CLRF    PORTB
    CLRF    PORTD
    CLRF    PORTC
    BSF	    ADCON0, 0
    GOTO    BUCLE

BUCLE
    BTFSC   PORTE, 0
    GOTO    ADC1_CONF
    GOTO    BUCLE

ADC1_CONF
    ; SELECCIÓN DE CANAL
    ; AN0 = 000
    BCF	    ADCON0, 3
    BCF	    ADCON0, 4
    BCF	    ADCON0, 5
ADC1_PROG
    ; GO ADC
    BSF	    ADCON0, 2	    ; GO/DONE
ADC1
    BTFSC   ADCON0, 2
    GOTO    ADC1
    ; Revision Baja Presion
    MOVF    ADRESH, W
    MOVWF   SEGUNDO
    MOVLW   V_44PSI
    MOVWF   PRIMERO
    CALL    COMPARA
    MOVWF   RESULTADO
    BTFSS   RESULTADO, 0
    BSF	    PORTD, 0	    ; SI ES 0
    BTFSC   RESULTADO, 0
    BCF	    PORTD, 0	    ; SI ES 1
    ; Revisión Alta Presión
    MOVF    ADRESH, W
    MOVWF   SEGUNDO
    MOVLW   V_87PSI
    MOVWF   PRIMERO
    CALL    COMPARA
    MOVWF   RESULTADO
    BTFSS   RESULTADO, 0
    BCF	    PORTD, 4	    ; SI ES 0
    BTFSC   RESULTADO, 0
    BSF	    PORTD, 4	    ; SI ES 1

ADC2_CONF
    ; SELECCIÓN DE CANAL
    ; AN1 = 001
    BSF	    ADCON0, 3
    BCF	    ADCON0, 4
    BCF	    ADCON0, 5
ADC2_PROG
    ; GO ADC
    BSF	    ADCON0, 2	    ; GO/DONE
ADC2
    BTFSC   ADCON0, 2
    GOTO    ADC2
    ; Revision Baja Presion
    MOVF    ADRESH, W
    MOVWF   SEGUNDO
    MOVLW   V_44PSI
    MOVWF   PRIMERO
    CALL    COMPARA
    MOVWF   RESULTADO
    BTFSS   RESULTADO, 0
    BSF	    PORTD, 1	    ; SI ES 0
    BTFSC   RESULTADO, 0
    BCF	    PORTD, 1	    ; SI ES 1
    ; Revisión Alta Presión
    MOVF    ADRESH, W
    MOVWF   SEGUNDO
    MOVLW   V_87PSI
    MOVWF   PRIMERO
    CALL    COMPARA
    MOVWF   RESULTADO
    BTFSS   RESULTADO, 0
    BCF	    PORTD, 5	    ; SI ES 0
    BTFSC   RESULTADO, 0
    BSF	    PORTD, 5	    ; SI ES 1

ADC3_CONF
    ; SELECCIÓN DE CANAL
    ; AN2 = 010
    BCF	    ADCON0, 3
    BSF	    ADCON0, 4
    BCF	    ADCON0, 5
ADC3_PROG
    ; GO ADC
    BSF	    ADCON0, 2	    ; GO/DONE
ADC3
    BTFSC   ADCON0, 2
    GOTO    ADC3
    ; Revision Baja Presion
    MOVF    ADRESH, W
    MOVWF   SEGUNDO
    MOVLW   V_44PSI
    MOVWF   PRIMERO
    CALL    COMPARA
    MOVWF   RESULTADO
    BTFSS   RESULTADO, 0
    BSF	    PORTD, 2	    ; SI ES 0
    BTFSC   RESULTADO, 0
    BCF	    PORTD, 2	    ; SI ES 1
    ; Revisión Alta Presión
    MOVF    ADRESH, W
    MOVWF   SEGUNDO
    MOVLW   V_87PSI
    MOVWF   PRIMERO
    CALL    COMPARA
    MOVWF   RESULTADO
    BTFSS   RESULTADO, 0
    BCF	    PORTD, 6	    ; SI ES 0
    BTFSC   RESULTADO, 0
    BSF	    PORTD, 6	    ; SI ES 1

ADC4_CONF
    ; SELECCIÓN DE CANAL
    ; AN3 = 011
    BSF	    ADCON0, 3
    BSF	    ADCON0, 4
    BCF	    ADCON0, 5
ADC4_PROG
    ; GO ADC
    BSF	    ADCON0, 2	    ; GO/DONE
ADC4
    BTFSC   ADCON0, 2
    GOTO    ADC4
    ; Revision Baja Presion
    MOVF    ADRESH, W
    MOVWF   SEGUNDO
    MOVLW   V_44PSI
    MOVWF   PRIMERO
    CALL    COMPARA
    MOVWF   RESULTADO
    BTFSS   RESULTADO, 0
    BSF	    PORTD, 3	    ; SI ES 0
    BTFSC   RESULTADO, 0
    BCF	    PORTD, 3	    ; SI ES 1
    ; Revisión Alta Presión
    MOVF    ADRESH, W
    MOVWF   SEGUNDO
    MOVLW   V_87PSI
    MOVWF   PRIMERO
    CALL    COMPARA
    MOVWF   RESULTADO
    BTFSS   RESULTADO, 0
    BCF	    PORTD, 7	    ; SI ES 0
    BTFSC   RESULTADO, 0
    BSF	    PORTD, 7	    ; SI ES 1

CONC_O2_CONF
    ; SELECCIÓN DE CANAL
    ; AN4 = 100
    BCF	    ADCON0, 3
    BCF	    ADCON0, 4
    BSF	    ADCON0, 5
CONC_O2_PROG
    ; GO ADC
    BSF	    ADCON0, 2	    ; GO/DONE
CONC_O2
    BTFSC   ADCON0, 2
    GOTO    CONC_O2
    MOVF    ADRESH, W
    MOVWF   SEGUNDO
    CALL    CONVIERTE
    MOVF    UNIDAD, W
    CALL    INDEXADO
    MOVWF   PORTB
    BCF	    PORTC, 2
    BCF	    PORTC, 3
    BSF	    PORTC, 4	; UNIDAD
    CALL    RETARDO
    MOVF    DECENA, W
    CALL    INDEXADO
    MOVWF   PORTB
    BCF	    PORTC, 2
    BCF	    PORTC, 4
    BSF	    PORTC, 3	; DECENA
    CALL    RETARDO
    MOVF    CENTENA, W
    CALL    INDEXADO
    MOVWF   PORTB
    BCF	    PORTC, 3
    BCF	    PORTC, 4
    BSF	    PORTC, 2	; CENTENA
    CALL    RETARDO

BAJA_PRESION
    MOVLW   B'00001111'
    MOVWF   0X23
    MOVF    PORTD, W
    MOVWF   0X24
    BCF	    0X24, 4
    BCF	    0X24, 5
    BCF	    0X24, 6
    BCF	    0X24, 7
    MOVF    0X24, W
    XORWF   0X23, W
    BTFSC   STATUS, Z
    GOTO    ENCIENDE_SEGUBP   ; SI TODOS SON MENORES A 44PSI
    GOTO    APAGA_SEGUBP

APAGA_SEGUBP
    BCF	    PORTC, 0
    GOTO    ALTA_PRESION

ENCIENDE_SEGUBP
    BSF	    PORTC, 0
    GOTO    ALTA_PRESION

ALTA_PRESION
    MOVLW   B'11110000'
    MOVWF   0X23
    MOVF    PORTD, W
    MOVWF   0X24
    BCF	    0X24, 0
    BCF	    0X24, 1
    BCF	    0X24, 2
    BCF	    0X24, 3
    MOVF    0X24, W
    XORWF   0X23, W
    BTFSC   STATUS, Z
    GOTO    ENCIENDE_SEGUAP   ; SI TODOS SON MENORES A 44PSI
    GOTO    APAGA_SEGUAP

APAGA_SEGUAP
    BCF	    PORTC, 1
    GOTO    ADC1_CONF

ENCIENDE_SEGUAP
    BSF	    PORTC, 1
    GOTO    ADC1_CONF

COMPARA
    MOVF    PRIMERO, W
    SUBWF   SEGUNDO, W
    BTFSS   STATUS, C
    RETLW   0X00	    ; ES MENOR = 0
    RETLW   0x01	    ; ES MAYOR O IGUAL = 1

CONVIERTE
    MOVWF   0X30
    MOVLW   D'10'	; VALOR 10
    MOVWF   0X40
    CLRF    0X41
    ; /10
DIVIDE
    INCF    0X41, F
    MOVLW   D'10'
    ADDWF   0X40, F	; 0X40 +10
    MOVF    0X30, W
    SUBWF   0X40, W
    BTFSS   STATUS, C
    GOTO    DIVIDE	; ES MENOR = 0
    GOTO    CONTINUA

CONTINUA
    MOVF    0X41, W
    MOVWF   0X30
    ; x4
    MOVF    0X30, W
    ADDWF   0X30, F
    ADDWF   0X30, F
    ADDWF   0X30, F
    ; DIGITOS
    CLRF    UNIDAD
    CLRF    DECENA
    CLRF    CENTENA
    MOVF    0X30, W
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