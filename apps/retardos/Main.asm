LIST P=PIC16F628A
INCLUDE <P16F628A.INC>

    ORG 0x00
    GOTO INICIO



INICIO
    BSF	    STATUS,5
    CLRF    TRISB
    BSF	    TRISA,0
    BCF	    STATUS,5

PROGRAMA
    BSF	    PORTB,0
    CALL    RETARDO_A
    BCF	    PORTB,1
    GOTO    PROGRAMA

; Retardos
; TOTAL: 20us
; Calculo de retardo: tiempo(cantidad) = 5 + cantidad + 2*cantidad
RETARDO_A	    ; CALL 2
    MOVLW   0x05    ; 1
    MOVWF   0x20    ; 1

RET_A
    DECFSZ  0x05, 1 ; (cantidad - 1) + 2
    GOTO    RET_A   ; (cantidad - 1) * 2
    RETURN	    ; 2

; Retardo de dos anidaciones

		    ; ciclos(p, q) = 7 + p + (p - 1) * (5 + q + 2*q)
RETARDO_B	    ; CALL 2us
    MOVLW   0x02    ; 1, aqui esta p
    MOVWF   0x20    ; 1
LAZO1B
    DECFSZ  0x20, 1 ; (p - 1) + 2
    GOTO    LAZO2B  ; (p - 1) * (5 + q + 2*q)
    RETURN	    ; 2

		    ; ciclos(q) = 5 + q + 2*q
LAZO2B		    ; CALL 2
    MOVLW   0X02    ; 1, aqui esta q
    MOVWF   0X21    ; 1
LAZO3B
    DECFSZ  0X21    ; (q - 1) + 2
    GOTO    LAZO3B  ; (q - 1) * 2
    GOTO    LAZO1B  ; 2


;;;;;;;;;;;;;;;;; Retardo de tres anidaciones ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Formula resumida:
; ciclos(p, q, z) = 5 + 3*p + 6*p*q + 3*p*q*z - 3*p*z - 6*q - 3*q*z + 3*z
; 12, 151, 200 => 1 000 007 ciclos
; 11, 203, 163 =>   999 998 ciclos

; 36, 249, 190 => 5 000 003 ciclos

; 71, 187, 254 => 9 999 998 ciclos
		    ; ciclos(p, q, z) = 7 + p + (p - 1) * (7 + q + (q - 1) * (5 + z + 2*z))
RETARDO_B	    ; CALL 2us
    MOVLW   0x02    ; 1, aqui esta p
    MOVWF   0x20    ; 1
LAZO1B
    DECFSZ  0x20, 1 ; (p - 1) + 2
    GOTO    LAZO2B  ; (p - 1) * (7 + q + (q - 1) * (5 + z + 2*z))
    RETURN	    ; 2

		    ; ciclos(q, z) = 7 + q + (q - 1) * (5 + z + 2*z)
LAZO2B		    ; CALL 2
    MOVLW   0X02    ; 1, aqui esta q
    MOVWF   0X21    ; 1
LAZO3B
    DECFSZ  0X21    ; (q - 1) + 2
    GOTO    LAZO3B  ; (q - 1) * (5 + z + 2*z)
    GOTO    LAZO1B  ; 2

		    ; ciclos(z) = 5 + z + 2*z
LAZO4B		    ; CALL 2
    MOVLW   0X02    ; 1, aqui esta z
    MOVWF   0X22    ; 1
LAZO5B
    DECFSZ  0X22    ; (z - 1) + 2
    GOTO    LAZO5B  ; (q - 1) * 2
    GOTO    LAZO3B  ; 2

END