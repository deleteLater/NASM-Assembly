;Hello World Program
;Compiled with: nasm -f elf subroutine.asm
;Link with (64 bit system require elf_i386 option): ld -m elf_i386 subroutine.asm -o subrountine
;Run with : ./subrotine

SECTION .data
	msg	db	'Hello,brave new world!', 0Ah

SECTION .text
global _start

_start:
	mov eax,msg	;move the address of msg string into EAX
	call strlen	;call the function strlen

	mov edx,eax	;our function leaves the result in EAX
	mov ecx,msg	;const char __user*buf
	mov ebx,1	;fd = 1 stands for the Standard Output
	mov eax,0x04	;sys_write call number
	int 80h;
	
	mov ebx,0
	mov eax,1
	int 80h
;function declaration
strlen:
	push ebx	;push the value in EBX onto the stack to preserve it while we use EBX in this function
	mov  ebx,eax	;Both of them points to the same segment in memory

nextchar:
	cmp byte[eax],0
	jz finished
	inc eax
	jmp nextchar

finished:
	sub eax,ebx
	pop ebx		;pop the value on the stacktop back into EBX
	ret		;return to where the function is called
