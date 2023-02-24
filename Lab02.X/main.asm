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

    x EQU 0x20
    y EQU 0x21
    box EQU 0x22

    MOVLW d'8'
    MOVWF x
    MOVLW d'9'
    MOVWF y

    BTFSC x,7
    GOTO errorr

    MOVF x,W
    SUBLW d'11';WREG=11-x
    BTFSS STATUS,C;if x>11 C is 0, if x<=11 C is 1
    GOTO errorr

    BTFSC y,7
    GOTO errorr

    MOVF y,W
    SUBLW d'10'
    BTFSS STATUS,C;if y>10 C is 0, if y<10 C is 1
    GOTO errorr

    MOVF x,W
    SUBLW d'3'
    BTFSC STATUS,C;if x>3 is 0, if x<=3 C is 1
    GOTO if_1_less_than_3
    
    MOVF x,W
    SUBLW d'7'
    BTFSC STATUS,C;if x>7 is 0, if x<=7 C is 1
    GOTO if_2_less_than_
    
    MOVF y,W
    SUBLW d'2'
    BTFSS STATUS,C;if y>2 is 0, if y<=2 C is 1
    GOTO if_3_1_less_than_6
    MOVLW d'9'
    MOVWF box
    GOTO next_statement
if_3_1_less_than_6:
    MOVF y,W
    SUBLW d'6'
    BTFSS STATUS,C;if y>6 is 0, if y<=6 C is 1
    GOTO if_3_2_less_than_8
    MOVLW d'8'
    MOVWF box
    GOTO next_statement
if_3_2_less_than_8:
    MOVF y,W
    SUBLW d'8'
    BTFSS STATUS,C;if y>8 is 0, if y<=8 C is 1
    GOTO if_3_2_else
    MOVLW d'7'
    MOVWF box
    GOTO next_statement
if_3_2_else:
    MOVLW d'6'
    MOVWF box
    GOTO next_statement 
if_2_less_than_7:
    MOVF y,W
    SUBLW d'5'
    BTFSS STATUS,C;if y>5 is 0, if y<=5 C is 1
    GOTO if_2_1_else
    MOVLW d'5'
    MOVWF box
    GOTO next_statement
if_2_1_else:
    MOVLW d'4'
    MOVWF box
    GOTO next_statement 
if_1_less_than_3:
    MOVF y,W
    SUBLW d'1'
    BTFSS STATUS,C;if y>1 is 0, if y<=1 C is 1
    GOTO if_1_1_less_than_4
    MOVLW d'3'
    MOVWF box
    GOTO next_statement
if_1_1_less_than_4:
    MOVF y,W
    SUBLW d'4'
    BTFSS STATUS,C;if y>4 is 0, if y<=4 C is 1
    GOTO if_1_1_else
    MOVLW d'2'
    MOVWF box
    GOTO next_statement
if_1_1_else:
    MOVLW d'1'
    MOVWF box
    GOTO next_statement 
 

errorr:
    MOVLW -d'1'
    MOVWF box
    GOTO next_statement
    

    
next_statement:
    MOVF box,W
    


MOVWF PORTD ; Send the result stored in WREG to PORTD to display it on the LEDs
LOOP GOTO $ ; Infinite loop
END ; End of the program