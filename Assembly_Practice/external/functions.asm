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
;void exit()
;Exit program and restore resources
quit:
	mov ebx,0
	mov eax,1
	int 80h
ret
