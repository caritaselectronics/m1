#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
#include "ctx.h"
#include<semaphore.h>


#define CTX_MAGIC 0xb1ab1a

enum ctx_state_e{CTX_INIT,CTX_EXR,CTX_END,CTX_BLK_SEM};

struct ctx_s{
  unsigned int ctx_magic;
  struct ctx_s *next;
  void* ctx_base;
  void* ctx_esp;
  void *ctx_ebp;
  func_t ctx_f;
  void *ctx_arg;
  enum ctx_state_e ctx_state;
  struct ctx_s *ctx_next_same_sem;
};

//void switch_to_ctx(struct ctx_s *ctx);
void switch_to_next();
void init_ctx(struct ctx_s *ctx, size_t stack_size, func_t f, void*args);


/*contexte courant*/
static struct ctx_s *current_ctx = (struct ctx_s *) 0;
static struct ctx_s *ctx_ring = NULL;

static void start_current_ctx()
{
      current_ctx->ctx_state = CTX_EXR;
      current_ctx->ctx_f(current_ctx->ctx_arg);
      current_ctx->ctx_state = CTX_END;
      yield();
}

int create_ctx(int stack_size, func_t f, void *args)
{
    struct ctx_s *new = (struct ctx_s*) malloc(sizeof(struct ctx_s));
    assert(new != NULL);
    init_ctx(new, stack_size, f, args);
    if (ctx_ring == NULL)
        ctx_ring = new->next = new;
    else{
        new->next = ctx_ring->next;
        ctx_ring->next = new;
    }
    if (!current_ctx) current_ctx = new;
    return 0;
}

//void switch_to_ctx(struct ctx_s *ctx){
void switch_to_next(){
  struct ctx_s *ctx = current_ctx->next;
  /*verifier ctx_magic*/
  int verite = 1;
  assert(ctx->ctx_magic == CTX_MAGIC);
  while (ctx->ctx_state == CTX_BLK_SEM && verite) {
    /*elimine pout les coontexte terminé*/
    
  while (ctx->ctx_state == CTX_END ){
    free(ctx->ctx_base);
    current_ctx->next = ctx->next;
    free(ctx);
    if (ctx == current_ctx){
        current_ctx = NULL;
        verite = 0 ;
    }
    
    ctx = current_ctx->next;
    /*une fois que un contexte no termine est pointé dessus verifie si il n'est pas bloqué*/
   
    //teste si le ctx souvent n'esst pas bloqué si non parcourir la boucle pour en trouve un autre
    //if (ctx-> ctx_state )
  }   
 if (ctx->ctx_state != CTX_BLK_SEM){
      verite = 0 ;
    }
  }
  
  assert(ctx->ctx_state == CTX_INIT || ctx->ctx_state == CTX_EXR);  
/*sauvegarder les %esp %ebp dans la structure de ctx courant*/
  if(current_ctx) 
  {
    asm("movl %%ebp, %0" : "=r"(current_ctx->ctx_ebp));
    asm("movl %%esp, %0" : "=r"(current_ctx->ctx_esp));
  }
  /*sauvegarde ctx quii n'est plus accessible dans le nauveau contexte*/
  current_ctx = ctx;
  /*retourner %ebp %ebp depuis la structure du nouveau context*/
  asm("movl %0, %%ebp" "\n\t"
      "movl %1, %%esp" "\n\t"
      : : "r"(current_ctx->ctx_ebp), "r"(current_ctx->ctx_esp));
  if(current_ctx->ctx_state == CTX_INIT)
      start_current_ctx();
}

void init_ctx(struct ctx_s *ctx, size_t stack_size, func_t f, void*args)
{
    ctx->ctx_magic = CTX_MAGIC;
    ctx->ctx_f = f;
    ctx->ctx_arg = args;
    ctx->ctx_base = malloc(stack_size);
    assert(ctx->ctx_base != NULL);
    ctx->ctx_ebp = ctx->ctx_esp = ctx->ctx_base + stack_size;
    ctx->ctx_state = CTX_INIT;
}

void yield()
{
    if (current_ctx)
        switch_to_next();
    else{
        puts("no ctx to switch to");
        exit(1);
    }
}

