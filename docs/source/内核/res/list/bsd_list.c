/*
 * This is a paradigm of how to use bsd doubly-linked list.
 * Operating System : BSD (including MacOS)
 * Compiler : GCC
 *
 * How to compile: 
 * 1) FIFO(queue) : gcc -D_FIFO_ bsd_list.c
 * 2) FILO(stack) : gcc -D_FILO_ bsd_list.c 
 *
 * Author : Yafang Shao
 */

#include <stdio.h>
#include <string.h>
#include <sys/queue.h>

struct type{
    TAILQ_ENTRY(type) list;
    char c;
} ;

TAILQ_HEAD(head_, type) header;

char *name = "YafangShao";

int main()
{

    int i;
    struct type tmp[20];
    struct type *echo;
    //step 1: init
    TAILQ_INIT(&header);

    //step 2: insert item
    for (i = 0; i < strlen(name); i++) {
        tmp[i].c = *(name + i);
        tmp[i].list.tqe_next = NULL;
        tmp[i].list.tqe_prev = NULL;
        TAILQ_INSERT_TAIL(&header, &tmp[i], list);
    }

	//step 3 : get element.
#if defined(_FIFO_)
	while ((echo = TAILQ_FIRST(&header)) != NULL) {
#elif defined(_FILO_)
    while ((echo = TAILQ_LAST(&header, head_)) != NULL){
#endif
        printf("%2c", echo->c);

        TAILQ_REMOVE(&header, echo, list);
    }
	
	printf("\n");

    return 0;
}