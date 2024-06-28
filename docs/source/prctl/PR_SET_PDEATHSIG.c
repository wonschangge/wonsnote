#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/prctl.h>
#include <sys/types.h>
#include <error.h>

void sigusr1_handler(int dummy)
{
    printf("Parent died, child now existing\n");
    exit(0);
}

int main()
{
    pid_t pid;

    pid = fork();
    if (pid < 0)
        err(1, "fork failed");
    if (pid == 0) {
        // child
        if (signal(SIGUSR1, sigusr1_handler) == SIG_ERR)
            err(1, "signal failed");
        if (prctl(PR_SET_PDEATHSIG, SIGUSR1) < 0)
            err(1, "prctl failed");
        
        for (;;) sleep(60);
    }
    if (pid > 0) {
        // parent
        sleep(5);
        printf("Parent existing...\n");
    }

    return 0;
}

// PDEATHSIG 看作 Process Death Signal
// PR_SET_PDEATHSIG 的作用: allow a signal to be sent to child processes when the parent unexpectedly dies
// 此例使用 SIGUSR1 信号来通知子进程父进程已挂，一般printf()不该用在signal handler上，此处仅用作示例。