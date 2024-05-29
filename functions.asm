SECTION .data
test_str db 'test', 0 ; message string asking user for input

;------------------------------------------
; int slen(String message)
; String length calculation function
;------------------------------------------
slen:
    push ebx      ; save ebx to stack to prevent corruption
    mov  ebx, eax ; move string into ebx
    
.nextchar:
    cmp byte [eax], 0 ; is edx end of string
    jz  .done         ; if it is jump to done
    inc eax           ; else increment edx
    jmp .nextchar     ; loop back

.done:
    sub eax, ebx ; subtract to get length
    pop ebx      ; restore ebx
    ret

;-------------------------------------------
; void sprint(String message)
; Print
;-------------------------------------------
sprint:
    push edx
    push ecx
    push ebx
    push eax
    call slen ; call nextchar, it will return the len of msg in eax

    mov  edx, eax ; move eax (the len of msg) into edx
    pop  eax      ; get the string again
    mov  ecx, eax ; move msg into ecx
    push eax      ; re-save eax
    mov  ebx, 1   ; print to stdout 
    mov  eax, 4   ; tell kernel to print
    int  80h      ; tell kernel to run

    pop eax
    pop ebx
    pop ecx
    pop edx
    ret
;-------------------------------------------
; void sprintNL(String message)
; Print with new line at the end
;-------------------------------------------
sprintNL:
    call sprint

    push eax      ; save eax
    mov  eax, 0xA ; move new line into eax

    push eax ; push 0xA on to stack so we can get a stack pointer

    mov  eax, esp ; move the stack pointer to eax
    call sprint   ; print eax
    pop  eax
    pop  eax
    ret 
;-------------------------------------------
; void iprint(int number)
; Print number
;-------------------------------------------
iprint:
    push eax     ; the original number
    push ebx     ; for the divisor
    push ecx     ; counter
    push edx     ; div instruction uses this for the remainder
    mov  ebx, 10 ; divide by 10
    mov  ecx, 0  ; start counter at 0

.iprint_loop:
    inc  ecx          ; add to how long the number is
    mov  edx, 0       ; empty edx
    idiv ebx          ; divide eax by 10. The result is in eax and the remainder is in edx.
    add  edx, 48      ; add 48 to turn it into ASCII  
    push edx          ; push the remainder (the last digit of the number) to the stack for later use
    cmp  eax, 0       ; eax == 0 ?
    jne  .iprint_loop ; if not loop back

.iprint_print:
    dec  ecx           ; decrement
    mov  eax, esp      ; the digit in the most significant place is on top of the stack, so get its pointer
    call sprint        ; print it
    pop  eax           ; remove it from the stack
    cmp  ecx, 0        ; is the counter done?
    jne  .iprint_print ; if it is, then we are done, else loop back

.iprint_done:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
;-------------------------------------------
; void iprintNL(int number)
; Print number with a new line at the end
;-------------------------------------------
iprintNL:
    call iprint ; print the number

    push eax      ; save eax
    mov  eax, 10  ; move new line into eax
    push eax      ; push 0xA on to stack so we can get a stack pointer
    mov  eax, esp ; move the stack pointer to eax
    call sprint   ; print eax
    pop  eax
    pop  eax
    ret

;-------------------------------------------
; int atoi(String number)
; returns the integer value of a string
;-------------------------------------------
atoi:
    push ebx      ; used to do a temp calc
    push ecx      ; store 48
    push edx      ; the overflow from multiplication is dumped here
    push esi      ; used to store the location of the string
    push edi      ; used to store 10
    mov  ecx, 48  ; store 48
    mov  edi, 10  ; store 10
    mov  esi, eax ; put the string into esi
    mov  eax, 0   ; clear eax to allow it to store the answer
    mov  ebx, 0   ; clear ebx



.atoi_loop:
    mov bl,         [esi] ; move the current ASCII char into the lower 8 bits of ebx (32 bit)
    sub ebx,        ecx   ; turn ASCII char into a number (subtract 48)
    mul edi               ; multiply eax by 10 to allow adding the next number in ebx
    add eax,        ebx   ; add the least significant position
    inc esi               ; increment esi to go to the next number
    cmp byte [esi], 0     ; have we reached the end of the string?
    jne .atoi_loop        ; if not loop 


.atoi_done:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

;------------------------------------------
; void quit(int code)
;------------------------------------------
quit:
    mov ebx, eax ; move code into ebx
    mov eax, 1   ; sys call number for exit
    int 0x80     ; call kernel
    ret

;------------------------------------------
; void exit()
; Exit code 0
;------------------------------------------
exit:
    mov  eax, 0
    call quit
;------------------------------------------
; void test()
; Prints "test" + new line to stdout
;------------------------------------------
test:
    push eax
    mov  eax, test_str
    call sprintNL
    pop  eax
    ret