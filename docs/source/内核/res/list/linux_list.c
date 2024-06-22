/*
 * This is a paradigm of how to use linux doubly-linked list.
 * Operating System : linux 
 * Compiler : GCC
 *
 * How to compile: 
 * 1) FIFO(queue) : gcc -D_FIFO_ linux_list.c
 * 2) FILO(stack) : gcc -D_FILO_ linux_list.c 
 *
 * Author : Yafang Shao
 */
#include <stdio.h>
#include <string.h>

/*
* I just want to use the file exist in the system.
* I don't want to copy it. 
* Of coures, it's not the correct way, because if
* we define __KERNEL__, we mean it's a kernel level module.
*
* Actually, it's a user level progam. 
* Anyway, who cares.
*/
#define __KERNEL__  
#include <linux/list.h>  

struct type {
    struct list_head  list;
    char c;
};

struct list_head header;
char *name = "YafangShao";

int main()
{
    int i;
    struct type tmp[20];
    struct type *echo;

    INIT_LIST_HEAD(&header);

    for (i = 0; i < strlen(name); i++) {
        tmp[i].list.next = NULL;
        tmp[i].list.prev = NULL;
        tmp[i].c = *(name + i);
#if defined(_FIFO_)
        list_add_tail(&tmp[i].list, &header);
#elif defined(_FILO_)
		list_add(&tmp[i].list, &header);
#endif
    }


    while (header.next != &header) {
        echo = list_entry(header.next, struct type, list);
        printf("%2c", echo->c);

        list_del(&echo->list);
    }

	printf("\n");

    return 0;
}