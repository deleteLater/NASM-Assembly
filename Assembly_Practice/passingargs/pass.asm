%include 'functions.asm'

SECTION .text
global _start

_start:
	pop	ecx		;first value on the stack is the number of args
	

nextArg:
	cmp	ecx,0h		;check to see if have no arg left
	jz	noMoreArgs
	pop	eax
	call	strprintLF	;print current arg
	dec	ecx
	jmp	nextArg

noMoreArgs:
	call quit
