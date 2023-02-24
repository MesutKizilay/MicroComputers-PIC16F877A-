   ;Mesut KIZILAY 152120181053
   ;Hasan Can GÖRMEZ 152120181035 
    LIST 	P=16F877
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF 
    
    ; Reset vector
    org	0x00	
	GOTO	MAIN		; Jump to the main function
	
    #include <Delay.inc>	; Delay library (Copy the contents here)
    #include <LcdLib.inc>	; LcdLib.inc (LCD) utility routines

    ; This is the start of our main function
MAIN:    
    BSF     STATUS, RP0	; Select Bank1
    MOVLW	0x0	 	; WREG <- 0	
    MOVWF	TRISD		; Make all pins of PORTD output
    MOVWF	TRISE		; Make all ports of PORTE output
    MOVWF	TRISB
    MOVWF	TRISA
    ; This is only necessary because our programming board connects E0, E1 and E2 pins of the MCU
    ; to LCD's control pins RS, RW, EN respectively. Because PORTE shares the same pins as the analog pins of PORTA of the MCU,
    ; not only we must we set PORTE pins as output, but also set the analog pins of PORTA as digital output.
    ; If we don't do this, PORTE's pins are not set up properly, and the LCD does not work	
    MOVLW	0x03		; Choose RA0 analog input and RA3 reference input
    MOVWF	ADCON1		; Register to configure PORTA's pins as analog/digital <11> means, all but one are analog

    BCF	    STATUS, RP0	; Select Bank0
    CLRF	PORTD		; PORTD = 0
    CLRF	PORTA		; Deselect all SSDs
    CLRF	PORTB
    CALL	LCD_Initialize	; Initialize the LCD

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
	BCF PORTA,5
	BCF PORTA,4
	CALL DisplayCounter
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
	    CALL Delay_5ms

	    BSF PORTA, 4
	    BCF PORTA,5
	    MOVF digit1,W
	    CALL GetCode
	    MOVWF PORTD
	    CALL Delay_5ms
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
	    BCF PORTA,5
	    BCF PORTA,4
	    CALL NEXT_TEXT
	    GOTO _FOR
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

DisplayCounter
    call	LCD_Clear		; Clear the LCD screen

    movlw	'C'	
    call	LCD_Send_Char
    movlw	'o'	
    call	LCD_Send_Char
    movlw	'u'	
    call	LCD_Send_Char
    movlw	'n'	
    call	LCD_Send_Char
    movlw	't'	
    call	LCD_Send_Char
    movlw	'e'	
    call	LCD_Send_Char
    movlw	'r'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    movlw	'V'	
    call	LCD_Send_Char
    movlw	'a'	
    call	LCD_Send_Char
    movlw	'l'	
    call	LCD_Send_Char
    movlw	':'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    
    MOVF	digit1, W ; WREG <- digit
    ADDLW	'0'	    ; Add '0' to the digit 
    CALL	LCD_Send_Char

    ; Print digit1: digits[2]
    MOVF	digit0, W ; WREG <- digit
    ADDLW	'0'	    ; Add '0' to the digit 
    CALL	LCD_Send_Char
    
    CALL	LCD_MoveCursor2SecondLine    
    
    movlw	'C'	
    call	LCD_Send_Char
    movlw	'o'	
    call	LCD_Send_Char
    movlw	'u'	
    call	LCD_Send_Char
    movlw	'n'	
    call	LCD_Send_Char
    movlw	't'	
    call	LCD_Send_Char
    movlw	'i'	
    call	LCD_Send_Char
    movlw	'n'	
    call	LCD_Send_Char
    movlw	'g'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    movlw	'u'	
    call	LCD_Send_Char
    movlw	'p'	
    call	LCD_Send_Char
    movlw	'.'	
    call	LCD_Send_Char
    movlw	'.'	
    call	LCD_Send_Char
    movlw	'.'	
    call	LCD_Send_Char
    RETURN
NEXT_TEXT	;?Rolled over to 0?
    call	LCD_Clear
    
    movlw	'C'	
    call	LCD_Send_Char
    movlw	'o'	
    call	LCD_Send_Char
    movlw	'u'	
    call	LCD_Send_Char
    movlw	'n'	
    call	LCD_Send_Char
    movlw	't'	
    call	LCD_Send_Char
    movlw	'e'	
    call	LCD_Send_Char
    movlw	'r'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    movlw	'V'	
    call	LCD_Send_Char
    movlw	'a'	
    call	LCD_Send_Char
    movlw	'l'	
    call	LCD_Send_Char
    movlw	':'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    
    MOVF	digit1, W ; WREG <- digit
    ADDLW	'0'	    ; Add '0' to the digit 
    CALL	LCD_Send_Char

    ; Print digit1: digits[2]
    MOVF	digit0, W ; WREG <- digit
    ADDLW	'0'	    ; Add '0' to the digit 
    CALL	LCD_Send_Char
    
    CALL	LCD_MoveCursor2SecondLine
    movlw	'R'	
    call	LCD_Send_Char
    movlw	'o'	
    call	LCD_Send_Char
    movlw	'l'	
    call	LCD_Send_Char
    movlw	'l'	
    call	LCD_Send_Char
    movlw	'e'	
    call	LCD_Send_Char
    movlw	'd'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    movlw	'o'	
    call	LCD_Send_Char
    movlw	'v'	
    call	LCD_Send_Char
    movlw	'e'	
    call	LCD_Send_Char
    movlw	'r'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    movlw	't'	
    call	LCD_Send_Char
    movlw	'o'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    movlw	'0'	
    call	LCD_Send_Char
    RETURN
LOOP GOTO  $
END