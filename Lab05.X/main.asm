;Mesut KIZILAY 152120181053
;Hasan Can GÖRMEZ 152120181035

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

    
MOVE_LEFT  EQU 0x20
MOVE_RIGHT EQU 0x21
dir        EQU 0x22
val        EQU 0x23
count	   EQU 0x24

MOVLW d'0'
MOVWF MOVE_LEFT
MOVWF dir

MOVLW d'1'
MOVWF MOVE_RIGHT	   
MOVWF val

_WHILE	   
    MOVF val,W         
    MOVWF PORTD
    CALL Delay	

    INCF count,F

    _IF	   
	MOVLW d'15'
	SUBWF count,W
	BTFSS STATUS,Z
	GOTO _ELSE

	MOVLW 0x00
	MOVWF PORTD
	CALL Delay

	MOVLW 0xFF
	MOVWF PORTD
	CALL Delay

	MOVLW 0x00
	MOVWF PORTD
	CALL Delay

	MOVLW 0xFF
	MOVWF PORTD
	CALL Delay

	MOVLW 0x00
	MOVWF PORTD
	CALL Delay

	MOVLW d'1'	   
	MOVWF val
	CLRF count	   
	MOVF MOVE_LEFT,W
	MOVWF dir
	
GOTO _WHILE

    _ELSE	   
	MOVLW 0x80
	SUBWF val,W
	BTFSS STATUS,Z
	GOTO _if

	MOVF MOVE_RIGHT,W
	MOVWF dir

	_if
	    MOVF MOVE_LEFT,W
	    SUBWF dir,W
	    BTFSS STATUS,Z
	    GOTO _else

	    BCF STATUS,C
	    RLF val,F
	    GOTO _WHILE

	_else
	    BCF STATUS,C
	    RRF val,F  

GOTO _WHILE	
	    
Delay
    CALL Delay250ms
   ;CALL Delay500ms
    RETURN	
	   
Delay500ms
i	EQU	    0x70
j	EQU	    0x71
k	EQU	    0x72
	MOVLW	    d'2'
	MOVWF	    i			    ; i = 2
Delay500ms_Loop1_Begin
	MOVLW	    d'250'
	MOVWF	    j			    ; j = 250
Delay500ms_Loop2_Begin	
	MOVLW	    d'250'
	MOVWF	    k			    ; k = 250
Delay500ms_Loop3_Begin	
	NOP				    ; Do nothing
	DECFSZ	    k, F		    ; k--
	GOTO	    Delay500ms_Loop3_Begin

	DECFSZ	    j, F		    ; j--
	GOTO	    Delay500ms_Loop2_Begin

	DECFSZ	    i, F		    ; i?
	GOTO	    Delay500ms_Loop1_Begin    
	RETURN	  
	
Delay250ms:
i	EQU	    0x70		    ; Use memory slot 0x70
j	EQU	    0x71		    ; Use memory slot 0x71
	MOVLW	    d'250'		    ; 
	MOVWF	    i			    ; i = 250
Delay250ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    j			    ; j = 250
Delay250ms_InnerLoop	
	NOP
	DECFSZ	    j, F		    ; j--
	GOTO	    Delay250ms_InnerLoop

	DECFSZ	    i, F		    ; i?
	GOTO	    Delay250ms_OuterLoop    
	RETURN
	

    
LOOP GOTO  $
END


