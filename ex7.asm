global _start
section .text
_start:
    sub esp, 4
    mov [esp], byte 'H'
    mov [esp+1], byte 'e'
    mov [esp+2], byte 'y'
    mov [esp+3], byte '!'
    mov eax, 4 ; sys_write
    mov ebx, 1 ; stdout
    mov ecx, esp ; pointer to bytes to write
    mov edx, 4 ; number of bytes to write
    int 0x80 ; interrupt
    mov eax, 1 ; sys_exit
    mov ebx, 0 ; exit status 0
    int 0x80 ; interrupt
