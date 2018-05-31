;----------------------------------------
;int strlen(string msg)
;String length calculation function
strlen:
	push ebx
	mov ebx,eax

nextchar:
	cmp byte[eax],0
	jz finished
	inc eax
	jmp nextchar

finished:
	sub eax,ebx
	pop ebx
ret

;----------------------------------------
;void print(string msg)
;String printing function
strprint:
	push edx
	push ecx
	push ebx
	push eax
	call strlen
	
	mov edx,eax
	pop eax
	
	mov ecx,eax
	mov ebx,1
	mov eax,0x04
	int 80h
	
	pop ebx
	pop ecx
	pop edx
ret

;----------------------------------------
;void strprintLF(string msg)
;print msg with linefeed
strprintLF:
	call strprint

	push eax	;push eax onto stack to preserve it while we use the eax in this function
	mov eax,0Ah	;move 0Ah into eax - 0Ah is the ascill character for a linefeed
	push eax	;push the linefeed onto the stack so we can get the address
	mov eax,esp	;push the address of current stack pointer into eax for strprint
	call strprint	;print line feed
	pop eax		;remove linefeed character from stack
	pop eax		;restore the original value of eax before our function was called
ret	

;----------------------------------------
;void exit()
;Exit program and restore resources
quit:
	mov ebx,0
	mov eax,1
	int 80h
ret
