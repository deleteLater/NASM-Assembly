; ----------------------------------------
; int strlen(string)
; calculate string length
; another simple way when declare
; str		db	'some thing',0h
; strlen	equ	$-str

; result in eax
strlen:
    push	ebx             ; preserve ebx
    mov 	ebx,eax         ; both eax,ebx points to the start of string

.nextchar:
    cmp 	byte[eax],0     ; if string end
    jz 		.finished        ; finish
    inc 	eax             ; move forward
    jmp 	.nextchar       ; loop

.finished:
    sub 	eax,ebx         ; end - start
    pop 	ebx             ; restore ebx
ret

; ----------------------------------------
; void strprint(string)
; print string to screen

strprint:
    push 	edx            	; preserve edx
    push 	ecx            	; preserve ecx
    push 	ebx            	; preserve ebx
    push 	eax            	; preserve eax
    call 	strlen         	; get string length
                         	; sys_write(eax,ebx,ecx,edx)
    mov 	edx,eax         ; edx : size_t count
    pop 	eax             ; restore eax
    mov 	ecx,eax         ; ecx : const char __user *buf
    mov 	ebx,1           ; ebx : unsigned int fd(1 stands for STDOUT)
    mov 	eax,0x04        ; eax : opcode 4 stands for sys_write
    int 	80h             ; interrupt for system call

    pop ebx              	; restore ebx
    pop ecx              	; restore ecx
    pop edx              	; restore edx
ret

; ----------------------------------------
; void strprintLF(string)
; print string with linefeed

strprintLF:
    call 	strprint       	; print string

    push 	eax            	; preserve eax
    mov 	eax,0Ah         ; move 0Ah into eax - 0Ah is the ascill character for a linefeed
    push	 eax            ; push the linefeed onto the stack so we can get the address
    mov 	eax,esp         ; push the address of current stack pointer into eax for strprint
    call 	strprint       	; print line feed
    pop 	eax             ; remove linefeed character from stack
    pop 	eax             ; restore the original value of eax before our function was called
ret

; ----------------------------------------
; void iprint(interger)
; print interger

iprint:
    push	eax             ; preserve eax
    push	ecx             ; preserve ecx
    push	edx             ; preserve edx
    push	esi             ; preserve esi
    mov		ecx,0           ; init counter to be zero

.divideLoop:
    inc		ecx             ; 
    mov		edx,0           ; 
    mov		esi,10			; 
    idiv	esi				; 
    add		edx,48			; digit + 48 = ascii_digit
    push	edx				; 
    cmp		eax,0			; 
    jnz		.divideLoop		;

.printLoop:
    dec		ecx				;
    mov		eax,esp			;
    call	strprint		;
    pop		eax				;
    cmp		ecx,0			;
    jnz		.printLoop		;

.end:
    pop		esi				; restore esi
    pop		edx				; restore edx
    pop		ecx				; restore ecx
    pop		eax				; restore eax
ret

; ----------------------------------------
; void iprintLF(Interger number)
; Interger printing function with linefeed (itoa)
iprintLF:
    call	iprint
    push	eax				; preserve eax
    mov		eax,0Ah			;
    push	eax				;
    mov		eax,esp			;
    call	strprint		;
    pop		eax				; pop 0Ah
    pop		eax				; preserve eax
ret

; ----------------------------------------
; atoi(string number)
; Ascii to interget
atoi:
    push	ebx				; preserve ebx
    push	ecx				; preserve ecx
    push	edx				; preserve edx
    push	esi				; preserve esi
    mov		esi,eax			;
    mov		eax,0			;
    mov		ecx,0			;

