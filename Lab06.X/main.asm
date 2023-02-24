;Mesut KIZILAY 152120181053
;Hasan Can GÖRMEZ 152120181035
LIST 	P=16F877A
INCLUDE	P16F877.INC
radix	dec
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF


org	    0x00
BSF	    STATUS, RP0		; Select Bank1
CLRF    TRISA		; PortA --> Output
CLRF    TRISD		; PortD --> Output
CLRF    TRISB
BCF	    STATUS, RP0		; Select Bank0

; Clear PORTD & PORTA
CLRF    PORTD		; PORTD = 0
CLRF    PORTA		; Deselect all SSDs
CLRF	PORTB
    
number EQU 0x24
digit0 EQU 0x20
digit1 EQU 0x21	
no_iteration EQU 0x22
i EQU 0x23

CLRF    i
CLRF    number

MOVLW d'90'
MOVWF no_iteration

MOVLW d'0'
MOVWF digit0

MOVLW d'0'
MOVWF digit1

_WHILE
    _FOR
	MOVF no_iteration,W
	SUBWF i,W
	BTFSC STATUS,C
	GOTO END_FOR

	BSF PORTA,5
	BCF PORTA,4
	MOVF digit0,W
	CALL GetCode
	MOVWF PORTD
	CALL Delay5ms
	
	BSF PORTA, 4
	BCF PORTA,5
	MOVF digit1,W
	CALL GetCode
	MOVWF PORTD
	CALL Delay5ms
	INCF i,F
	GOTO _FOR	
    END_FOR

    CLRF i
    INCF digit0,F

    _IF
	MOVLW d'10'
	SUBWF digit0,W
	BTFSS STATUS,Z
	GOTO NEXT_IF
	CLRF digit0
	INCF digit1,F

    NEXT_IF
	MOVLW d'2'
	SUBWF digit1,W
	BTFSS STATUS,Z
	GOTO _WHILE

	MOVLW d'1'
	SUBWF digit0,W
	BTFSS STATUS,Z
	GOTO _WHILE

	CLRF digit0
	CLRF digit1
	GOTO _WHILE
    END_IF
END_WHILE

GetCode
ADDWF   PCL, F		; Jump to the correct number. PCL is the program counter register
RETLW   B'00111111'		; 0
RETLW   B'00000110'		; 1
RETLW   B'01011011'		; 2
RETLW   B'01001111'		; 3
RETLW   B'01100110'		; 4
RETLW   B'01101101'		; 5
RETLW   B'01111101'		; 6
RETLW   B'00000111'		; 7
RETLW   B'01111111'		; 8
RETLW   B'01101111'		; 9    
RETLW   B'01110111'		; A
RETLW   B'01111100'		; b    
RETLW   B'00111001'		; C    
RETLW   B'01011110'		; d    
RETLW   B'01111001'		; E    
RETLW   B'01110001'		; F    

Delay5ms
k	EQU	    0x70		    ; Use memory slot 0x70
j	EQU	    0x71		    ; Use memory slot 0x71
    MOVLW	    d'5'		    ; 
    MOVWF	    k			    ; i = 5
Delay5ms_OuterLoop
    MOVLW	    d'250'
    MOVWF	    j			    ; j = 250
Delay5ms_InnerLoop	
    NOP
    DECFSZ	    j, F		    ; --j == 0?
    GOTO	    Delay5ms_InnerLoop

    DECFSZ	    k, F		    ; --i == 0?
    GOTO	    Delay5ms_OuterLoop
    RETURN
    
LOOP GOTO  $
END