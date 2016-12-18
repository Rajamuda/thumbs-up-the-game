;author 1: Fadhlal K. Surado
;author 2: Maulana Mhd. Hafiz
;task: Project - Thumb Up!

%include "fungsi/utama.asm"
%include "fungsi/pemain.asm"
%include "fungsi/clrScr.asm"
%include "fungsi/human.asm"
%include "fungsi/comp.asm"

extern printf
extern scanf

section .data
	awal1 			db		"=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=", 10, 9, 9
					db		"THUMBS UP: THE GAME",10
					db		"=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=",10,0
	len_awal1		equ		$-awal1
	start			db		"Masukkan banyaknya pemain (max:3): ",0
	len_start		equ		$-start	
	int_frm			db		"%d",0
	char_frm 		db 		"%c",0
	int_frm_out 	db		"Hasilnya adalah: %d",10,0

	gameOv 			db		"The Champions",10,0
	gameOv_len 		equ		$-gameOv
	displayJuara 	db		"Juara %d: Player %d",10,0

	exit1 			db		10,"=x=x=x=x=x=x=x=x=x=x=x=x=[ GAME OVER ]=x=x=x=x=x=x=x=x=x=x=x=x=",10,10,0
	exit1_len 		equ		$-exit1

	; untuk clear screen
    clr_scr     	db      27, '[H', 27, '[2J', 0
    len_clr_scr 	equ     $-clr_scr

    ;interaktif
    thumbRise 		db		"=> Thumb to rise: ",0
	w_thumbRise 	db		"[INVALID INPUT!] => Thumb to rise: ",0
	riseThumbtxt 	db		10,"-------------------------[RISE ALL THUMBS!]------------------------",10,0
	res_player 		db		"You ",9,9,": %d",10,0
	res_comp 		db		"Player %d ",9,": %d",10,0
	newline 		db		10
	continueTxt 	db 		10,"PRESS ENTER TO CONTINUE",0

    ;inisiasi variable
    y				db		1 			;
    ke				db		1 			;variabel iterasi untuk juara
    i				db		1 			;iterasi untuk giliran pemain ke berapa
    jempol_player	dd		0,2,2,2,2 	;jempol pemain yang tersedia
    random			dd		0,0,0,0,0 	;menyimpan jempol pemain komputer
    juara			dd		0,0,0,0,0 	;menyimpan urutan juara
    j_count			db		0,0,0,0,0 	;menghitung apakah pemain sudah menjadi juara atau belum

 

section .bss
	n_pemain		resd	1 ;banyak pemain
	sum_thumb		resd	1 ;menampung jumlah jempol yang masih ada
	guess 			resd 	1 ;menyimpan tebakan pemain
	count			resd	1 ;menghitung jumlah pemain yang masih bermain
	k				resd	1 ;variabel penunjuk untuk iterasi
	continue 		resb 	1 ;menerima input "karakter" untuk melanjutkan permainan
	player_t 		resd 	1 ;jempol player1 yang terangkat

section .text
	global main

main:
	call clrScr
	call menuMain

while: 
	call clrScr
	call statusPemain
	cmp dword[count],1
	je gameOver
	mov ecx, [i]
	cmp ecx, 1
	je human
	jmp computer

human:
	call p1Turn
	jmp endWhile

computer:
	call coTurn
	jmp endWhile

endWhile:
	add dword[i], 1
	jmp while

gameOver:
	mov eax, 4
	mov ebx, 1
	mov ecx, gameOv
    mov edx, gameOv_len
	int 0x80

gameOver_champ:
	mov dword[k], 1
	mov ecx, [k]
	cmp ecx, [n_pemain]
	jb loop_champ
	jmp exit

loop_champ:
	push dword[juara+ecx*4]
	push dword[k]
	push displayJuara
	call printf
	add esp, 12
	cmp ecx, [n_pemain]
	add dword[k], 1
	jb loop_champ

exit:
	mov eax, 4
	mov ebx, 1
	mov ecx, exit1
	mov edx, exit1_len
	int 0x80

	mov eax, 1
	xor ebx, ebx
	int 0x80