.multiplyLoop:
							; ascii:one byte ,use bl store
    xor		ebx,ebx			; set ebx=0
    mov		bl,[esi+ecx]	; 
    cmp		bl,48			; '0' = 48
    jl		.finished		;
    cmp		bl,57			; '9' = 57
    jg		.finished		;
    cmp		bl,10			; '\n' = 10(linux)
    jz		.finished		;
    cmp		bl,0			; 0 stands for end of string
    jz		.finished		;

    sub		bl,48			; ascii_number - 48 = number
    add		eax,ebx			;
    mov		ebx,10			;
    mul		ebx				; 
    inc		ecx				;
    jmp		.multiplyLoop	;

.finished:
    mov		ebx,10			;
    div		ebx				; 
    pop		esi				; restore esi
    pop		edx				; restore edx
    pop		ecx				; restore ecx
    pop		ebx				; restore ebx
ret

; ----------------------------------------
; void array_iprint(array,size)
; print a interger array
printSpace:
	push	eax				
	mov		eax,20h				;20h means ' '
	push	eax
	mov		eax,esp
	call	strprint
	pop		eax
	pop		eax
ret

array_iprint:
	push	edx				; preserve edx
    push	eax				; preserve eax
    push	ecx				; preserve ecx
    push	esi				; preserve esi

	mov		esi,eax			; array
	mov		edx,ecx			; array size
	mov		ecx,0			; index
.printLoop:
	cmp		ecx,edx			; 
	jz		.end			; 
	mov		eax,[esi+ecx * 4]
	call	iprint			;
	call	printSpace		;
	inc		ecx				; 
	jmp		.printLoop		; 

.end:
	pop		esi				; restore esi
	pop		ecx				; restore ecx
	pop		eax 			; restore eax
	pop		edx				; restore edx
ret

;-----------------------------------------
; void array_printLF()
; print a interger array with line feed
array_iprintLF:
	call	array_iprint

	push	eax				;preserve eax
	mov 	eax,0Ah			;print linefeed
	push	eax
	mov		eax,esp
	call	strprint
	pop		eax				;pop 0Ah
	pop		eax				;restore eax
ret

;-----------------------------------------
; void bubble()
; bubble sort
;void bubbleSort(int arr[], int n)
;{
;   int i, j;
;   for (i = 0; i < n-1; i++)      
;       // Last i elements are already in place
;       for (j = 0; j < n-i-1; j++) 
;           if (arr[j] > arr[j+1])
;              swap(&arr[j], &arr[j+1]);
;}
bubble:
    push    eax
    push    ebx
    push    ecx
    push    esi

    mov     esi,eax         ; esi : array
    xor     eax,eax         ; eax : i , j
                            ; ebx : tmp value
    dec     ecx             ; ecx : n-1

outLoop:
    cmp     eax,ecx         ; eax stands for i
    jz      .end
    push    eax             ; preserve eax for outLoop
    push    ecx             ; preserve ecx for outLoop
    sub     ecx,eax         ; now ecx = n-1-i,stands for inner_border
    mov     eax,-1          ; now eax =     -1,stands for j
.innerLoop:
    inc     eax             ; eax = 0
    cmp     eax,ecx         ;
    jnb     .next_Loop      ; j >= n-i-1 ,jump to nextLoop
    mov     ebx,[esi+eax*4] ; ebx = array[j]
    cmp     ebx,[esi+eax*4+4];array[j] cmp array[j+1]
    jle     .innerLoop
    xchg    ebx,[esi+eax*4+4];array[j+1] = array[j],ebx = array[j+1]
    xchg    ebx,[esi+eax*4]  ;array[j] = array[j+1],ebx = array[j]
    jmp     .innerLoop

.next_Loop:
    pop     ecx             ; restore ecx(out_border) for outLoop
    pop     eax             ; restore eax(i) for outLoop
    inc     eax             ; i++
    jmp     outLoop         ; outLoop

.end:
    pop     esi
    pop     ecx
    pop     ebx
    pop     eax
ret


; ----------------------------------------
; void exit()
; Exit program and restore resources
quit:
    mov		ebx,0
    mov 	eax,1
    int 	80h
ret
