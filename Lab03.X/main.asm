;Mesut KIZILAY 152120181053
;Hasan Can GÖRMEZ 152120181035

LIST P=16F877A
INCLUDE P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF &_DEBUG_OFF & _CPD_OFF
radix dec
; Reset vector
org 0x00
; ---------- Initialization ---------------------------------
BSF	    STATUS, RP0	; Select Bank 1
;CLRF	    TRISB	; All pins of PORTB output
CLRF	    TRISD	; All pins of PORTD output
BSF	    TRISB,3
    
BCF	    STATUS, RP0	; Select Bank 0
;CLRF	    PORTB	; All LEDs off	
CLRF	    PORTD	; All LEDs off	
; ---------- Your code starts here --------------------------
    
   fib0 EQU 0x20
   fib1 EQU 0x21
   fib  EQU 0X22
   i    EQU 0x23
   N    EQU 0x24
   temp EQU 0x25
 
	
   MOVLW d'13'
   MOVWF N
   
   MOVLW d'2'
   MOVWF i
   
   MOVLW d'0'
   MOVWF fib0
   
   MOVLW d'1'
   MOVWF fib1
   
loop_begin	
	; Check if i<=N? If not, we will terminate the loop
	; The loop terminates when i > N or N < i.
	MOVF	i, W		    ; WREG = i
	SUBWF	N, W		    ; WREG = N - i
	BTFSS	STATUS, C	    ; No carry means N < i. Carry means N >= i or i <= N
	GOTO	loop_end	    ; when i > N, the loop terminates
loop_body			    ; This label is not necessary. I put it just for clarification purposes	
	MOVF fib0,W
	ADDWF fib1,W
	MOVWF fib
	
	MOVF fib1,W
	MOVWF fib0
	
	MOVF fib,W
	MOVWF fib1
	
	INCF	i, F
	
	CALL Delay250ms
	
	MOVF fib,W
	MOVWF PORTD
	
BUSY_LOOP_BEGIN
	BTFSC PORTB, 3
	GOTO  BUSY_LOOP_BEGIN
	
	GOTO  loop_begin
	
loop_end

Delay250ms:
k	EQU	    0x70		    ; Use memory slot 0x70
j	EQU	    0x71		    ; Use memory slot 0x71
	MOVLW	    d'250'		    ; 
	MOVWF	    k			    ; k = 250
Delay250ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    j			    ; j = 250
Delay250ms_InnerLoop	
	NOP
	DECFSZ	    j, F		    ; j--
	GOTO	    Delay250ms_InnerLoop

	DECFSZ	    k, F		    ; k?
	GOTO	    Delay250ms_OuterLoop    
	RETURN	
lOOP GOTO	$	
END