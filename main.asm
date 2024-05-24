%include 'functions.asm'

SECTION .data
msg1 db '12345', 0   ; message string asking user for input
msg2 db 'Hello, ', 0 ; message string to use after user has entered their name
 
SECTION .text
global  _start

_start:
 
    pop ecx
    pop ebx
    dec ecx
    mov ebx, 0
 
nextArg:
    cmp  ecx, 0
    jz   noMoreArgs
    pop  eax
    call atoi
    add  ebx, eax
    dec  ecx
    jmp  nextArg

 
noMoreArgs:
    mov  eax, ebx ; move our data result into eax for printing
    call iprintNL ; call our integer printing with linefeed function
    call exit     ; call our quit function
    
