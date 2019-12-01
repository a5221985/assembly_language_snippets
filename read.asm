global read
read:
    push ebp          ; prolog
    mov ebp, esp      ;
    mov eax, 3        ; sys_read syscall no
    mov ebx, 0        ; stdin
    sub esp, 4        ; allocate space on stack
    mov ecx, esp      ; string pointer
    mov edx, 1        ; string size
    int 0x80          ; syscall interrupt
    movzx eax, byte [esp] ; place character in eax
    add esp, 4
    mov esp, ebp      ; epilog
    pop ebp           ;
    ret               ; return
