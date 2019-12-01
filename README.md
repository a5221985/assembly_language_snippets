# assembly_language_snippets
## Intro to x86 Assembly Language (Part 1) ##
1. Installation:

		sudo apt-get install nasm
		
	1. Syntax can differ between assemblers (even for same arch)
2. `ex1.asm`

		global _start		; entry point for program (processor executes from here), global - keyword used to make an id accessible to linker
		_start: 		; label (names locations in code)
			mov eax, 1
			mov ebx, 42
			int 0x80	; processor transfers control to interrupt handler specified by value 0x80 - 80 is for system call, 1 : exit call, ebx -> exit status

3. assembling:

		nasm -f elf32 ex1.asm -o ex1.o
		
	1. `elf32` 32 bit elf object file is loaded
		1. executable and linking format
			1. Executable format used by linux
4. building executable:

		ld -m elf_i386 ex1.o -o ex1
		
	1. `elf_i386` - x86 elf program
5. Running:

		./ex1
		echo $?
		
6. Subtracting

		...
		sub ebx, 29
		int 0x80
		
	1. comments: `; comment`
7. Example:

		mov ebx, 123	; ebx = 123
		mov eax, ebx	; eax = ebx
		add ebx, ecx	; ebx += ecx
		sub ebx, edx	; ebx -= edx
		mul ebx		; eax *= ebx
		div edx		; eax /= edx
		
8. Inline data

		global _start
		section .data
			msg db "Hello, world!", 0x0a	; 0x0a - for newline character
			len equ $ - msg			; $ location after string, msg start of string
			
		section .text
		_start:
			mov eax, 4			; sys_write system call
			mov ebx, 1			; stdout file descriptor
			mov ecx, msg			; bytes to write - string pointer
			mov edx, len			; number of bytes to write
			int 0x80			; perform system call - interrupt
			mov eax, 1			; sys_exit system call
			mov ebx, 0			; exit status is 0
			int 0x80
			
## Program control flow ##
1. Control flow needs to be built using jump instructions
2. `EIP` - instruction pointer
	1. Holds location of machine code the processor is executing
	2. Instruction pointer cannot be changed explicitly (using add ...)
		1. `EIP` can be changed using jump operations
3. Example:

		global _start
		
		section .text
		_start:
			mov ebx, 42	; exit status is 42
			mov eax, 1	; sys_exit system call
			jmp skip	; jump to "skip" label
			mov ebx, 13	; exit status is 13
		skip:			; label
			int 0x80
			
4. Example:

		global _start
		section .text
		_start:
			mov ecx, 99	; set ecx to 99
			mov ebx, 42	; exit status is 42
			mov eax, 1	; sys_exit system call
			cmp ecx, 100	; compare ecx to 100
			jl skip		; jump to "skip" label
			mov ebx, 13	; exit status is 13
		skip:
			int 0x80
			
	1. `cmp` sets flags in background
5. Conditional jumps:

		je A, B ; Jump if Equal
		jne A, B ; Jump if Not Equal
		jg A, B ; Jump if Greater
		jge A, B ; Jump if Greater or Equal
		jl A, B ; Jump if Less
		jle A, B ; Jump if Less or Equal
		
