/*
 * AsmFile1.asm
 *
 *  Created: 21/12/2023 00:21:22
 *   Author: Grachus
 */ 

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

.org 0x0004
	rjmp isr_t2
.org 0x0009
	rjmp isr_t0

.include "macros.asm"
.include "display.asm"
.include "functions.asm"

isr_t2:
	nop
reti

isr_t0:
	cli
	mov r1,r14
	mov r2,r15
	rcall conv_hextodec
	rcall display
	ldi r16, 220	; brightness
	out tcnt0 ,r16
	sei
reti

on_reset:
	clr r16
	clr r14
	clr r15
	clr r29
	clr r30
	clr r31
	stackreg
	config_io
	_check_eeprom
	config_t0
	config_t2
	sei
	rjmp main

main:

	sbis pinb, pinb2 
	rcall PressedButtonB

	sbic pinb, pinb2 
	rcall UnPressedButtonB

	sbis pind, pind2 
	rcall PressedButtonD

	sbic pind, pind2 
	rcall UnPressedButtonD

	rcall checkBothButton




	rjmp main