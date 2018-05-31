;helloworld world program(calculating string length)
;compile: nasm -f elf hello_len.asm -o hello_len.o
;link:    ld -m elf_i386 hello_len.o -o hello_len
;run :	  ./hello_len

SECTION .data
msg	db 'Hello,brave new world!Do not be afraid!',0Ah		;our string

SECTION .text
global _start

_start:
	mov ebx,msg				;move the address of our message string into ebx
	mov eax,ebx				;now both of eax,ebx point to our string

nextchar:
	cmp	byte[eax],0			;judge if our string is empty,Zero is an end of string delimiter
	jz 	finished			;if empty,jump to the point labeled 'finished'
	inc	eax				;increase the address in EAX by one byte
	jmp 	nextchar			;jump to the point labeled 'nextchar'

finished:
	sub eax,ebx				;in 'nextchar',we have made the eax points to the end of our string
						;while the abx still points to the start of our string
						;the result is the number of segments between them -- in this case the number of bytes
	mov edx,eax				;specify the length of string
	mov ecx,msg				;specify the start of string
	mov eax,0x04				;specify the sys_write
	mov ebx,1				;specify the file descriptor

	int 80h					;call sys_write
	
	mov eax,1				;specify the sys_exit
	mov ebx,0				;return 0 status on exit -- 'No errors'
	int 80h					;call sys_exit
