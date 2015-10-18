#ifndef DEF_CTX_H
#define DEF_CTX_H

typedef void (*func_t)(void *);
int create_ctx(int stack_size, func_t t, void *args);
void yield();

#endif
