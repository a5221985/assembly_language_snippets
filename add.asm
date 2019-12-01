global add             ; make function externally accessible to linker
add:                   ; function label
    push ebp           ; save base pointer
    mov ebp, esp       ; hold current stack top in base pointer
    mov eax, [ebp+8]   ; copy value of b
    add eax, [ebp+12]  ; a <- a + b
    mov esp, ebp       ; restore stack top from base pointer
    pop ebp            ; restore base pointer
    ret                ; return from function
