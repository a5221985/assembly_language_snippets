global add_x64         ; make function externally accessible to linker
add_x64:               ; function label
    push rbp           ; save base pointer
    mov rbp, rsp       ; hold current stack top in base pointer
    mov rax, [rbp+16]   ; copy value of b
    add rax, [rbp+24]  ; a <- a + b
    mov rsp, rbp       ; restore stack top from base pointer
    pop rbp            ; restore base pointer
    ret                ; return from function
