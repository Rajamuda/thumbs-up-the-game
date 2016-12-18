; @author 	: Ivan Maulana
; @project 	: Clear Screen

section .data

section .bss

section .text


clrScr:
	mov eax, 4
	mov ebx, 1
	mov ecx, clr_scr
	mov edx, len_clr_scr
	int 0x80
    ret