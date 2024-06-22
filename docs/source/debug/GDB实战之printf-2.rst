GDB实战之printf-2
===========================================================

.. note:: 来自 `使用 GDB 进行 Printf 样式的调试，第 2 部分 <https://developers.redhat.com/articles/2021/10/13/printf-style-debugging-using-gdb-part-2>`_
 
本系列的第一篇文章介绍了GNU 调试器 GDB，特别是它的dprintf命令，
它以类似于C 语言 printf语句的方式显示程序中的变量。
本文通过展示如何保存命令以供重复使用以及如何保存程序和 GDB 的输出以供以后检查，
扩展了 printf 样式调试的丰富功能。

列出当前定义的断点
-----------------------------------------------------------

该dprintf命令创建一种特殊类型的断点。该info breakpoints命令显示所有断点；但是，目前我们只dprintf定义了断点：

::

    (gdb) info breakpoints
    Num     Type           Disp Enb Address            What
    1       dprintf        keep y   0x0000000000401281 in insert at tree.c:41
        breakpoint already hit 7 times
            printf "Allocating node for data=%s\n", data
    2       dprintf        keep y   0x00000000004012b9 in insert at tree.c:47
        breakpoint already hit 6 times
            printf "Recursing left for %s at node %s\n", data, tree->data
    3       dprintf        keep y   0x00000000004012de in insert at tree.c:49
        breakpoint already hit 6 times
            printf "Recursing right for %s at node %s\n", data, tree->data
    (gdb) 

保存 dprintf 命令以供以后会话使用
-----------------------------------------------------------

在传统的 printf 式调试中，添加到程序中的打印语句会一直存在，直到被删除。
使用GDB dprintf命令时情况并非如此；dprintf断点和普通断点都会在整个 GDB 会话中持续存在，
但它们不会在会话之间持续存在。但是，断点可以保存到文件中以供以后重复使用。

该save breakpoints命令将断点保存到文件中。以下示例显示如何将断点保存到名为 的文件中my-dprintf-breakpoints：

::

    (gdb) save breakpoints my-dprintf-breakpoints
    Saved to file 'my-dprintf-breakpoints'.

生成的文件包含从会话保存的 GDB 断点命令。因此，该文件my-dprintf-breakpoints包含三行：

::

    dprintf /home/kev/ctests/tree.c:41,"Allocating node for data=%s\n", data
    dprintf /home/kev/ctests/tree.c:47,"Recursing left for %s at node %s\n", data, tree->data
    dprintf /home/kev/ctests/tree.c:49,"Recursing right for %s at node %s\n", data, tree->data

如果在 GDB 会话之间对程序进行了更改，这些命令指定的行号可能不再正确。如果发生这种情况，最直接的解决方法是使用文本编辑器来调整它们。

该my-dprintf-breakpoints文件可以由保存它们的程序员或者调试同一程序的另一个程序员通过以下命令加载到未来的 GDB 会话中source：

::

    (gdb) quit
    $ gdb -q ./tree
    Reading symbols from ./tree...
    (gdb) source my-dprintf-breakpoints
    Dprintf 1 at 0x401281: file tree.c, line 41.
    Dprintf 2 at 0x4012b9: file tree.c, line 47.
    Dprintf 3 at 0x4012de: file tree.c, line 49.

重定向输出
-----------------------------------------------------------

Printf 样式的调试可以生成大量输出。将调试输出发送到文件以供以后分析通常很有用。

默认情况下，动态的输出printf会发送到 GDB 的控制台。此外，默认情况下，
在 GDB 下运行的程序的输出也会发送到控制台，但通过不同的文件描述符。
因此，GDB 和程序的输出通常会混合在一起。但由于使用了不同的文件描述符，
因此可以将 GDB 的输出或程序输出重定向到文件，甚至可以将两者的输出重定向到单独的文件。

将 GDB 的输出记录到文件
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. _GDB手册: https://sourceware.org/gdb/current/onlinedocs/gdb.html/

