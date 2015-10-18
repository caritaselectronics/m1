#include <stdlib.h>
#include <stdio.h>

#include "ctx.h"
#include "semaphore.h"

/*
void f_ping(void*arg);
void f_pang(void*arg);
void f_pong(void*arg);

int main(){
    create_ctx(16384, f_ping, NULL);
    create_ctx(16384, f_pong, NULL);
    create_ctx(16384, f_pang, NULL);
    yield();
    printf("end main\n");
    return EXIT_SUCCESS;
}

void f_ping(void*args){
    unsigned max=5;
    while(max--){
        printf("A");
        yield();
        printf("B");
        yield();
        printf("C");
        yield();
    }
}

void f_pong(void*args){
    unsigned max=4;
    while(max--){
        printf("1");
        yield();
        printf("2");
        yield();
    }
}

void f_pang(void*args){
    unsigned max=3;
    while(max--){
        printf("/");
        yield();
        printf("\\");
        yield();
    }
}
*/


#define N 5                       /* nombre de places dans le tampon */

typedef char objet_t;

struct tampon_s {
  objet_t tab[5];
  int index ;
};

struct sem_s mutex, vide, plein;

sem_init(&mutex,1);                /* controle d'acces au tampon */
sem_init(&vide,N);                 /* nb de places libres */
sem_init(&plein,0);                /* nb de places occupees */


//tampons à definir


  
static struct tampon_s buffer ;

for(int i=0 ; i<5; i++){
  buffer.tab[i]==NULL;
 };


void mettre_objet(objet_t objet){
  buffer.tab[buffer.index]= objet;
  buffer.index++;
}

void retirer_objet(&objet){
  objet = buffer.tab[buffer.index];
  buffer.tab[buffer.index]= NULL ;
}

void produire_objet(&objet){
  printf ("tapez un caractere a mettre dans le tampons \n ->");
  objet = (char) getchar() ;
}
void utiliser_objet(objet){
  printf ("objet retirer du tampons %c",objet);
}
void producteur (void)
{
  objet_t objet ;

  while (1) {
    produire_objet(&objet);           /* produire l'objet suivant */
    sem_down(&vide);                  /* dec. nb places libres */
    sem_down(&mutex);                 /* entree en section critique */
    mettre_objet(objet);              /* mettre l'objet dans le tampon */
    sem_up(&mutex);                   /* sortie de section critique */
    sem_up(&plein);                   /* inc. nb place occupees */
  }
}

void consommateur (void)
{
  objet_t objet ;

  while (1) {
    sem_down(&plein);                 /* dec. nb emplacements occupes */
    sem_down(&mutex);                 /* entree section critique */
    retirer_objet (&objet);           /* retire un objet du tampon */
    sem_up(&mutex);                   /* sortie de la section critique */
    sem_up(&vide);                    /* inc. nb emplacements libres */
    utiliser_objet(objet);            /* utiliser l'objet */
  }
