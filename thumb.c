#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/**dokumentasi
	n_pemain = jumlah pemain yang ikut
	n_jempol = ngitung banyaknya jempol

**/
int main(){
	// random berdasarkan waktu
	srand(time(NULL));

	int n_pemain,player;
	int a_pemain[5], random[5]={0}, juara[5]={0}, to[5]={0};
	int i=1,k,sum_thumb,guess,count,c=1;
	char s;
	printf("=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=\n\t\tTHUMBS UP: THE GAME\n=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=x=\n");
	printf("Masukkan banyaknya pemain (max:3): ");
	scanf("%d", &n_pemain);

	//n_jempol = n_pemain*2;

	for(k=1; k<=n_pemain;k++){
		a_pemain[k]=2;
	}


	int y=1;
	while(y){
		if(i>n_pemain) i=1; // jika semua pemain sudah menebak langsung ulang ke player 1

		system("clear"); //bersihkan layar

		if(i==1)
			printf("\n\n-----------------------[YOUR TURN]-----------------------\n\n");
		else
			printf("\n\n---------------------[PLAYER %d TURN]---------------------\n\n",i);

		sum_thumb=0; count=0;
		//tampilkan status jempol
		printf("[======================THUMBS STATUS======================]\n");
		for(k=1; k<=n_pemain;k++){
			if(k==1) {
				printf("Your Thumb(s): %d\t", a_pemain[k]);
				if(a_pemain[k] != 0) count++;
			}
			else {
				printf("Player %d Thumb(s): %d\t", k, a_pemain[k]);
				if(a_pemain[k] != 0) count++;
			}
			sum_thumb += a_pemain[k];
		}
		printf("\n[=========================================================]\n");

		//jika tersisa satu pemain, cetak data pemenang
		if(count==1){
			printf("THE CHAMPIONS\n");
			for(k=1;k<n_pemain;k++){
				printf("Juara %d: Player %d\n", k, juara[k]);
			}
			printf("\n=x=x=x=x=x=x=x=x=x=x=x=[GAME OVER]=x=x=x=x=x=x=x=x=x=x=x=\n\n");
			break;
		}
		// player 1 (human)
		if(i==1 && a_pemain[i] != 0){
			printf("\n=> You take a guess: ");
			while(scanf("%d", &guess), guess>sum_thumb){
				printf("[INVALID INPUT]\t=> Take a guess: ");
			}
			printf("=> Thumb to rise: ");
			while(scanf("%d", &player), player>a_pemain[i]){
				printf("[INVALID INPUT]\t=> Thumb to rise: ");
			}

			//memulai randomisasi
			random[1] = rand();
			for(k=2; k<=n_pemain; k++){
				random[k] = (rand()+random[k-1]) % (a_pemain[k]+1);
				if(random[k]<0){
					random[k] *= -1;
				}
				if(a_pemain[k]==0){
					random[k] = 0;
				}
			}
			sum_thumb=0;
			//mencetak informasi jempol
			printf("--------------------\nRISE ALL THUMBS!\n--------------------\n");
			for(k=1; k<=n_pemain; k++){
				if(k==1) {
					printf("You: %d\t", player);
					sum_thumb = player;
				}
				else {
					printf("Player %d: %d\t", k, random[k]);
					sum_thumb += random[k];
				}
			}
			printf("\nSum =  %d\n", sum_thumb);

			printf("\nYour guess is \"%d\"", guess);

			//berhasil tidaknya "human" menebak banyak jempol yang terangkat
			if(guess == sum_thumb){
				a_pemain[i] -= 1;
				printf(" [YOU GOT IT!]\n\n");
			}else{
				printf(" [YOUR GUESS WAS WRONG!]\n\n");
			}


			if(a_pemain[i] == 0) juara[c++]=i;

			scanf("%c", &s);
			printf("PRESS ENTER TO CONTINUE");
			getchar();


		}else if(a_pemain[i] != 0){ // player komputer

			//input "human" selagi masih punya jempol
			if(a_pemain[1] != 0){
				printf("\n=> Thumb to rise: ");
				while(scanf("%d", &player), player>a_pemain[1]){
					printf("[INVALID INPUT]\t=> Thumb to rise: ");
				}
			}else{
				player = 0;
			}

			//memulai randomisasi
			random[1] = rand();
			for(k=2; k<=n_pemain; k++){
				random[k] = (rand()+random[k-1]) % (a_pemain[k]+1);
				if(random[k]<0){
					random[k] *= -1;
				}
				//kalau si komputer udah kehabisan jempol, jangan sampai tiba2 ngacungin jempol
				if(a_pemain[k]==0){
					random[k] = 0;
				}
			}

			//kalau komputer nebak lebih kecil daripada jempol yang diacungnya.
			guess = 0;
			while(guess < random[i]){
				guess = rand() % (sum_thumb+1);
			}

			sum_thumb=0;
			//mencetak status
			printf("--------------------\nRISE ALL THUMBS!\n--------------------\n");
			for(k=1; k<=n_pemain; k++){
				if(k==1) {
					printf("You: %d\t", player);
					sum_thumb = player;
				}
				else {
					printf("Player %d: %d\t", k, random[k]);
					sum_thumb += random[k];
				}
			}

			printf("\nSum =  %d\n", sum_thumb);

			printf("\nPlayer %d guess is \"%d\"", i, guess);
			//berhasil tidaknya "human" menebak banyak jempol yang terangkat
			if(guess == sum_thumb){
				a_pemain[i] -= 1;
				printf(" [PLAYER %d GOT IT!]\n\n", i);
			}else{
				printf(" [PLAYER %d GUESS WAS WRONG!]\n\n", i);
			}

			if(a_pemain[i] == 0 && to[i]!=1){
				juara[c++]=i;
				to[i]++;
			}

			getchar();
			printf("PRESS ENTER TO CONTINUE");
			getchar();
				
		}

		i++;
	}


	return 0;
}