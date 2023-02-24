;Mesut KIZILAY 152120181053
;Hasan Can GÖRMEZ 152120181035

LIST P=16F877A
INCLUDE P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF &_DEBUG_OFF & _CPD_OFF
radix dec
; Reset vector
org 0x00
    
x    EQU 0x20
y    EQU 0x21
N    EQU 0x22
noElements EQU  0x23
sum	   EQU  0x24
count	   EQU  0x25
R_L	   EQU	0x26
R_H	   EQU	0x27
z	   EQU  0x28
tempx	   EQU  0x30
tempy      EQU  0x31
tempxy	   EQU  0x32
Q	   EQU  0x33
A	   EQU  0x35
    
    MOVLW d'15'
    MOVWF x
    
    MOVLW d'35'
    MOVWF y
    
    MOVLW d'50'
    MOVWF N

    CALL GenerateNumbers
    MOVWF noElements
    CALL AddNumbers
    MOVWF sum
    CALL DisplayNumbers
    
Multiply
    MOVF x,W
    MOVWF tempx
    MOVF y,W
    MOVWF tempy
    
    CLRF    R_L		; R_L = 0
    CLRF    R_H		; R_H = 0
    MOVF    tempy, F	; Y = Y
    BTFSC   STATUS, Z	; Is Y==0?
    RETURN		; Return from the function if Y == 0

    MOVFW   tempx		; WREG = X
    
Multiply_Loop
    ADDWF   R_L, F	; R_L = R_L + WREG
    BTFSC   STATUS, C	; Is there a carry from this addition?
    INCF    R_H, F	; R_H = R_H + 1
    DECFSZ  tempy, F	; Y = Y-1
    GOTO    Multiply_Loop
    
    MOVLW z
    MOVWF FSR
    
    MOVF R_L,W
    MOVWF INDF
    
    MOVF R_H,W
    INCF FSR, F
    MOVWF INDF
    
    MOVF z,W
    ADDWF z+1,W
    RETURN   
    
GenerateNumbers
    
    CLRF count
START_WHILE
    MOVF N,W
    SUBWF x,W;wreg=tempx-n
    BTFSC STATUS,C
    GOTO END_LOOP
    
    MOVF N,W
    SUBWF y,W;wreg=tempy-n
    BTFSC STATUS,C
    GOTO END_LOOP
    
    MOVF x,W
    ADDWF y,W
    MOVWF tempxy
    
    BCF STATUS,C
    RRF tempxy,F
    BCF STATUS,C
    RLF tempxy,F
    SUBWF tempxy,W
    BTFSC STATUS,Z
    GOTO ELSE_LABEL
    
    CALL Multiply
    MOVWF tempx
    MOVLW A
    ADDWF count,W
    MOVWF FSR
    MOVF tempx,W
    MOVWF INDF
    INCF  FSR, F
    INCF count,F
    INCF x,F
    GOTO START_WHILE
    
ELSE_LABEL
    
    MOVF x,W
    ADDWF y,W
    MOVWF tempxy
    CLRF Q
  
Division_Loop
    MOVLW d'3'
    SUBWF tempxy,W
    BTFSS STATUS,C
    GOTO Division_End
    
    INCF Q,F
    MOVWF tempxy
    GOTO Division_Loop
    
Division_End  
    MOVLW A
    ADDWF count,W
    MOVWF FSR
    MOVF Q,W
    
    MOVWF INDF
    INCF  FSR, F
    INCF count,F
    MOVLW d'3'
    ADDWF y,F
    GOTO START_WHILE
    
END_LOOP
    MOVF count,W
    RETURN
    
AddNumbers
    
    i EQU 0x34
    CLRF sum
    CLRF i
    MOVLW A
    MOVWF FSR
Loop_Begin
    MOVF count,W
    SUBWF i,W;wreg=i-count
    BTFSC STATUS,C
    GOTO Loop_End
    
    
    MOVF    INDF, W
    ADDWF   sum, F
    INCF    FSR, F
    INCF i,F
    GOTO Loop_Begin
    
Loop_End
    MOVF sum,W
    RETURN
    
DisplayNumbers
    BSF	    STATUS, RP0	; Select Bank 1
    ;CLRF	    TRISB	; All pins of PORTB output
    CLRF	    TRISD	; All pins of PORTD output
    BSF	    TRISB,3
    
    BCF	    STATUS, RP0	; Select Bank 0
    ;CLRF	    PORTB	; All LEDs off	
    CLRF	    PORTD	; All LEDs off
    
    MOVF sum,W
    MOVWF PORTD
    
BUSY_LOOP_BEGIN
    BTFSC PORTB, 3
    GOTO  BUSY_LOOP_BEGIN
	
    CLRF i
    MOVLW A
    MOVWF FSR
Loop_Begin2
    MOVLW d'5'
    SUBWF i,W;wreg=i-count
    BTFSC STATUS,C
    GOTO Loop_End2
    
    CALL Delay250ms
    MOVF INDF,W
    MOVWF PORTD
    
   
    INCF FSR,F
    INCF i,F
    
BUSY_LOOP_BEGIN2
    BTFSC PORTB, 3
    GOTO  BUSY_LOOP_BEGIN2
    
    GOTO Loop_Begin2
    
Loop_End2  

Delay250ms
    k	    EQU	    0x70		    ; Use memory slot 0x70
    j	    EQU	    0x71		    ; Use memory slot 0x71
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
	    
   GOTO $
   END