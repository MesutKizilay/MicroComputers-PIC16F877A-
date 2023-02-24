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
; ---------- Your code starts here --------------------------

    
r1 EQU 0x26 
r2 EQU 0x27
r3 EQU 0x28
r4 EQU 0x29
r EQU 0x2A
x EQU 0x20
y EQU 0x21
z EQU 0x22
tempx EQU 0x23
tempy EQU 0x24
tempz EQU 0x25
 
;r1 = (4 * x + 3 * y - 2 * z - 5);20+18-14-5
 
    MOVLW d'5'
    MOVWF x
    MOVLW d'6'
    MOVWF y
    MOVLW d'7'
    MOVWF z
    
    MOVF x,W
    ADDWF x,W
    ADDWF x,W
    ADDWF x,W
    MOVWF tempx
    
    MOVF y,W
    ADDWF y,W
    ADDWF y,W
    MOVWF tempy
    
    MOVF z,W
    ADDWF z,W
    MOVWF tempz
    MOVLW d'5'
    ADDWF tempz,W
    SUBWF tempy,W
    ADDWF tempx,W
    
    MOVWF r1
    
;r2 = (x + 3) * 4 - 2 * y - z;  32-14-7 
    
    MOVLW d'3'
    ADDWF x,W
    MOVWF tempx
    ADDWF tempx,W
    ADDWF tempx,W
    ADDWF tempx,W
    MOVWF tempx
    
    MOVF y,W
    ADDWF y,W
    MOVWF tempy
    
    MOVF z,W
    ADDWF tempy,W
    SUBWF tempx,W
    
    MOVWF r2
    
;r3 = x / 2 + y / 2 + z; 2+3+7=12
    
    BCF STATUS,C
    RRF x,W
    MOVWF tempx
    
    BCF STATUS,C
    RRF y,W
    MOVWF tempy
    
    ADDWF z,W
    ADDWF tempx,W
    
    MOVWF r3
    MOVWF PORTD
    
;r4 = (x + 2 * y - z) * 2 + 10;
    
    MOVF y,W
    ADDWF y,W
    MOVWF tempy
    
    MOVF z,W
    SUBWF tempy,W
    ADDWF x,W
    MOVWF tempx
    ADDWF tempx,W
    ADDLW 10
    
    MOVWF r4
    
    
;r = 3 * r1 + 4 * r2 - r3 / 2 - r4;
    
    MOVF r1,W
    ADDWF r1,W
    ADDWF r1,W
    MOVWF r1
    
    MOVF r2,W
    ADDWF r2,W
    ADDWF r2,W
    ADDWF r2,W
    MOVWF r2
    
    BCF STATUS,C
    RRF r3,W
    MOVWF r3
    
    MOVF r4,W
    ADDWF r3,W
    SUBWF r2,W
    ADDWF r1,W
    
    MOVWF r
    MOVWF PORTD
LOOP	GOTO $
    
    END