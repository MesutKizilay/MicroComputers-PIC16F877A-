LIST P=16F877A
INCLUDE P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF &_DEBUG_OFF & _CPD_OFF
radix dec
; Reset vector
org 0x00
; ---------- Initialization ---------------------------------
BSF STATUS, RP0 ; Select Bank1
CLRF TRISB ; Set all pins of PORTB as output
CLRF TRISD ; Set all pins of PORTD as output
BCF STATUS, RP0 ; Select Bank0
CLRF PORTB ; Turn off all LEDs connected to PORTB
CLRF PORTD ; Turn off all LEDs connected to PORTD
; ---------- Your code starts here --------------------------
#if 0
;--------------------------------------------------------------------------
; Now that we know almost all PIC16F877A instructions, lets evaluate some 
; arbitrary arithmetic expressions
; x = 36; y=5;
; r = (x+4)-(y*2)
;--------------------------------------------------------------------------
tmp	EQU	0x20	; A temporary variable
x	EQU	0x21
y	EQU	0x22
r	EQU	0x23
   
    MOVLW   d'36'	; WREG = 36
    MOVWF   x		; x = WREG
    MOVLW   d'5'	; WREG = 5
    MOVWF   y		; y = WREG

    MOVLW   4		; WREG = 4
    ADDWF   x, W	; WREG = x + WREG  (WREG = x+4)
    MOVWF   tmp		; tmp = WREG   
    
    MOVF    y, W	; WREG = y
    ADDWF   y, W	; WREG = WREG + y = y + y = 2*y
    SUBWF   tmp, W	; WREG = tmp - WREG ==> WREG = (x+4)-(y*2)
    
    MOVWF   r		; r = WREG
    ;MOVWF PORTD
    
#endif        
#if 1
temp EQU 0x30
MOVLW d'5' ; Put decimal 19 in WREG
MOVWF temp
;BCF STATUS,C
RRF temp,W
;RRF temp,W
#endif
; ---------- Your code ends here ----------------------------
MOVWF PORTD ; Send the result stored in WREG to PORTD to display it on the LEDs
LOOP GOTO $ ; Infinite loop
END ; End of the program