6. Building loop: 2 ^ x (don't use exit to return result but return 0)

		global _start
		section .text
		_start:
			mov ebx, 1	; start ebx at 1
			mov ecx, 4	; number of iterations
		label:
			add ebx, ebx	; ebx += ebx
			dec ecx		; ecx -= 1 - more efficient
			cmp ecx, 0	; compare ecx with 0
			jg label	; jump to label if greater
			mov eax, 1	; sys_exit system call
			int 0x80
			
## Memory Access ##
1. Example:

		global _start
		section .data
			add db "yellow" ; memory contains the word "yellow"
		section .text
		_start:
			mov eax, 4	; sys_write system call
			mov ebx, 1	; stdout file descriptor
			mov ecx, addr	; bytes to write
			mov edx, 6	; number of bytes to write
			mov eax, 1	; sys_exit system call
			mov ebx, 0	; exit status is 0
			int 0x80	; interrupt
			
2. How to change content?

		mov [addr], byte 'H'	; moving data into the address, byte 'H' (byte representation of 'H' - because mov can be used for larger size data as well)
		mov [addr+5], byte '!'	; offset of 5 bytes
		
3. Other data types

		section .data
			; db is 1 byte
			name1 db "string"
			name2 db 0xff		; literals can also be stored
			name3 db 100
			; dw is 2 bytes
			name4 dw 0x1234
			name5 dw 1000
			; dd is 4 bytes
			name6 dd 0x12345678
			name7 dd 100000
			
4. Stack:
	1. LIFO data structure
		1. It is an array
		2. Stack pointer (register)
		3. Random access also exists (we can read and write to arbitrary location)
	2. Example: `ESP` - stack pointer that holds the current location of the top of the stack
		1. Top starts at highest address and gets decreased
		2. pushing:
			1. ESP is decreased by 4 (it pushes 4 byte integers)
			2. Value is stored in the memory

					push 1234
					push 8765
					push 246
					sub exp, 4
					mov [esp], dword 357	; moving 4 bytes
					pop eax			; only increases ESP and does not remove value
					mov eax, dword [esp]
					add esp, 4		; same as pop
					
	3. Stack example:
	
			global _start
			_start:
				sub esp, 4		; allocate 4 bytes
				mov [esp], byte 'H'
				mov [esp+1], byte 'e'
				mov [esp+2], byte 'y'
				mov [esp+3], byte '!'
				mov eax, 4		; sys_write
				mov ebx, 1		; stdout
				mov ecx, esp		; pointer to bytes to write
				mov edx, 4		; number of bytes to write
				int 0x80
				
## Functions ##
1. A chunk of code that we can jump to and perform a few operations and get back
	1. Re-usable
	2. We can call c functions from assembly
2. `call`
	1. Pushes EIP to stack (location of next instruction)
	2. Performs a jump (to location of function)
		1. Return location doesn't have to be explicitly stored (automatically comes back on return)
3. Example:

		global _start
		_start:
			call func
			mov eax, 1
			int 0x80
		func:
			mov ebx, 42
			pop eax ; returns address of mov eax, 1 ; this and next can be replaced by `ret`
			jmp eax
			ret
			
4. Preserving stack status - using base pointer

		global _start
		_start:
			call func
			mov eax, 1
			mov ebx, 0
			int 0x80
		func:
			mov ebp, esp		; stores top pointer first
			sub esp, 2
			mov [esp], byte 'H'
			mov [esp+1], byte 'i'
			mov eax, 4		; sys_write system call
			mov ebx, 1		; stdout file descriptor
			mov ecx, esp		; bytes to write
			mov edx, 2		; number of bytes to write
			int 0x80		; interrupt
			mov esp, ebp		; restores top pointer
			ret
			
5. Nested function calls: push `ebp` and pop `ebp`

		push ebp
		mov ebp, esp
		sub esp, 2
		...
		mov esp, ebp
		pop ebp
		
## Pass parameters to Functions and get result ##
1. Passing an argument

		_start:
			push 21			; argument
			call times2
			mov ebx, eax		; return value is stored in eax but moving to ebx
			mov eax, 1
			int 0x80
		times2:
			push ebp
			mov ebp, esp		; preserves current top of stack
			mov eax, [ebp+8]	; argument, next argument is 4 bytes after
			add eax, eax
			mov esp, ebp		; restore stack pointer
			pop ebp
			ret

2. Calling a c function inside assembly

		global main					; must be provided and c will add _start for us
		extern printf
		section .data
			msg db "Testing %i...", 0x0a, 0x00	; 0x0a - 10 - \n, 0x00 - tells end of string (null terminator)
		main:
			push ebp				; prolog
			mov ebp, esp
			push 123				; push in reverse order
			push msg
			call printf
			mov eax, 0				; exit status
			mov esp, ebp				; epilog
			pop ebp
			ret
			
		1. Assembling and linking
		
				nasm -f elf32 ex10.asm ex10.o
				sudo apt-get install gcc-multilib -y # one-time activity - pre-requisite for integrating asm with c
				gcc -m32 ex10.o -o ex10 # 32 bit assembly
				./ex10
				
3. We need to pop items from the stack when we return from a function

## Calling Assembly from C ##
1. Assembly program

		global add42			; linker gets access to this label
		add42:
			push ebp
			mov ebp, esp
			mov eax, [ebp+8]	; 4 bytes for ebp, 4 bytes for return address
			add eax, 42
			mov esp, ebp
			pop ebp
			ret
			
	1. Assembling
	
			nams -f elf32 add42.asm -o add42.o
			
	2. Compiling C function - needs to know args and types - done using header file
		1. add42.h
		
				int add42(int x);
				
	3. C - code
	
			#include <stdio.h>
			#include "add42.h"
			
			int main()
			{
				int result;
				result = add42(30);
				printf("Result: %i\n", result);
				return 0;
			}
			
		1. compiling
		
				gcc -m32 add32.o main.c -o ex11 # add32.o is 32 bit object file
				./ex11
				
2. Inline assembly - discouraged
	1. not clean
		1. Each platform can use a different object file without modifying the c code
		2. Separate object files make the code more modular
			1. Easy to test, maintain and re-use
		3. Object files can be used in other assembly programs

				
## References ##
1. [Intro to x86 Assembly Language(Part 1 to Part 6)](https://www.youtube.com/watch?v=wLXIWKUWpSs&t=272s)
