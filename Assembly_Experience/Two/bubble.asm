;Under Ubuntu 18.04 bionic beaver,64 bit
;Compile with 
;         nasm -f elf bubble.asm -o bubble.o
;Link with(64 bit System need elf_i386 option)
;         ld -m elf_i386 bubble.o -o bubble
;Run with
;         ./bubble

%include 'functions.asm'
SECTION .data
	array	dd	10,9,8
	size	equ	($-array)/4
	hint1	db	'Before sort: ',0h
	hint2	db	'After sort : ',0h

SECTION .text
global _start

_start:
	mov		eax,hint1		; arg for strprint
	call	strprint		; output hint1

	mov		eax,array		; arg for array_iprintLF
	mov		ecx,size		; arg for array_iprintLF
	call	array_iprintLF	; output array value before sort

	mov 	eax,hint2		; arg for strprint
	call	strprint		; output hint2

	mov		eax,array
	mov		ecx,size
	call	bubble			; bubble sort
	call	array_iprintLF	; output array value after sort

	call	quit			; exit program
