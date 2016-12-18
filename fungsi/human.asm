section .data
	yourTurn 		db		"--------------------------[YOUR TURN]--------------------------",10,10,0
	takeGuess 		db		"=> You take a guess: ",0
	w_takeGuess 	db		"[INVALID INPUT!] => Take a guess: ", 0
	res_thumb 		db		10,"Thumb(s) rised: '%d'",0
	res_p_guess 	db		" and your guess was '%d'",10,0
	yougotit 		db		"[YOU GOT IT!]", 10,0
	len_ygt 		equ		$-yougotit
	youwrong 		db 		"[YOUR GUESS WAS WRONG!]",10,0
	len_ywr 		equ		$-youwrong

section .bss

section .text

p1Turn:
	mov ecx, [i]
	cmp dword[jempol_player+ecx*4], 0
	je return_back1	

	push yourTurn
	call printf
	add esp, 4

	push takeGuess
	call printf
	add esp, 4

	push guess
	push int_frm
	call scanf
	add esp, 8

	mov eax, [guess]
	cmp eax, [sum_thumb]
	ja invalid1
	jmp p1TurnNext1

invalid1:
	push w_takeGuess
	call printf
	add esp, 4

	push guess
	push int_frm
	call scanf
	add esp, 8

	mov eax, [guess]
	cmp eax, [sum_thumb]
	ja invalid1
	jmp p1TurnNext1


p1TurnNext1:
	push thumbRise
	call printf
	add esp, 4

	push player_t
	push int_frm
	call scanf
	add esp, 8

	mov eax, [player_t]
	mov ecx, [i]
	cmp eax, [jempol_player+ecx*4]
	ja invalid2
	jmp p1TurnNext2

invalid2:
	push w_thumbRise
	call printf
	add esp, 4

	push player_t
	push int_frm
	call scanf
	add esp, 8

	mov eax, [player_t]
	mov ecx, [i]
	cmp eax, [jempol_player+ecx*4]
	ja invalid2
	jmp p1TurnNext2


p1TurnNext2:
	;random[1] = rand()
	mov eax, 13
	mov ebx, 0
	int 0x80
	
	mov ecx, [i]
	mov dword[random+ecx*4], eax

	mov dword[k], 2

;for(k=2; k<=n_pemain; k++)
loopP1:
	mov ecx, [k]
	cmp ecx, [n_pemain]
	ja p1TurnNext3

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
	je resetRandom

	add dword[k],1
	jmp loopP1

resetRandom:
	mov dword[random+ecx*4], 0
	add dword[k],1
	jmp loopP1
;end for
p1TurnNext3:
	mov dword[sum_thumb], 0

	push riseThumbtxt
	call printf
	add esp, 4
	mov dword[k],1

loopP2:
	mov ecx, [k]
	cmp ecx, [n_pemain]
	ja p1TurnNext4

	cmp ecx, 1
	jne loopP2_comp

	push dword[player_t]
	push res_player
	call printf
	add esp, 8

	mov eax,[player_t]
	add dword[sum_thumb], eax

	add dword[k],1
	jmp loopP2

loopP2_comp:
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
	jmp loopP2

p1TurnNext4:
	push dword[sum_thumb]
	push res_thumb
	call printf
	add esp, 8

	push dword[guess]
	push res_p_guess
	call printf
	add esp, 8

	mov eax, dword[guess]
	cmp eax, [sum_thumb]
	je rightGuess
	jmp wrongGuess

rightGuess:
	mov ecx, [i]
	mov eax, [jempol_player+ecx*4]
	sub eax, 1
	mov dword[jempol_player+ecx*4], eax
	
	mov eax, 4
	mov ebx, 1
	mov ecx, yougotit
	mov edx, len_ygt
	int 0x80

	jmp prevReturn2

wrongGuess:
	mov eax, 4
	mov ebx, 1
	mov ecx, youwrong
	mov edx, len_ywr
	int 0x80

	jmp prevReturn2


prevReturn2:
	mov ecx, [i]
	cmp dword[jempol_player+ecx*4], 0
	jne return2

	mov ecx, [ke]
	mov eax, [i]
	mov dword[juara+ecx*4], eax
	add dword[ke], 1


return2:
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
	
return_back1:
	ret