GDB 提供了许多命令用于将 GDB 的输出保存到文件。我将在这里讨论其中的一些命令；有关更多信息，请参阅 `GDB手册`_。

假设您希望将 GDB 输出日志保存到名为 的日志文件中my-gdb-log。
首先发出命令`set logging file my-gdb-log`，然后发出命令`set logging on`。
稍后，您可以发出命令`set logging off`以停止将 GDB 输出发送到日志文件。使用dprintf之前建立的命令，命令序列如下所示：

::
    
    (gdb) set logging file my-gdb-log
    (gdb) set logging on
    Copying output to my-gdb-log.
    Copying debug output to my-gdb-log.
    (gdb) run
    Starting program: /home/kev/ctests/tree 
    Allocating node for data=dog
    ...
        scorpion
    wolf
    [Inferior 1 (process 321429) exited normally]
    (gdb) set logging off
    Done logging to my-gdb-log.

如示例所示，程序输出和 GDB 的输出仍会发送到控制台。
（该set logging debugredirect on命令可用于将 GDB 的输出仅发送到日志文件。）
但是，只有 GDB 的输出放在 中my-gdb-log，如您通过查看该文件所见：

::

    Starting program: /home/kev/ctests/tree 
    Allocating node for data=dog
    Recursing left for cat at node dog
    ...
    Recursing right for scorpion at node javelina
    Allocating node for data=scorpion
    [Inferior 1 (process 321429) exited normally]

还要注意，日志输出中没有出现任何提示或用户输入的命令。

将程序输出重定向到文件
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

将程序输出重定向到文件的机制很简单；> 重定向运算符与命令一起使用的run方式与大多数 shell 重定向输出的方式大致相同。
下面的示例显示了如何在将程序输出重定向到文件的同时运行程序my-program-output：

::

    (gdb) run >my-program-output
    Starting program: /home/kev/ctests/tree >my-program-output
    Allocating node for data=dog
    ...
    Allocating node for data=scorpion
    [Inferior 1 (process 321813) exited normally]
    (gdb) 

该my-program-output文件现在如下所示：

::

    cat coyote dog gecko javelina scorpion wolf 

    cat
        coyote
    dog
        gecko
        javelina
        scorpion
    wolf

将 dprintf 输出发送到与程序输出相同的文件
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

当将程序输出保存到文件时，你可能希望将dprintf-相关的输出放在同一个文件中，
与程序的其余输出混合在一起。这可以通过让 GDBprintf()从与程序链接的标准 C 库中调用程序的函数来实现。
GDB 的dprintf-style设置用于控制dprintf相关输出发送到哪里。默认dprintf-style设置为gdb；
它导致printf使用 GDB 的内部命令，将输出发送到 GDB 控制台。当dprintf-style设置为 时call，
GDB 将执行所谓的下级函数调用；即，它将调用被调试程序中的函数，在本例中为printf()。
因此，该set dprintf-style call命令导致在命中断点时打印的输出通过从程序内部dprintf调用来执行：printf()

::

    (gdb) set dprintf-style call
    (gdb) run >my-program-output
    Starting program: /home/kev/ctests/tree >my-program-output
    [Inferior 1 (process 322195) exited normally]
    (gdb) 

该my-program-output文件现在dprintf同时包含输出和程序输出：

::

    Allocating node for data=dog
    Recursing left for cat at node dog
    ...
        scorpion
    wolf

GDB 提供了其他命令，可以将dprintf输出发送到不同的文件描述符，
就像使用fprintf()而不是 一样printf()。这些相同的功能还可用于调用程序中定义的 printf 样式的日志记录函数。
有关这些命令的说明，请参阅 `GDB手册`_。

结论
-----------------------------------------------------------

查找本系列的第三篇也是最后一篇文章，它展示了从 GDB 与程序中的函数交互的强大方法，以及如何自动执行 GDB 命令。
