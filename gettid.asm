global gettid
gettid:
    push ebp
    mov ebp, esp
    mov eax, 186 ; sys_gettid
    int 0x80     ; interrupt
    mov esp, ebp
    pop ebp
    ret
