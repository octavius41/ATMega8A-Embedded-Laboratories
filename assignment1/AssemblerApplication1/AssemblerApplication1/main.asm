;
; AssemblerApplication1.asm
;
; Created: 08/11/2023 21:27:32
; Author : Grachus
;


; Replace with your application code
; ASSIGNMENT1.asm
;
; A-PD4, B-PD5, C-PD6, D-PD7, E-PB0, F-PC2, G-PC1, DP-PC0
; DIGIT1 CATHODE-PD3
; DIGIT2 CATHODE-PD1
; DIGIT3 CATHODE-PD0 
; LED FOR PWM-PB1
; PB2-BUTON WITH EXTERNAL PULL-UP RESISTANCE
; PD2-BUTON (INT0) WITHOUT EXTERNAL PULL-UP RESISTANCE
.org 0x0000
rjmp on_reset
on_reset:
;stack pointer setup
	ldi r16, HIGH(RAMEND)
    out SPH, r16
    ldi r16, LOW(RAMEND)
    out SPL, r16

;input - output setup

ldi	R16, 0x03 ; 0X03 = 0000 0011
out DDRB, R16 ; logic 1 assigns as out 0's assigned as input, for in command reverse operation applies.

ldi	R16, 0x0F ; 0X07 = 0000 0111
out DDRC, R16 ; PC0, PC1, PC2 assigned as out rest is input.

ldi R16, 0xFF ; 0xFF = 11111111
out DDRD, R16 ; all bits assigned as output

main:
;display “9” to digit3
	cbi PORTD, 3
	cbi PORTD, 1
	cbi PORTD, 0

	sbi PORTD, 0
	sbi PORTD, 4
	sbi PORTD, 5
	sbi PORTD, 6
	sbi PORTD, 7
	sbi PORTC, 1
	sbi PORTC, 2


	cbi PORTD, 0
	cbi PORTD, 4
	cbi PORTD, 5
	cbi PORTD, 6
	cbi PORTD, 7
	cbi PORTC, 1
	cbi PORTC, 2

;display “5” to digit2
	cbi PORTD, 3
	cbi PORTD, 1
	cbi PORTD, 0
	
	sbi PORTD, 1
	sbi PORTD, 4
	sbi PORTC, 2
	sbi PORTC, 1
	sbi PORTD, 6
	sbi PORTD, 7
	
	cbi PORTD, 1
	cbi PORTD, 4
	cbi PORTC, 2
	cbi PORTC, 1
	cbi PORTD, 6
	cbi PORTD, 7
;display “3” to digit1
	cbi PORTD, 3
	cbi PORTD, 1
	cbi PORTD, 0

	sbi PORTD, 3
	sbi PORTD, 4
	sbi PORTD, 5
	sbi PORTD, 6
	sbi PORTD, 7
	sbi PORTC, 1
	sbi PORTB, 0
	sbi PORTC, 2

	cbi PORTD, 3
	cbi PORTD, 0
	cbi PORTD, 4
	cbi PORTD, 5
	cbi PORTD, 6
	cbi PORTD, 7
	cbi PORTC, 1
	cbi PORTB, 0
	cbi PORTC, 2
	
rjmp main
