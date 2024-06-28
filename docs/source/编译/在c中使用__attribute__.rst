在c中使用__attribute__
===========================================================

__attribute__ 是给编译器处理的一个玩意，面向GCC/Clang的，其常用的包括：

1. __attribute__ unused
2. __attribute__ format
3. __attribute__ noreturn
4. __attribute__ const

__attribute__ unused
-----------------------------------------------------------

以 unused 的用法为例：

test.c:

::

    int main(int argc, char **argv)
    {
        /* code that uses argv, but not argc */
    }

我的编译：

::
    
    $ gcc -W test.c 
    # 我的 gcc 12.2.0 不会报任何 warning ...
    $ clang -W test.c 
    test.c:1:14: warning: unused parameter 'argc' [-Wunused-parameter]
    int main(int argc, char **argv) {
                ^
    test.c:1:27: warning: unused parameter 'argv' [-Wunused-parameter]
    int main(int argc, char **argv) {
                            ^
    2 warnings generated.
    # clang 报出了警告

添加 __attribute__((unused)) 之后：

::

    int main(__attribute__ ((unused)) int argc, char **argv)
    // 或置于尾部
    // int main(int argc __attribute__ ((unused)), char **argv)
    {
        /* code that uses argv, but not argc */
    }

再次编译：

::
    
    $ clang -W test.c 
    test.c:1:51: warning: unused parameter 'argv' [-Wunused-parameter]
    int main(__attribute__((unused)) int argc, char **argv) {
                                                    ^
    1 warning generated.

可看见已消警

.. note::为什么要消警告，在实际工程中，如果error隐含在大量的warning中，会大大降低debug的效率，也会影响合作开发的判断。

其他示例场景：

::
    
    /* warning: 'someFunction' declared 'static' but never defined */
    static int someFunction() __attribute__((unused));

    int main(int argc __attribute__((unused)), char **argv)
    {
    /* warning: unused variable 'mypid' */
    int	mypid __attribute__((unused)) = getpid();

    #ifdef DEBUG
        printf("My PID = %d\n", mypid);
    #endif

        return 0;
    }

作用：

1. 通过编译
2. 预留暂不使用的参数槽位

__attribute__ format
-----------------------------------------------------------

::

    /* like printf() but to standard error only */
    extern void eprintf(const char *format, ...)
        __attribute__((format(printf, 1, 2)));  /* 1=format 2=params */

    /* printf only if debugging is at the desired level */
    extern void dprintf(int dlevel, const char *format, ...)
        __attribute__((format(printf, 2, 3)));  /* 2=format 3=params */

::

    $ cat test.c
    1  extern void eprintf(const char *format, ...)
    2               __attribute__((format(printf, 1, 2)));
    3
    4  void foo()
    5  {
    6      eprintf("s=%s\n", 5);             /* error on this line */
    7
    8      eprintf("n=%d,%d,%d\n", 1, 2);    /* error on this line */
    9  }

    $ cc -Wall -c test.c
    test.c: In function `foo':
    test.c:6: warning: format argument is not a pointer (arg 2)
    test.c:8: warning: too few arguments for format

__attribute__ noreturn
-----------------------------------------------------------

::

    extern void exit(int)   __attribute__((noreturn));
    extern void abort(void) __attribute__((noreturn));


::

    $ cat test1.c
    extern void exitnow();

    int foo(int n)
    {
        if ( n > 0 )
        {
            exitnow();
            /* control never reaches this point */
        }
        else
            return 0;
    }

    $ cc -c -Wall test1.c
    test1.c: In function `foo':
    test1.c:9: warning: this function may return with or without a value


::

    $ cat test2.c
    extern void exitnow() __attribute__((noreturn));

    int foo(int n)
    {
            if ( n > 0 )
                    exitnow();
            else
                    return 0;
    }

    $ cc -c -Wall test2.c
    no warnings!

__attribute__ const
-----------------------------------------------------------

::

    extern int square(int n) __attribute__((const));

    ...
        for (i = 0; i < 100; i++ )
        {
            total += square(5) + i;
        }

其他：
-----------------------------------------------------------

::

    __attribute__((constructor))
    __attribute__((aligned(sizeof(int))))
    __attribute__((cleanup(channel_free_options)))


参考：

1. `Using GNU C __attribute__ <http://www.unixwiz.net/techtips/gnu-c-attributes.html#format>`_
