list p=16f628A		; Define el procesador
#include <p16f628A.inc> ; Contiene las Variable del Procesador
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_ON & _PWRTE_ON & _INTOSC_OSC_NOCLKOUT & _LVP_OFF & _MCLRE_ON

    TIEMPO1  EQU	 0x20
    TIEMPO2  EQU	 0x21
    TIEMPO3  EQU	 0x22

    ORG	    0x00	; Aquí comienza el PROGRAMA
    GOTO    PUERTOS	; Salto a inicio de mi programa.

PUERTOS
    BSF	    STATUS,5
    CLRF    TRISB
    BSF	    TRISA, 0
    BCF	    STATUS,5
    BCF	    PORTB, 0
    BCF	    PORTB, 1
    BCF	    PORTB, 2

INICIO
    BTFSC   PORTA, 0	; Sensor de trafico
    GOTO    POCO_TRAF
    GOTO    ALTO_TRAF

ALTO_TRAF
    BSF	    PORTB, 2	; Enciende rojo
    CALL    ESPERAR_8SEG
    BCF	    PORTB, 2
    BSF	    PORTB, 1
    CALL    ESPERAR_2SEG
    BCF	    PORTB, 1
    BSF	    PORTB, 0
    CALL    ESPERAR_5SEG
    BCF	    PORTB, 0
    GOTO    INICIO

POCO_TRAF
    BSF	    PORTB, 2	; Enciende rojo
    CALL    ESPERAR_5SEG
    BCF	    PORTB, 2
    BSF	    PORTB, 1
    CALL    ESPERAR_2SEG
    BCF	    PORTB, 1
    BSF	    PORTB, 0
    CALL    ESPERAR_8SEG
    BCF	    PORTB, 0
    GOTO    INICIO

;;;;;;;;;;; Retardos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1 ciclo = 1 microsegundo
; 1 000 000 ciclos = 1 segundo = 1 000 000 microsegundos

ESPERAR1    ; Tiempo de espera: 800 microsegundos aprox
    MOVLW   0xFF	; 255 decimal 1 microsegundo
    MOVWF   TIEMPO1	; 1 microsegundo

RET
    ; DECFSZ + GOTO + SKIP = (1 + 2)*255 + 1 = 766 microsegundos
    DECFSZ TIEMPO1, 1	; Decrementas TIEMPO1, el resultado -> TIEMPO1
    GOTO RET		; Skip si es 0,
    RETURN		; 2 microsegundos


ESPERAR2    ; Tiempo de espera: 205 280 microsegundos aprox
    MOVLW   0xFF	; 255 decimal 1 microsegundo
    MOVWF   TIEMPO2	; 1 microsegundo

RET2
    ; CALL ESPERAR 1 + DECFSZ + GOTO + SKIP =
    ; (2 + 800 + 1 + 2)*255 + 1 = 205 276 microsegundos
    CALL    ESPERAR1	;
    DECFSZ  TIEMPO2, 1	; Decrementas TIEMPO2, el resultado -> TIEMPO2
    GOTO    RET2	; Skip si es 0 ;
    RETURN		; 2 microsegundos

ESPERAR_SEG    ; Tiempo de espera: 1 026 4230 microsegundos aprox.
    MOVLW   0x5		; 5 decimal; 1 microsegundo
    MOVWF   TIEMPO3	; 1 microsegundo

RET_SEG
    ; CALL ESPERAR 2 + DECFSZ + GOTO + SKIP =
    ; (2 + 205 280 + 1 + 2)*5 + 1 = 1 026 426 microsegundos
    CALL    ESPERAR2
    DECFSZ  TIEMPO3, 1	; Decrementas TIEMPO3, el resultado -> TIEMPO3
    GOTO    RET_SEG	; Skip si es 0
    RETURN		; 2 microsegundos


ESPERAR_2SEG
    CALL ESPERAR_SEG
    CALL ESPERAR_SEG
    RETURN

ESPERAR_5SEG
    CALL ESPERAR_SEG
    CALL ESPERAR_SEG
    CALL ESPERAR_SEG
    CALL ESPERAR_SEG
    CALL ESPERAR_SEG
    RETURN

ESPERAR_8SEG
    CALL ESPERAR_SEG
    CALL ESPERAR_SEG
    CALL ESPERAR_SEG
    CALL ESPERAR_SEG
    CALL ESPERAR_SEG
    CALL ESPERAR_SEG
    CALL ESPERAR_SEG
    CALL ESPERAR_SEG
    RETURN

END