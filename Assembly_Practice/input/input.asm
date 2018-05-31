%include 'functions.asm'

SECTION .data
	msg1	db	'Please input your name: ',0h
	msg2	db	'Hello, ',0h

SECTION .bss
	buf	resb	255
	
SECTION .text
global _start

_start:
	mov	eax,msg1
	call	strprint

	mov	edx,255
	mov	ecx,buf
	mov	ebx,0
	mov	eax,3
	int	80h		;invoke sys_read

	mov	eax,msg2
	call	strprint
	
	mov	eax,buf
	call	strprint

	call	quit
