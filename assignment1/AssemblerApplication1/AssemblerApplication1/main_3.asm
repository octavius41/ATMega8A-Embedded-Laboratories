/*
 * AsmFile1.asm
 *
 *  Created: 22/11/2023 19:49:49
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

.org 0x0009
	rjmp isr_t0

.include "macros.asm"
.include "display.asm"

isr_t0:
	cli
	ldi r16, 9
	mov r5,r16

	ldi r16, 5
	mov r6,r16

	ldi r16, 3
	mov r7,r16

	rcall display
	sei
reti

on_reset:
	stackreg
	config
	config_t0
	sei

main:
	nop
	rjmp main
