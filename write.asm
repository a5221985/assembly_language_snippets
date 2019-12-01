global write
write:
    push ebp           ; preserve ebp
    mov ebp, esp       ; preserve current stack top
    mov eax, 4         ; sys_write system call number
    mov ebx, 1         ; stdout
    mov ecx, [esp+12]  ; string pointer
    mov edx, [esp+8]   ; string length
    int 0x80           ; interrupt
    mov esp, ebp       ; restore stack top
    pop ebp            ; restore ebp
    ret
