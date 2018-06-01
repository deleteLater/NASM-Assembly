;Under Ubuntu 18.04 bionic beaver,64 bit
;Compile with 
;         nasm -f elf binsearch.asm -o binsearch.o
;Link with(64 bit System need elf_i386 option)
;         ld -m elf_i386 binsearch.o -o binsearch
;Run with
;         ./binsearch

%include 'functions.asm'

SECTION .data
    array   dd  12,23,34,45,56,67
    r       dd  ($-array)/4-1
    l       dd  0
    x       dd  34
    hint    db  'search success,position is:',0h

SECTION .text
global _start

_start:
    mov     eax,[l]
    cmp     eax,[r]
    jg      .end

    mov     esi,array
    mov     eax,[r]           ;calculate mid
    add     eax,[l]
    shr     eax,1
    mov     edx,[esi+eax*4]     ;edx store array[mid]
    cmp     edx,[x]
    jz      .result
    jg      .leftsearch
    jb      .rightsearch

.leftsearch:
    dec     eax
    mov     [r], eax
    jmp     _start

.rightsearch:
    inc     eax
    mov     [l], eax
    jmp     _start

.result:
    push    eax
    mov     eax,hint
    call    strprint
    pop     eax
    call    iprintLF
.end:    
    call    quit