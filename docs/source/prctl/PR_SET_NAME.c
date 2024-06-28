#include <pthread.h>
#include <stdio.h>
#include <sys/prctl.h>
#include <unistd.h>

int main() {
    
    printf("Main id: %lu\n", getpid());
    printf("Main thread id: %lu\n", (unsigned long)pthread_self());
    create_threads();

}

void* thread1() {
    prctl(PR_SET_NAME, "MY_THREAD_1");
    printf("Thread id: %lu\n", (unsigned long)pthread_self());
    while(1) sleep(1);
}

void create_threads() {
    pthread_t id1, id2, id3;

    if (!pthread_create(&id1, NULL, thread1, NULL)) {
        printf("thread 1 created.\n");
    }

    while(1) sleep(1);
}

// ps -T -p [进程PID] 验证Thread Name

// https://blog.csdn.net/wennuanddianbo/article/details/66975363