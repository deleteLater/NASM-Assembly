%include 'functions.asm'

SECTION .data
	msg1	db	'90 + 9 = ',0h
	msg2	db	'99 / 10 = ',0h
	msg3	db	'9 * 10 = ',0h
	msg4	db	'90 - 10 = ',0h
	msg5	db	'......',0h

SECTION .text
global _start

_start:
nextNumber:
	mov	eax,msg1
	call	strprint
	mov	eax,90
	mov	ebx,9
	add	eax,ebx
	call	iprintLF

	push	eax
	mov	eax,msg2
	call	strprint
	pop	eax
	mov	ebx,10
	div	ebx
	call	iprint	
	mov	eax,msg5
	call	strprint
	mov	eax,edx
	call	iprintLF

	push	eax
	mov	eax,msg3
	call	strprint
	pop	eax
	mov	ebx,10
	mul	ebx
	call	iprintLF

	push	eax
	mov	eax,msg4
	call	strprint
	pop	eax
	mov	ebx,10
	sub	eax,ebx
	call	iprint

	call	quit
