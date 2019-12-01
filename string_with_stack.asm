global _start
section .data
    text db "abcd"
    len equ $ - text
section .text
_start:
    push dword 'A'
    push dword 'b'
    push dword 'c'
    pop eax
    mov eax, 4 ; sys_write
    mov ebx, 1 ; stdout
    mov ecx, eax ; string to write
    mov edx, 1 ; length
    int 0x80
    mov eax, 1 ; sys_exit
    mov ebx, 0 ; exit status 0
    int 0x80
