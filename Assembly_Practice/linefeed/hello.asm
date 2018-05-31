%include 'functions.asm'

SECTION .data
	msg_1	db	'Hello,Brave new wolrd',0h
	msg_2	db	'Try to believe!',0h

SECTION .text
global _start

_start:
	mov eax,msg_1
	call strprintLF
	
	mov eax,msg_2
	call strprintLF
	
	call quit	
