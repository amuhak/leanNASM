; Namespace
; Compile with: nasm -f elf namespace.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 namespace.o -o namespace
; Run with: ./namespace
 
%include        'functions.asm'
 
SECTION .data
f db 'Fizz', 0h ; a message string
b db 'Buzz', 0h ; a message string
t db 0          ; null terminator


SECTION .text
global  _start
 
_start:
    mov ecx, 0

nextNo:
    inc ecx
    mov esi, 0
    mov edi, 0

.FizzCheck:
    cmp  ecx, 10000
    je   .done
    mov  eax, ecx
    mov  ebx, 3
    mov  edx, 0
    div  ebx
    cmp  edx, 0
    jne  .BuzzCheck
    mov  eax, f
    call sprint
    mov  esi, 1

.BuzzCheck:
    mov  eax, ecx
    mov  ebx, 5
    mov  edx, 0
    div  ebx
    cmp  edx, 0
    jne  .printNo
    mov  eax, b
    call sprint
    mov  edi, 1

.printNo:
    cmp  esi, 0
    jne  .loop
    cmp  edi, 0
    jne  .loop
    mov  eax, ecx
    call iprint

.loop:
    mov  eax, t
    call sprintNL
    jmp  nextNo

.done:
    call exit

    