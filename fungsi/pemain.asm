section .data
	status1			db 		"-----------------------[YOUR TURN]-----------------------",10,0
	status2 		db 		"---------------------[PLAYER %d TURN]---------------------",10,0
	t_status_atas 	db 		"[============================THUMBS STATUS============================]",10,0
	len_tsa			equ		$-t_status_atas
	t_status_bawh	db		10,"[=====================================================================]",10,0
	len_tsb			equ		$-t_status_bawh

	;player
	p1_status 		db		"Your thumb(s): %d",9,0
	co_status 		db		"Player %d thumbs(s): %d", 9,0

	int_frm_out2 	db		"%d",10,0

section .bss

section .text

statusPemain:
	push t_status_atas
	call printf
	add esp, 4

	;if (i<n_pemain) i=1
	call cekIteration

	mov dword[k], 1
	mov dword[count], 0
	mov dword[sum_thumb], 0
	jmp forLoop
	; push dword[jempol_player+4]
	; push int_frm_out2
	; call printf
	; add esp, 8

cekIteration:
	mov ecx, [i]
	cmp ecx, [n_pemain]
	ja reset
	ret

reset:
	mov dword[i], 1
	jmp cekIteration

;for (k==1)
forLoop:
	mov ecx, [k]

	; k<=n_pemain
	cmp ecx, [n_pemain]
	jbe forLoop2
	jmp return

forLoop2:
	;sum_thumb += jempol_player[k]
	mov eax, [sum_thumb]
	add eax, dword[jempol_player+ecx*4]
	mov dword[sum_thumb], eax

	;if tingkat 1
	cmp dword[k], 1
	jne loopStatus_co
	jmp loopStatus

loopStatus:
	;if (k==1)
	mov ecx, [k]

	;print status your thumbs
	push dword[jempol_player+ecx*4]
	push p1_status
	call printf
	add esp, 8

		;if(jempol_player != 0)
		mov ecx, [k]
		cmp dword[jempol_player+ecx*4], 0
		jne itungPemain
		jmp loopStatus2

		itungPemain:
			add dword[count],1
	
loopStatus2:
	;k++
	add dword[k], 1
	jmp forLoop

loopStatus_co:
	;else
	mov ecx, [k]
	;print status player computer thumbs
	push dword[jempol_player+ecx*4]
	push dword[k]
	push co_status
	call printf
	add esp, 12

		;if(jempol_player != 0)
		mov ecx, [k]
		cmp dword[jempol_player+ecx*4], 0
		jne itungPemain2
		jmp loopStatus2_co

		itungPemain2:
			add dword[count], 1

loopStatus2_co:
	;k++
	add dword[k], 1
	jmp forLoop
	

return:
	push t_status_bawh
	call printf
	add esp, 4


	; push dword[sum_thumb]
	; push int_frm_out
	; call printf
	; add esp, 8

	ret


