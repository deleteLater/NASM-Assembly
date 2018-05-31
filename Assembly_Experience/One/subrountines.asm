;Under Ubuntu 18.04 bionic beaver
;--------------------------------
; int strlen(string msg)
; calculate string length

strlen:
	push	ebx		;we will use ebx,preserve it first
	mov	ebx,eax		;both point to the same segement in memory
nextchar:
	cmp	byte[eax],0	
	jz 	finished	;0 means string's end
	inc	eax
	jmp	nextchar
finished:
	sub	eax, ebx	;string's length = ebx - eax
	pop	ebx		;restore ebx
ret


;--------------------------------
; void print(string msg)
; print msg on the stdout(1)
; linux sys_write
;               (see https://syscalls.kernelgrok.com/)
;		eax: 0x04
;		ebx: unsigned int fd
;		ecx: const char __user *buf 
;		edx: size_t count
strprt:
	push	edx
	push	ecx
	push	ebx
	push	eax		;eax stores string's address
	call	strlen		;see strlen,now eax stores length of string
	
	mov	edx,eax		;edx stores length
	pop	eax		;restore eax

	mov	ecx,eax		;ecx points to string
	mov	ebx,1		;1 stands for stdout
	mov	eax,0x04	;sys_write opcode
	int	80h		;linux system_call interrupt id
	
	pop	ebx
	pop	ecx
	pop	edx
ret

;--------------------------------
; void println(string msg)
; print msg with line feed(0Ah)
strprtln:
	call	strprt		;print msg
	
	push	eax		;preserve eax
	mov	eax,0Ah		;0Ah = '\n'
	push	eax		;push 0Ah so we can get it's address
	mov	eax,esp		;for print
	call	strprt
	pop	eax		;remove '\0' from stack
	pop	eax		;restore eax
ret

;-------------------------------
; void input()
; get input form user
; sys_read(eax:0x03,ebx:unsigned int fd,ecx:char __user *buf,edx:size_t count)
input:
	push	eax
	push	ebx
	push	edx
	push	ecx
	
	mov	ecx,eax
	mov	edx,255		;number of bytes to read
	mov	ebx,0		;write to the STDIN file
	mov	eax,3		;sys_read opcode = 3
	int	80h			
	
	pop	ecx
	pop	edx
	pop	ebx
	pop	eax
ret


;--------------------------------
; void exit()
; exit program and restore resources
; sys_exit(eax:0x01 ebx:int error code)
exit:
	mov	ebx,0
	mov	eax,0x01
	int	80h	
ret
