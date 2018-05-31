;Compile with:					    nasm -f elf helloworld.asm
;Link with(64 bit systems require elf_i386 option): ld -m elf_i386 helloworld.o -o helloworld
;Run with: 					    ./helloworld
SECTION .data
	msg db 'Hello,World!',0Ah

SECTION .text
global _start

;sys_write function : eax: 0x04 ebx:unsigned int fd ecx: const char __user*buf  edx: size_t count
_start:
	mov edx,13	;number of bytes to write - one for each letter plus a line feed(0Ah)
	mov ecx,msg	;move the memory address of our strig into ecx
	mov ebx,1	;write to the STDOUT file
	mov eax,4	;invoke SYS_WRITE(kernel opcode 4)
	int 80h
	
	mov ebx,0	;return 0 status on exit - 'No errors'
	mov eax,1	;invoke SYS_EXIT(kernel opcode 1)
	int 80h
