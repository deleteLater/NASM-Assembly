;Under Ubuntu 18.04 bionic beaver,64 bit
;Compile with 
;         nasm -f elf strcmp.asm -o strcmp.o
;Link with(64 bit System need elf_i386 option)
;         ld -m elf_i386 strcmp.o -o strcmp
;Run with
;         ./strcmp

%include 'subrountines.asm'				;prepare some useful functions

SECTION .data
	hintOne		db 'Please input src:',0h	;input hint
	hintTwo 	db 'PLease input des:',0h	;input hint
	match_msg	db 'Match',0h			;match msg
 	not_match_msg	db 'Not Match',0h		;not_match msg

SECTION .bss
	src 		resb	255			;resource string
	des 		resb	255			;destination string

SECTION .text
global _start

_start:
	mov	eax,hintOne				;get src from input
	call	strprt						
	mov	eax,src	
	call	input					

	mov	eax,hintTwo				;get des from input
	call	strprt
	mov	eax,des
	call	input
	
	mov	eax,src
	call	strlen
	sub	eax,1					;src's length,-1 because it include '\n'(in linux,in windows is '\r\n')
	mov	ebx,eax					;store it in ebx
	
	mov	eax,des
	call	strlen
	sub	eax,1					;des's length
	
	cmp	eax,ebx					;compare length
	jne	NotMatch
	
	mov	esi,src					;compare content
	mov	edi,des		
	mov	ecx,ebx					;set compare length
	cld						;compare from start				
	repe	cmpsb
	jz	Match
	jne	NotMatch
Match:
	mov	eax,match_msg
	jmp	EndMatch
NotMatch:
	mov	eax,not_match_msg
	jmp	EndMatch
EndMatch:
	;
	call	strprtln				;print result
	call	exit					;exit program
