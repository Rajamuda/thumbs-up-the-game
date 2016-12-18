
section .data

section .bss

section .text


menuMain:
    mov eax, 4
	mov ebx, 1
	mov ecx, awal1
	mov edx, len_awal1
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, start
	mov edx, len_start
	int 0x80

	push n_pemain
	push int_frm
	call scanf
	add esp, 8

    ret