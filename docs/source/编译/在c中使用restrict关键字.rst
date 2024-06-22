在c中使用restrict关键字
================================

用于辅助编译器优化不会发生变化的代码, 示例:

::

    // C program to use restrict keyword.
    #include <stdio.h>
    
    // Note that the purpose of restrict is to
    // show only syntax. It doesn't change anything
    // in output (or logic). It is just a way for
    // programmer to tell compiler about an
    // optimization
    void use(int* a, int* b, int* restrict c)
    {
        *a += *c;
    
        // Since c is restrict, compiler will
        // not reload value at address c in
        // its assembly code. Therefore generated
        // assembly code is optimized
        *b += *c;
    }
    
    int main(void)
    {
        int a = 50, b = 60, c = 70;
        use(&a, &b, &c);
        printf("%d %d %d", a, b, c);
        return 0;
    }

常见疑问参考: `Restrict Keyword In C <https://www.skillvertex.com/blog/restrict-keyword-in-c/#:~:text=For%20instance%2C%20%E2%80%9Cchar%20const%20*,performance%20while%20working%20with%20pointers.>`_