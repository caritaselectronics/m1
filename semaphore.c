#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
#include<ctx.h>
#include "semaphore.h"


/* la strucuture semaphore contient un compteur 
   et une liste de contextes block sur ce semaphore = au premier elemlent de ctee liste*/

typedef struct sem_s {
  int *sem_val;
  struct ctx_s *sem_ctx_list ;
}
/* initiialisation d'un sempahore*/
  
  void sem_init(struct sem_s *sem, unsigned int val){
    sem->sem_val = val ;
    sem->sem_ctx_list = NULL;
  }

{
  (sem->sem_val)-- ;
  if (sem->sem_val<0){
    current_ctx->ctx_state = CTX_BLK_SEM;
    current_ctx->ctx_next_same_sem_list = sem->sem_ctx_list;
    sem->sem_ctx_list  = current_ctx;
    yield()
      }
}
  void sem_up(struct sem_s sem){
struct ctx_s *ct
    (sem->sem_val)++ ;
  if (sem->sem_val<=0){
    ct = (struct *ctx)malloc(sizeof(struct ctx_s)) ;
    ctx = (sem->sem_ctx_list)->same_sem_list ;
    (sem->sem_ctx_list)->ct_state = CTX_XR ;
    sem->sem_ctx_list = ctx;
    free(ctx);
  }
