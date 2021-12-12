list p=16f628A
#include <p16f628A.inc>
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_ON & _PWRTE_ON & _INTOSC_OSC_NOCLKOUT & _LVP_OFF & _MCLRE_ON

    CONTU   EQU	0X20
    CONTD   EQU	0X21
    CONTC   EQU 0X22

    VALU    EQU	0X30
    VALD    EQU 0X31
    VALC    EQU	0X32

    TIEMPO1 EQU	0X40
    TIEMPO2 EQU	0X41

    VAL10   EQU B'00001010'

    ORG	    0x00
    GOTO    CONFIGURACION
    ORG	    0x04
    GOTO    INCUNIDADES

CONFIGURACION
    ; Puertos
    BSF	    STATUS, RP0
    CLRF    TRISA
    MOVLW   0x01
    MOVWF   TRISB
    BCF	    STATUS, RP0
    ; Interrupcion
    BSF	    INTCON, GIE		; Hab.Int.General
    BSF	    INTCON, INTE	; Hab.Int. RB0
    BSF	    STATUS, RP0
    BCF	    OPTION_REG, INTEDG	; De bajada
    BCF	    STATUS, RP0
    CLRF    PORTA
    CLRF    PORTB
    ;GOTO    PROGRAMA
    GOTO    PRUEBA

PRUEBA
    MOVLW   B'11111110' ; 8
    MOVWF   VALU
    MOVLW   0X08
    MOVWF   CONTU
    MOVLW   B'11001110' ; 9
    MOVWF   VALD
    MOVLW   0X09
    MOVWF   CONTD

PROGRAMA
    ; Estableciendo unidades
    MOVLW   B'00000100'
    MOVWF   PORTA
    MOVF    VALU, W
    MOVWF   PORTB
    ; Espera
    CALL    RETARDO
    ; Estableciendo decenas
    MOVLW   B'00000010'
    MOVWF   PORTA
    MOVF    VALD, W
    MOVWF   PORTB
    ; Espera
    CALL    RETARDO
    ; Estableciendo centenas
    MOVLW   B'00000001'
    MOVWF   PORTA
    MOVF    VALC, W
    MOVWF   PORTB
    ; Espera
    CALL    RETARDO
    GOTO    PROGRAMA

INCUNIDADES
    ; Unidades
    INCF    CONTU, F
    MOVLW   VAL10
    XORWF   CONTU, W
    BTFSC   STATUS, Z	 ; Salta si es 0 = no es 10
    CALL    INCDECENAS
    MOVF    CONTU, W
    CALL    INDEXADO
    MOVWF   VALU
    BCF	    INTCON, INTF ; Coloca a 0 el INTF para que no vuelva a INTERRP
    RETFIE

INCDECENAS
    ; Decenas
    CLRF    CONTU
    INCF    CONTD, F
    MOVLW   VAL10
    XORWF   CONTD, W
    BTFSC   STATUS, Z
    CALL    INCCENTENAS
    MOVF    CONTD, W
    CALL    INDEXADO
    MOVWF   VALD
    RETURN

INCCENTENAS
    ; Centenas
    CLRF    CONTD
    INCF    CONTC, F
    MOVLW   VAL10
    XORWF   CONTC, W
    BTFSC   STATUS, Z
    CLRF    CONTC
    MOVF    CONTC, W
    CALL    INDEXADO
    MOVWF   VALC
    RETURN

INDEXADO
    ADDWF   PCL, F
    RETLW   B'01111110'	    ; 0
    RETLW   B'00001100'	    ; 1
    RETLW   B'10110110'	    ; 2
    RETLW   B'10011110'	    ; 3
    RETLW   B'11001100'	    ; 4
    RETLW   B'11011010'	    ; 5
    RETLW   B'11111010'	    ; 6
    RETLW   B'00001110'	    ; 7
    RETLW   B'11111110'	    ; 8
    RETLW   B'11001110'	    ; 9


; demora =  ciclos(20, 255) = 14 657 ciclos de inst.
			    ; ciclos(p, q) = 7 + p + (p - 1) * (5 + q + 2*q)
RETARDO			    ; 2 call
    MOVLW   D'20'	    ; 1, VALOR DE p
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