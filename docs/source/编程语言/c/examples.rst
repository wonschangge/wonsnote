常用示例
=============



snprintf
--------------

语法：

::

    int snprintf(str, size, const char *format, ...);

参数：

1. \*str：指向缓冲区的指针。
2. \*size：这是将写入缓冲区的最大字节数（字符）。
3. format：包含遵循与 printf 中的格式相同规范的格式字符串的 C 字符串。
4. (…):可选的（…）参数只是像printf 中看到的字符串格式（“％d”，myint）。

返回值：

1. 如果n足够大，则写入缓冲区的字符数。终止空字符不算在内。
2. 如果发生编码错误，返回负数。

示例：

::

    // C program to demonstrate snprintf()
    #include <stdio.h>

    int main()
    {
        char buffer[50];
        char* s = "geeksforgeeks";

        // Counting the character and storing
        // in buffer using snprintf
        printf("Writing %s onto buffer"
            " with capacity 6",
            s);
        int j = snprintf(buffer, 6, "%s\n", s);

        // Print the string stored in buffer and
        // character count
        printf("\nString written on "
            "buffer = %s",
            buffer);
        printf("\nValue returned by "
            "snprintf() method = %d\n",
            j);

        return 0;
    }

结果：

1. 将 geeksforgeeks 写入容量为 6 的缓冲区
2. 缓冲区中写入的字符串 = geeks
3. snprintf() 方法返回的值 = 14

asprintf
----------------------

语法：

::

    int asprintf(char **ret, const char *format, ...);

示例：

::

    #include <stdio.h>

    int main()
    {
        char *buffer;
        int r;

        r = asprintf(&buffer, "The total is %d\n", 5+8);

        puts(buffer);
        printf("%d characters generated\n",r);

        return(0);
    }

结果：

1. The total is 13
2. 16 characters generated

bzero
-----------------------

::

    some_struct *foo = malloc(sizeof(some_struct))
    bzero(foo, sizeof(some_struct))

其与memset(foo, 0, sizeof(some_struct))没区别

可能的某种底层实现：

::

    void bzero(void * s, size_t n)
    {
        char * c = s; // Can't work with void *s directly.
        size_t i;
        for (i = 0; i < n; ++i)
            c[i] = '\0';
    }

write
-----------------------------

语法：

::

    int write(int fileDescriptor, void *buffer, size_t bytesToWrite)

参数：

1. fileDescriptor： 打开文件的整数文件描述符
2. buffer：此指针指向一个缓冲区，其中包含我们想要写入文件的数据。
3. bytesToWrite：在这里，我们提供了一个无符号整数变量，它指定了我们想要从缓冲区写入文件的最大字节数

示例：

::

    #include <stdio.h>
    #include <unistd.h>
    #include <stdlib.h>
    #include <fcntl.h>
    #include <string.h>

    int main(){
        
        char* fileName = "sample.txt";

        int fd = open(fileName, O_RDWR);
        
        if(fd == -1){
            printf("\nError Opening File!!\n");
            exit(1);
        }
        else{
            printf("\nFile %s opened successfully!\n", fileName);
        }

        char *buffer = "Hello Educative User!\n";

        int bytesWritten = write(fd, buffer, strlen(buffer));

        printf("%d bytes written successfully!\n", bytesWritten);

        return 0;
    }


read
------------

write的完全逆过程