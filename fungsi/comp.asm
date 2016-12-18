section .data
	compTurn 		db		"--------------------------[PLAYER %d TURN]--------------------------",10,10,0
	res_thumb_co	db		10,"Thumb(s) rised: '%d'",0
	res_p_guess_co 	db		" and Player %d guess was '%d'",10,0
	cogotit 		db		"[PLAYER %d GOT IT!]", 10,0
	len_cgt 		equ		$-cogotit
	cowrong 		db 		"[PLAYER %d GUESS WAS WRONG!]",10,0
	len_cwr 		equ		$-cowrong

section .bss

section .text

coTurn:
	mov ecx, [i]
	cmp dword[jempol_player+ecx*4], 0
	je return_back2	

	push dword[i]
	push compTurn
	call printf
	add esp, 8

	mov eax, [jempol_player+4]
	cmp eax, 0
	jne coTurn_p1
	mov dword[player_t], 0
	jmp coTurnNext1

coTurn_p1:
	push thumbRise
	call printf
	add esp, 4

	push player_t
	push int_frm
	call scanf
	add esp, 8

	mov eax, [player_t]
	mov ecx, 1
	cmp eax, [jempol_player+ecx*4]
	ja invalid_co1
	jmp coTurnNext1

invalid_co1:
	push w_thumbRise
	call printf
	add esp, 4

	push player_t
	push int_frm
	call scanf
	add esp, 8

	mov eax, [player_t]
	mov ecx, 1
	cmp eax, [jempol_player+ecx*4]
	ja invalid_co1
	jmp coTurnNext1

coTurnNext1:
	;random[1] = rand()
	mov eax, 13
	mov ebx, 0
	int 0x80
	
	mov ecx, 1
	mov dword[random+ecx*4], eax

	mov dword[k], 2

;for(k=2; k<=n_pemain; k++)
loopC1:
	mov ecx, [k]
	cmp ecx, [n_pemain]
	ja validLoop

	mov eax, 13
	mov ebx, 0
	int 0x80

	mov edx, 0
	mov ebx, 3
	div ebx

	mov ecx, [k]
	dec ecx
	add eax, [random+ecx*4]

	mov edx, 0
	mov ebx, 3
	div ebx
	
	mov ecx, [k]
	mov dword[random+ecx*4], edx

	mov eax, [jempol_player+ecx*4]
	cmp eax, 0
	je resetRandom_co

	add dword[k],1
	jmp loopC1

resetRandom_co:
	mov dword[random+ecx*4], 0
	add dword[k],1
	jmp loopC1
;end for
validLoop:
	mov dword[guess], 0

coTurnNext2:
	;while(guess<random[i])
	mov eax, [guess]
	mov ecx, [i]
	cmp eax, [random+ecx*4]
	jae coTurnNext3

	mov eax, 13
	mov ebx, 0
	int 0x80

	mov edx, 0
	mov ebx, 3
	div ebx

	mov ecx, [k]
	dec ecx
	add eax, [random+ecx*4]

	mov edx, 0
	mov ebx, 3
	div ebx

	mov dword[guess], edx
	jmp coTurnNext2
	;end while
coTurnNext3:
	;looping menghitung semua jempol yang diangkat pemain
	mov dword[sum_thumb], 0

	push riseThumbtxt
	call printf
	add esp, 4
	mov dword[k],1

loopC2:
	mov ecx, [k]
	cmp ecx, [n_pemain]
	ja coTurnNext4

	cmp ecx, 1
	jne loopC2_comp

	push dword[player_t]
	push res_player
	call printf
	add esp, 8

	mov eax,[player_t]
	add dword[sum_thumb], eax

	add dword[k],1
	jmp loopC2

loopC2_comp:
	mov ecx, [k]

	push dword[random+ecx*4]
	push dword[k]
	push res_comp
	call printf
	add esp, 12

	mov ecx, [k]
	mov eax,[random+ecx*4]
	add dword[sum_thumb], eax

	add dword[k],1
	jmp loopC2
	;end menghitung
coTurnNext4:
	;if(player_guess == jempol_yang_terangkat)
	push dword[sum_thumb]
	push res_thumb_co
	call printf
	add esp, 8

	push dword[guess]
	push dword[i]
	push res_p_guess_co
	call printf
	add esp, 12

	mov eax, dword[guess]
	cmp eax, [sum_thumb]
	je rightGuess_co
	jmp wrongGuess_co

rightGuess_co:
	;kondisi benar
	mov ecx, [i]
	mov eax, [jempol_player+ecx*4]
	sub eax, 1 ;lakukan pengurangan sisa jempol
	mov dword[jempol_player+ecx*4], eax
	
	;mencetak "YOU GOT IT"
	push dword[i]
	push cogotit
	call printf
	add esp, 8

	jmp prevReturn3

wrongGuess_co:
	;kondisi salah

	;mencetak "YOUR GUESS WAS WRONG!"
	push dword[i]
	push cowrong
	call printf
	add esp, 8

	jmp prevReturn3


prevReturn3:
	mov ecx, [i]
	cmp dword[jempol_player+ecx*4], 0
	jne return3

	mov ecx, [ke]
	mov eax, [i]
	mov dword[juara+ecx*4], eax
	add dword[ke], 1
	

return3:
	;MENCETAK "PRESS ENTER TO CONTINUE"

	;menerima karaker "enter"
	push continue
	push char_frm
	call scanf
	add esp, 8

	push continueTxt
	call printf
	add esp, 4

	push continue
	push char_frm
	call scanf
	add esp, 8

	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 0x80

return_back2:
	ret