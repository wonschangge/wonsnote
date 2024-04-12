__attribute__((constructor))
============================

GNU C中的特色，__attribute__ 机制，其可设置函数/变量/类型属性（Function/Variable/Type Attribute）。

书写特征，前后两个下划线，再紧接一对圆括弧，括弧内是相应的 __attribute__ 参数。

语法格式示例：__attribute__((attribute-list))

作用：

* __attribute__((constructor))，在main函数之前执行
* __attribute__((destructor))，在main函数或exit()之后执行


普通写法：

.. code::c

    __attribute__((constructor))
    static void beforeFunction()
    {
        printf("beforeFunction\n");
    }

声明和实现分离写法：

.. code::c

    __attribute__((constructor(101))) void beforeFunction();

    void beforeFunction()
    {
        printf("beforeFunction\n");
    }

.. note:: 可带参数，多个的情况下会依照优先级顺序调用。1~100是保留范围，建议从100之后开始用。



char** argv vs. char* argv[]
============================

完全等价。 ``char *argv[]`` 必须被读取为指针数组，
char并且数组参数被降级为指针，因此指针指向char, 或 ``char **``。

当使用语法声明或定义函数 ``X foo(Y a[])`` 时，它实际上就变成了
``X foo(Y *a)``。

看起来像函数数组参数的东西实际上是一个指针。

由于argv被声明为一个（指针）数组，因此它成为一个（指向指针的）指针。

.. note:: 数组的黄金法则：“数组的名称是指向数组第一个元素的指针。”

因此， ``char text[] = "A string of characters.";`` 中，

变量“text”是指向刚刚声明的字符数组中第一个字符的指针。

换句话说，“text”的类型是 ``char *``。当使用 ``[ index ]`` 访问数组的元素时，
实际上所做的是将索引的偏移量添加到指向数组第一个元素的指针，然后取消引用这个新指针。

因此，以下两行将两个变量初始化为“t”：

.. code::c

    char thirdChar = text[3];
    char thirdChar2 = *(text+3);

使用方括号是一种语法糖，增强了代码可读性。

但是，当考虑更复杂的事物（例如指向指针的指针）时，其工作方式非常重要。

``char** argv`` 与第二种情况相同，``char* argv[]`` 因为在第二种情况下
“数组的名称是指向数组中第一个元素的指针”。

从这里你也应该能够明白为什么数组索引从 0 开始。
指向第一个元素的指针是数组的变量名（再次是黄金法则）加上偏移量......什么都没有！

我和朋友讨论过哪个更好，使用 ``char* argv[]`` 是一个“指向字符的指针数组”，
而不是 ``char** argv`` 可以读作“指向字符指针的指针”的符号。

我的观点是，后者没有向读者传达那么多信息，前者可读性更好。