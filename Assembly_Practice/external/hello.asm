; Hello World Program (EXternal file include)
; Compile With: nasm -f elf hello.asm -o hello.o
; Link with: ld -m elf_i386 hello.o -o hello
; Run: ./hello

%include 'functions.asm'	;include external file

SECTION .data
	msg_1 db	'Hello,brave new world!',0AH,0h
	msg_2 db 	'Try to believe!',0AH,0h

SECTION .text
global _start

_start:
	mov eax,msg_1
	call strprint
	
	mov eax,msg_2
	call strprint

	call quit

