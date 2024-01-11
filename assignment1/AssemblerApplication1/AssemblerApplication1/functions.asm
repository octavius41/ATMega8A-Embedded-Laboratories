/*
 * AsmFile1.asm
 *
 *  Created: 28/11/2023 19:34:10
 *   Author: Grachus
 */ 

 /*
r1=Low Byte Hex Number and r2=High Byte Hex Number
r3 and r4 = Divider Values
Result Digits r5-r6-r7-r8-r9
Hex Number : r1=0x03, r2=0XB9
Result : r9 r8 r7 r6 r5
		   0 0 9 5 3 
*/

; 0x03B9 -> to decimal

step_count: 
	 
	ldi r23,0xFF 
	ldi r24,0xE7 
	ldi r25,0x03 
	cp r14, r24 ; COMPARE LOW BYTE 
	cpc r15, r25 ; COMPARE HIGH BYTE
	breq backtozero ; IF Z=1 BRANCH 
	
	inc r14 
	cp r14, R23 
	breq inc_high 
	ret
inc_high: 
	clr r14 
	inc r15 
ret
	backtozero: 
	clr r14 
	clr r15 
ret
	 


conv_hextodec:
	ldi r16, HIGH(10000)
	mov r4, r16 
	ldi r16, LOW(10000)
	mov r3, r16 
	rcall DEC_DIG
	mov r9, r16 


	ldi r16, HIGH(1000)
	mov r4, r16
	ldi r16, LOW(1000)
	mov r3, r16
	rcall DEC_DIG
	mov r8, r16 


	clr r4
	ldi r16, 100
	mov r3, r16
	rcall DEC_DIG
	mov r7, r16 

	ldi r16, 10 
	mov r3, r16
	rcall DEC_DIG
	mov r6, r16 

	ldi r16, 0 
	add r16, R1 
	mov r5, r16
	ret 

DEC_DIG:
	ldi r16, 0 
DEC_DIG1:
	cp r1, r3
	cpc r2, r4
	brcc DEC_DIG2
	ret 
DEC_DIG2:
	sub r1, r3 
	sbc r2, r4 
	inc r16
	rjmp DEC_DIG1



PressedButtonB:
	sbrs r31, 0
	rcall DEC_d
	reti
DEC_d:
	ldi r31, 00000001
	dec r14 
	ret 

PressedButtonD:
	sbrs r30, 0
	rcall INC_d
	ret 
INC_d:
	ldi r30, 00000001
	;save_set r15,r14
	inc r14 
	ret

UnPressedButtonD:
	ldi r30, 0
	ret

UnPressedButtonB:
	ldi r31, 0
	ret

checkBothButton:
	sbic pinb, pinb2
	ret
	sbic pind, pind2
	ret
	rcall BothPressed
	ret

BothPressed:
	;rcall Set100
	save_set r15,r14
	ret

Set100:
	ldi r25, 0x64
	mov r14, r25 
	ret 


EEPROM_write:
cli
sbic EECR, EEWE
rjmp EEPROM_write ; Wait for completion of previous write
out EEARH, r18 ; Set up address (r18:r17) in address register
out EEARL, r17
out EEDR, r19 ; Write data (r16) to data register
sbi EECR, EEMWE ; Write logical one to EEMWE
sbi EECR, EEWE ; Start eeprom write by setting EEWE
sei
ret

EEPROM_read:
cli
sbic EECR,EEWE ; Wait for completion of previous write
rjmp EEPROM_read
out EEARH, r18 ; Set up address (r18:r17) in address register
out EEARL, r17
sbi EECR,EERE ; Start eeprom read by writing EERE
in r19,EEDR ; Read data from data register
sei
ret

setr14_0:
	ldi r17,0x01
	ldi r18,0x00
	ldi r19,0
	rcall EEPROM_write
	ret
setr15_0:
	ldi r17,0x02
	ldi r18,0x00
	ldi r19,0
	rcall EEPROM_write
	ret




delay_sec:
		ldi		R26,0x01
		mov		R12,R26

loop3:	ldi		R26,0xF0
		mov		R11,R26

loop2:	ldi		R26,0xFF
		mov		R10,R26

loop1:	dec		R10
		brne	loop1 ; REPEAT UNTIL R10=0
		dec		R11
		brne	loop2 ; REPEAT UNTIL  R11=0
		dec		R12
		brne	loop3 ; REPEAT UNTIL R12=0
		ret