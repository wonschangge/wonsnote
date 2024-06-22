#include "error_functions.h"
#include "unix_socket.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    struct sockaddr_un addr;
    ssize_t numRead;
    char buf[BUF_SIZE];

    // 创建一个新的客户套接字，域:AF_UNIX, 类型:SOCK_STREAM, 协议:0
    int sfd = socket(AF_UNIX, SOCK_STREAM, 0);
    printf("客户套接字句柄 = %d\n", sfd);

    // 确保套接字句柄合法
    if (sfd == -1) {
      errExit("socket");
    }

    //
    // 结构化服务地址并与其连接
    //
    memset(&addr, 0, sizeof(struct sockaddr_un));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, SV_SOCK_PATH, sizeof(addr.sun_path) - 1);

    // 把的活跃的sfd套接字连接到addr指定地址的监听套接字上
    if (connect(sfd, (struct sockaddr *) &addr,
                sizeof(struct sockaddr_un)) == -1) {
      errExit("connect");
    }

    //
    // 拷贝标准输入到socket中
    //

    // 从标准输入读取最多BUF_SIZE个字节到buf上
    while ((numRead = read(STDIN_FILENO, buf, BUF_SIZE)) > 0) {
      // 然后，将buf中的这些字节写入套接字中
      if (write(sfd, buf, numRead) != numRead) {
        fatal("partial/failed write");
      }
    }

    if (numRead == -1) {
      errExit("read");
    }

    // 关闭套接字，服务端可看见EOF
    exit(EXIT_SUCCESS);
}
