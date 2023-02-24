    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    radix	dec
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

    ; Reset vector
    org 0x00
    ; ---------- Initialization ---------------------------------
    BSF     STATUS, RP0			; Select Bank1
    CLRF    TRISB	                ; Set all pins of PORTB as output
    CLRF    TRISD	                ; Set all pins of PORTD as output
    BCF     STATUS, RP0			; Select Bank0    
    CLRF    PORTB	                ; Turn off all LEDs connected to PORTB
    CLRF    PORTD			; Turn off all LEDs connected to PORTD
    
    ; ---------- Your code starts here --------------------------
    
    ; NAME	: 
    ; SURNAME	: 
    ; NUMBER	: 1521201810
    
r	EQU	0x20
r1	EQU	0x21
r2	EQU	0x22
r3	EQU	0x23
r4	EQU	0x24
x	EQU	0x25
y	EQU	0x26
z	EQU	0x27
	
    MOVLW   d'10'	; WREG = 5
    MOVWF   x		; [x] = WREG
    MOVLW   d'11'	; WREG = 6
    MOVWF   y		; [y] = WREG
    MOVLW   d'12'	; WREG = 7
    MOVWF   z		; [z] = WREG

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; r1 = (5 * x - 2 * y + z - 3); ==> 17 ==> r1	EQU	0x21
    MOVF    x, W	; WREG = [x]
    ADDWF   x, W	; WREG = [x] + WREG => x + x   = 2*x
    ADDWF   x, W	; WREG = [x] + WREG => x + 2*x = 3*x
    ADDWF   x, W	; WREG = [x] + WREG => x + 3*x = 4*x
    ADDWF   x, W	; WREG = [x] + WREG => x + 4*x = 5*x
    MOVWF   r1		; [r1] = WREG	    => r1 = 5*x

    MOVF    y, W	; WREG = [y]
    ADDWF   y, W	; WREG = [y] + WREG => y + y   = 2*y

    SUBWF   r1, W	; WREG = [r1] - WREG => 5*x - 2*y

    ADDWF   z, W	; WREG = [z] + WREG => z + (5*x - 2*y)
    
    MOVWF   r1		; [r1] = WREG ==> r1 = 5*x - 2*y + z
    MOVLW   d'3'	; WREG = 3
    SUBWF   r1, W	; WREG = [r1] - WREG => (5*x - 2*y + z) - 3
    MOVWF   r1		; [r1] = WREG ==> r1 = 5*x - 2*y + z - 3

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; r2 = (x + 5) * 4 - 3 * y + z; ==> 29 ==> r2	EQU	0x22
    MOVLW   d'5'	; WREG = 5
    ADDWF   x, W	; WREG = [x] + WREG => x + 5
    MOVWF   r2		; [r2] = WREG ==> r2 = (x + 5)
    ADDWF   r2, W	; WREG = [r2] + WREG => (x + 5) + (x + 5) = 2*(x + 5)
    ADDWF   r2, W	; WREG = [r2] + WREG => (x + 5) + 2*(x + 5) = 3*(x + 5)
    ADDWF   r2, W	; WREG = [r2] + WREG => (x + 5) + 3*(x + 5) = 4*(x + 5)
    MOVWF   r2		; [r2] = WREG ==> r2 = 4*(x + 5)
    
    MOVF    y, W	; WREF = [y]
    ADDWF   y, W	; WREG = [y] + WREG => y + y = 2*y
    ADDWF   y, W	; WREG = [y] + WREG => y + 2*y = 3*y
    SUBWF   r2, W	; WREG = [r2] - WREG => 4*(x + 5) - 3*y
    ADDWF   z, W	; WREG = [z] + WREG => z + (4*(x + 5) - 3*y)
    MOVWF   r2		; [r2] = WREG => r2 = 4*(x + 5) - 3*y + z
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; r3 = x / 2 + y / 2 + z / 4  ==> 2 + 3 + 1 = 6 ==> r3	EQU	0x23
    BCF	    STATUS, C	; Clear bit
    RRF	    x,	W	; WREG = ([x]>>1) => [x] = x/2
    MOVWF   r3		; [r3] = WREG => [r3] = x/2
    MOVF    y,	W	; WREG = [y]
    BCF	    STATUS, C	; Clear bit
    RRF	    y,	W	; WREG = ([y]>>1) => [y] = y/2
    
    ADDWF   r3,	W	; WREG = [r3] + WREG => x/2 + y/2
    MOVWF   r3		; [r3] = WREG => [r3] = x/2 + y/2
    MOVF    z,	W	; WREG = [z]
    BCF	    STATUS, C	; Clear bit
    RRF	    z,	W	; WREG = ([z]>>1) => [z] = z/2
    MOVWF   r		; [r] = WREG => [r] = z/2
    BCF	    STATUS, C	; Clear bit
    RRF	    r,	W	; WREG = ([z]>>1) => [z] = (z/2)/2 = z/4
    ADDWF   r3,	W	; WREG = [r3] + WREG => (x/2 + y/2) + z/4
    MOVWF   r3		; [r3] = WREG => [r3] = x/2 + y/2 + z/4
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; r4 = (3 * x - y - 3 * z) * 2 - 30 ==> -54  ==>	r4	EQU	0x24
    MOVF    x,	W	; WREG = [x]
    ADDWF   x,	W	; WREG = [x] + WREG => x + x   = 2*x
    ADDWF   x,	W	; WREG = [x] + WREG => x + 2*x = 3*x
    MOVWF   r4		; [r4] = WREG => [r4] = 3*x
    MOVF    y,	W	; WREG = [y]
    SUBWF   r4,	W	; WREG = [r4] - WREG => 3*x - y
    MOVWF   r4		; [r4] = WREG => [r4] = 3*x - y
    MOVF    z,	W	; WREG = [z]
    ADDWF   z,	W	; WREG = [z] + WREG => z + z   = 2*z
    ADDWF   z,	W	; WREG = [z] + WREG => z + 2*z = 3*z
    SUBWF   r4,	W	; WREG = [r4] - WREG => (3*x - y) - 3*z
    MOVWF   r4		; [r4] = WREG => [r4] = 3*x - y - 3*z
    ADDWF   r4,	W	; WREG = [r4] + WREG => (3*x - y - 3*z) + (3*x - y - 3*z) = 2*(3*x - y - 3*z)
    MOVWF   r4		; [r4] = WREG => [r4] = 2*(3*x - y - 3*z)
    MOVLW   d'30'	; WREG = 30
    SUBWF   r4, W	; WREG = [r4] - WREG => 2*(3*x - y - 3*z) - 30
    MOVWF   r4		; [r4] = WREG => [r4] = 2*(3*x - y - 3*z) - 30
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; r = 3 * r1 + 2 * r2 - r3 / 2 - r4 ==> 160  ==>	r	EQU	0x20
    MOVF    r1,	W	; WREG = [r1]
    ADDWF   r1,	W	; WREG = [r1] + WREG => r1 + r1   = 2*r1
    ADDWF   r1,	W	; WREG = [r1] + WREG => r1 + 2*r1 = 3*r1
    MOVWF   r		; [r] = WREG ==> [r] = 3*r1
    MOVF    r2,	W	; WREG = [r2]
    ADDWF   r2,	W	; WREG = [r2] + WREG => r2 + r2     = 2*r2
    ADDWF   r,	W	; WREG = [r] + WREG => 3*r1 + 2*r2
    MOVWF   r		; [r] = WREG ==> [r] = 3*r1 + 2*r2
    MOVF    r3,	W	; WREG = [r3]
    BCF	    STATUS, C	; Clear bit
    RRF	    r3,	W	; WREG = ([r3]>>1) => [r3] = r3/2
    SUBWF   r,	W	; WREG = [r] - WREG => (3*r1 + 2*r2) - (r3/2)
    MOVWF   r		; [r] = WREG ==> [r] = 3*r1 + 2*r2 - r3/2
    MOVF    r4,	W	; WREG = [r4]
    SUBWF   r,	W	; WREG = [r] - WREG => (3*r1 + 2*r2 - r3/2) - (r4)
    MOVWF   r		; [r] = WREG ==> [r] = 3*r1 + 2*r2 - r3/2 - r4
    
    ; ---------- Your code ends here ----------------------------    
    MOVWF   PORTD    	; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP    GOTO    $	; Infinite loop
     END                               ; End of the program


