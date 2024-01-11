/*
 * AsmFile1.asm
 *
 *  Created: 15/11/2023 19:39:41
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

.include "macros.asm"
.include "display.asm"

on_reset:
	stackreg	;macro for sp_low and sp_high
	config		;macro for in, out and timer0 setup

main:
		rcall display
		rjmp main