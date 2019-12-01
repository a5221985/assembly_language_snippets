global mul
mul:
    push ebp
    mov ebp, esp
    mov eax, [esp+8]
    mul dword [esp+12]
    mov esp, ebp
    pop ebp
    ret
