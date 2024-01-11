/*
 * AsmFile1.asm
 *
 *  Created: 27/12/2023 23:05:12
 *   Author: Grachus
 */ 


	 ;A-PD4, B-PD5, C-PD6, D-PD7, E-PB0, F-PC2, G-PC1, DP-PC0
	;DIGIT1 CATHODE-PD3
	;DIGIT2 CATHODE-PD1
	;DIGIT3 CATHODE-PD0 

	;LED FOR PWM-PB1
	;PB2-BUTON WITH EXTERNAL PULL-UP RESISTANCE
	;PD2-BUTON (INT0) WITHOUT EXTERNAL PULL-UP RESISTANCE

	 .org 0x0000
		rjmp on_reset

	.org 0x0004
		rjmp isr_t2

	.org 0x0009
		rjmp isr_t0

	.org 0x000E
		rjmp isr_adc			; adc interrupt routine 

	.include "macros.asm"
	.include "display.asm"
	.include "functions.asm"

	isr_t2:
		nop
	reti

	isr_t0:
	cli
	sbrs r29, 0
	rjmp show_adc
	rjmp show_set_value

	show_adc:
	macro_display r24, r25 
	ldi r16, 240 
	out tcnt0, r16 
	reti 

	show_set_value:
	macro_display r14, r15 
	ldi r16, 240
	out tcnt0, r16 
	reti 



	isr_adc:
		cli
		in r24,adcl
		in r25,adch
		sbi adcsra,adsc			
		sei
	reti 

	on_reset:
		stackreg
		config_io
		config_t0
		config_t2
		_check_eeprom
		config_adc
		clr r29
		sei

	main:

		sbi adcsra,adsc 
		rcall start 
		sbis pinb, pinb2 ; IF PORTB2 PIN PRESSED, CALL ARTIR
		rcall art
		sbic pinb, pinb2 ; IF PORTB2 PIN UN-PRESSED, CLEAR R30
		cbr r30, 1
		rcall delay_sec
		sbis pind, pind2 ; IF PORTD2 PIN PRESSED, CALL AZALT
		rcall azalt
		sbic pind, pind2 ; IF PORTD2 PIN UN-PRESSED, CLEAR R31
		cbr r31, 1
		rcall delay_sec
		rjmp main

	start:
		sbic pinb, pinb2
		ret
		sbic pind, pind2
		ret
		rcall delay_sec
		sbrs r29,0
		rjmp set_goster
		rjmp adc_goster

	set_goster:
		_read_set
		sbr r29,1
	ret


	adc_goster:
		save_set r15, r14
		save_set r25, r24
		cbr r29,1
	ret


	art:
		sbrc r30,0
		ret
		sbis pinb, pinb2 ;IF PORTB2 PIN PRESSED, INC R14
		inc r14
		;inc r24
		sbr r30,1
		ret
	azalt:
		sbrc r31,0
		ret
		sbis pind, pind2 ;IF PORTD2 PIN PRESSED, DEC R14
		dec r14
		;dec r24
		sbr r31,1
		ret

