global _start
section .data
    txt db "", 0x0a, 0x00
    len equ $ - txt + 1
section .text
_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, txt
    mov edx, len
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, txt
    mov edx, len
    int 0x80
    mov eax, 1
    mov ebx, 0
    int 0x80
