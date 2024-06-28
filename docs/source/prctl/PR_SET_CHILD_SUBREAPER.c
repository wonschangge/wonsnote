#include <stdio.h>
#include <sys/prctl.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

// Make a grandchild process, which sleep(2)s and then exits
int doGrandchild(void) {
    int pid;
    if ((pid = fork()) != 0) {
        return pid;
    }
    
    printf("    GRANDCHILD(%d): before sleep, parent is %d\n", getpid(), getppid());
    sleep(2);   // Wait for CHILD to report and exit
    printf("    GRANDCHILD(%d): after sleep, parent is %d\n", getpid(), getppid());
    
    printf("    GRANDCHILD(%d): exiting\n", getpid());
    exit(0);
    // Will never return
}

// Make a child process, which makes a grandchild process, sleep(1)s, and then exits
int doChild(void) {
    int pid;
    if ((pid = fork()) != 0) {
        return pid;
    }
    sleep(1);   // Wait for PARENT to report fork
    printf("  CHILD(%d): parent is %d\n", getpid(), getppid());
    
    pid = doGrandchild();
    printf("  CHILD(%d): forked grandchild %d\n", getpid(), pid);
    sleep(1);   // Wait for GRANDCHILD to report
    
    printf("  CHILD(%d): exiting\n", getpid());
    exit(0);    // Exit before GRANDCHILD exits
    // Will never return
}

// Wait for all child descendents to exit
void waitDescendents(void) {
    printf("PARENT(%d): waiting for descendents to exit\n", getpid());
    while(1) {
        // Wait for any descendant process to exit
        int pid = wait(NULL);
        if(pid == -1) {
            printf("PARENT(%d): no more descendants\n", getpid());
            break;
        } else {
            printf("PARENT(%d): pid %d exited\n", getpid(), pid);
        }
    }
}

// Run the test
int main(void) {
    int pid;

    printf("PARENT(%d): parent is %d\n", getpid(), getppid());
    
    prctl(PR_SET_CHILD_SUBREAPER, 1, 0, 0, 0);
    printf("PARENT(%d): ===== Run test with CHILD_SUBREAPER set to 1 =====\n", getpid());
    
    pid = doChild();
    printf("PARENT(%d): forked child %d\n", getpid(), pid);
    waitDescendents();
    
    prctl(PR_SET_CHILD_SUBREAPER, 0, 0, 0, 0);
    printf("PARENT(%d): ===== Run test with CHILD_SUBREAPER set to 0 =====\n", getpid());
    
    pid = doChild();
    printf("PARENT(%d): forked child %d\n", getpid(), pid);
    waitDescendents();
    
    printf("PARENT(%d): ===== Exiting =====\n", getpid());
    return 0;
}

// https://stackoverflow.com/questions/56856275/is-there-some-short-example-of-how-to-use-prctl-when-it-comes-to-setting-subre

// Compiling and running:

// griscom@nob:~/tmp$ cc -Wall subreaper_test.c -o subreaper_test
// griscom@nob:~/tmp$ echo "My PID is $$"
// My PID is 1001
// griscom@nob:~/tmp$ ./subreaper_test 
// PARENT(1002): parent is 1001
// PARENT(1002): ===== Run test with CHILD_SUBREAPER set to 1 =====
// PARENT(1002): forked child 1003
// PARENT(1002): waiting for descendents to exit
//   CHILD(1003): parent is 1002
//   CHILD(1003): forked grandchild 1004
//     GRANDCHILD(1004): before sleep, parent is 1003
//   CHILD(1003): exiting
// PARENT(1002): pid 1003 exited
//     GRANDCHILD(1004): after sleep, parent is 1002
//     GRANDCHILD(1004): exiting
// PARENT(1002): pid 1004 exited
// PARENT(1002): no more descendants
// PARENT(1002): ===== Run test with CHILD_SUBREAPER set to 0 =====
// PARENT(1002): forked child 1005
// PARENT(1002): waiting for descendents to exit
//   CHILD(1005): parent is 1002
//   CHILD(1005): forked grandchild 1006
// GRANDCHILD(1006): before sleep, parent is 1005
//   CHILD(1005): exiting
// PARENT(1002): pid 1005 exited
// PARENT(1002): no more descendants
// PARENT(1002): ===== Exiting =====
// griscom@nob:~/tmp$     GRANDCHILD(1006): after sleep, parent is 1
//     GRANDCHILD(1006): exiting