global _start
section .text
_start:
    mov ecx, 99  ; set ecx to 101
    mov ebx, 42  ; exit status is 42
    mov eax, 1   ; sys_exit system call
    cmp ecx, 100 ; compare ecx to 100
    jl skip      ; jump to "skip" label
    mov ebx, 13  ; exit status is 13
skip:
    int 0x80