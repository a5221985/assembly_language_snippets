global _start
section .text
_start:
    call func
    mov eax, 1
    mov ebx, 0
    int 0x80
func:
    push ebp
    mov ebp, esp
    sub esp, 2
    mov [esp], byte 'H'
    mov [esp+1], byte 'i'
    mov eax, 4    ; sys_write
    mov ebx, 1     ; stdout
    mov ecx, esp  ; bytes to write
    mov edx, 2    ; number of bytes to write
    int 0x80      ; interrupt
    mov esp, ebp  ; restores top pointer
    pop ebp
    ret
