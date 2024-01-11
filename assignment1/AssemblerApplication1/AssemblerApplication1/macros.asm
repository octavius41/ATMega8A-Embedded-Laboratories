/*
 * AsmFile1.asm
 *
 *  Created: 15/11/2023 19:36:48
 *   Author: Grachus
 */ 
 .macro stackreg

	;stack pointer setup
	ldi r16, HIGH(RAMEND)
    out SPH, r16
    ldi r16, LOW(RAMEND)
    out SPL, r16	

.endmacro

.macro config

ldi	R16, 0x03 
out DDRB, R16 

ldi	R16, 0x07 ; 
out DDRC, R16 ;	led segment related bits are set as output

ldi R16, 0xFF 
out DDRD, R16 

;since we have no input need all bits may set up as output

.endmacro


 .macro config_t0
	ldi R16, (1<<CS02) 
	OUT TCCR0, R16
	ldi R16, TIMSK | (1<<TOIE0)
	OUT TIMSK, R16
.endmacro

 .macro config_t2
	ldi R16, (1<<CS21) | (1<<CS20)
	OUT TCCR2, R16 
	ldi R16, TIMSK|(1<<TOIE2)
	out TIMSK, R16 
.endmacro

.macro config_io
	ldi r16, 0b00000001		;PB0 is set as output
	out ddrb, r16

	ldi r16, 0b00000111		; PC0 - PC1 - PC2 set as out
	out ddrc, r16

	sbi portd, 2			;pb2 pull-up active
	ldi r16, 0b11111011		
	out ddrd, r16			;all except the 2nd pin of portd set as output

.endmacro

.macro config_adc
	ldi r16,0x00
	out	ADMUX,r16		;RESET ADMUX
	sbi	ADMUX,REFS0		;REFS0 AND REFS1 SET FOR VREF SELECTION
	sbi	ADMUX,REFS1		;VREF=INTERNAL 2.56V
	sbi	ADMUX,MUX0		;MUX0 SET AND MUX1 SET 
	sbi	ADMUX,MUX1		;ACTIVE CHANNEL IS ADC3 

	ldi r16,0x00	
	out	ADCSRA,r16		;RESET ADCSRA	
	sbi	ADCSRA,ADPS0	;PRESCALER ADJUSTMENT
	sbi	ADCSRA,ADPS1	;ADPS0, ADPS1, ADPS2 ARE SET
	sbi	ADCSRA,ADPS2	;PRESCLAER = CLK/128
	sbi ADCSRA,ADEN		;ADC ENABLED
	sbi	ADCSRA,ADIE		;ADC INTERRUPT ENABLED

.endmacro


.macro macro_display
mov r2, @1
mov r1,@0
rcall conv_hextodec
rcall display
.endmacro


.macro _read_set
ldi r17,0x01
ldi r18,0x00
rcall EEPROM_read
mov r14,r19

ldi r17,0x02
ldi r18,0x00
rcall EEPROM_read
mov r15,r19
.endmacro

.macro _check_eeprom
	_read_set
	ldi r16,0xFF
	cpse r14,r16
	rjmp END
	rcall setr14_0
	cpse r15,r16
	rjmp END
	rcall setr15_0
	_read_set
END:
nop 
.endmacro


.macro save_set
	LDI R17,0x01
	LDI R18,0x00
	MOV R19, @1;r14
	RCALL EEPROM_write
WAIT_LOW:	
	SBIC  EECR, EEWE	
	RJMP  WAIT_LOW	; Wait for completion of previous write

	LDI R17,0x02
	LDI R18,0x00
	MOV R19, @0;r15
	RCALL EEPROM_write
WAIT_HIGH:	
	SBIC  EECR, EEWE	
	RJMP  WAIT_HIGH	; Wait for completion of previous�write
.endmacro

.macro _check_eeprom1
	_read_set
.endmacro


/*.macro save_set
ldi r17,0x01
ldi r18,0x00
ldi r19,100
rcall EEPROM_write

ldi r17,0x02
ldi r18,0x00
ldi r19,0
rcall EEPROM_write
.endmacro*/

