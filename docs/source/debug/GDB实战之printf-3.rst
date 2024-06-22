GDB实战之printf-3
===========================================================

.. note:: 来自 `使用 GDB 进行 Printf 样式的调试，第 2 部分 <https://developers.redhat.com/articles/2021/12/09/printf-style-debugging-using-gdb-part-3>`_
 
欢迎回到本系列，了解如何使用GNU 调试器(GDB) 以类似于在代码中使用 print 语句的方式打印信息。
第一篇文章介绍了如何使用 GDB 进行 printf 样式的调试，第二篇文章介绍了如何保存命令和输出。
最后一篇文章展示了 GDB 与C 和 C++函数交互以及自动化 GDB 行为的强大功能。

调用程序定义的输出例程
-----------------------------------------------------------

我们的示例程序包含一个名为的函数print_tree，它输出构造的树。
假设您希望使用该函数检查每次调用该insert函数时将在其上运行的树。
这可以通过设置断点insert，然后指定每次遇到断点时要执行的 GDB 命令来实现。
但在了解如何做到这一点之前，让我们先看看普通的 GDB 断点是如何工作的。

设置断点
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

可以使用break命令设置断点。我们可以使用它在函数开头设置断点insert，如下所示：

::

    (gdb) break insert
    Breakpoint 1 at 0x40127a: file tree.c, line 40.

如果您回顾第 1 部分的源代码，您会看到第 40 行是该函数的第一个可执行行。
如果您运行该程序，GDB 会在断点处停止，除了 GDB 停止的行之外，还会显示该函数参数的值：

::

    (gdb) run
    Starting program: /home/kev/ctests/tree 

    Breakpoint 1, insert (tree=0x0, data=0x40203f "dog") at tree.c:40
    40      if (tree == NULL)

现在您可以做很多有趣的事情拨打电话，例如通过backtrace命令检查堆栈跟踪，或者使用 GDB 的print命令打印其他值。
但是，我希望演示我们将在下一节中使用的call和continue命令。

调用并继续
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

在以下示例中，我发出continue命令让 GDB 继续执行该断点七次，并在第八次遇到断点时再次停止。
默认情况下，该continue命令会使程序执行到下一个断点。为此命令提供一个数字参数告诉 GDB 继续执行该次数，
而不会在中间断点处停止。命令continue停止后，call命令将调用print_tree()：

::

    (gdb) continue 8
    Will ignore next 7 crossings of breakpoint 1.  Continuing.

    Breakpoint 1, insert (tree=0x4052a0, data=0x402055 "gecko") at tree.c:40
    40      if (tree == NULL)
    (gdb) call print_tree(tree)
    cat
    dog
        javelina
    wolf
    (gdb) 


GDB 的 printf 命令
-----------------------------------------------------------

GDB 还有一个printf命令，我在这里使用了它：

::

    (gdb) printf "tree is %lx and data is %s\n", tree, data
    tree is 4052a0 and data is gecko

GDB 的printf命令会打印到 GDB 的控制台，而不是程序输出。
对于此示例，我们可能会发现printf()从标准 C 库调用程序的函数更有用。
它将打印到程序的输出，这也是程序的函数打印其输出的地方print_tree：

::

    (gdb) call printf("tree is %lx and data is %s\n", tree, data)
    tree is 4052a0 and data is gecko
    $1 = 33
    (gdb) 

此输出与 GDB 的内置printf命令不同，它多打印了一行（$1 = 33）。
这里发生的是 GDB 正在调用printf()来输出预期结果。该printf()函数返回一个整数，表示打印的字符数。
此返回值将打印到 GDB 控制台并保存到值历史记录中。如果要抑制返回值的打印（以及它在值历史记录中的出现），
请将 的返回值转换为printf()，void如下所示：

::

    (gdb) call (void) printf("tree is %lx and data is %s\n", tree, data)
    tree is 4052a0 and data is gecko

将命令附加到断点
-----------------------------------------------------------

现在，我们可以使用 GDB 的命令命令将命令列表附加到先前设置的断点或断点列表。
当未提供断点编号或列表时，commands将命令添加到最近定义的断点。
假设上一节中设置的断点就是这种情况，我们可以使用commands以下命令：

::

    (gdb) commands
    Type commands for breakpoint(s) 1, one per line.
    End with a line saying just "end".
    >silent
    >call (void) printf("Entering insert(tree=%lx, data=%s)\n", tree, data)
    >if (tree != 0)
    >call (void) printf("Tree is...\n")
    >call (void) print_tree(tree)
    >end
    >continue
    >end
    (gdb) 

与断点关联的第一个命令是silent。它告诉 GDB 不要打印在断点处停止时打印的常规消息。

接下来是一个call命令。它调用printf()，打印一条消息，显示已输入该函数以及和 的insert()值。treedata

接下来是if命令。它检查 的值tree是否非零（即非）。如果此条件为真，则执行NULL这两个命令，因为 中有数据。如果没有，则跳过这些命令。该命令终止该命令的命令块。calltreecallendif

接下来是一个continue命令。它使 GDB 恢复执行，直到遇到另一个断点或程序终止。

最后，一个end命令终止附加到断点的命令列表。

设置断点及其相关命令后，运行程序将产生以下输出：

::

    (gdb) run
    The program being debugged has been started already.
    Start it from the beginning? (y or n) y
    Starting program: /home/kev/ctests/tree 
    Entering insert(tree=0, data=dog)
    Entering insert(tree=4056e0, data=cat)
    Tree is...
    dog
    Entering insert(tree=0, data=cat)
    Entering insert(tree=4056e0, data=wolf)
    Tree is...
    cat
    dog
    ...
    Entering insert(tree=405970, data=scorpion)
    Tree is...
    gecko
    javelina
    Entering insert(tree=0, data=scorpion)
    cat coyote dog gecko javelina scorpion wolf 

    cat
        coyote
    dog
        gecko
        javelina
        scorpion
    wolf
    [Inferior 1 (process 326307) exited normally]

保存插入函数断点
-----------------------------------------------------------

让我们使用info breakpoints命令来查看断点insert：

::

    (gdb) info breakpoints 
    Num     Type           Disp Enb Address            What
    1       breakpoint     keep y   0x000000000040127a in insert at tree.c:40
        breakpoint already hit 19 times
            silent
            call (void) printf("Entering insert(tree=%lx, data=%s)\n", tree, data)
            if (tree != 0)
            call (void) printf("Tree is...\n")
            call (void) print_tree(tree)
            end
            continue
    (gdb) 

观察info breakpoints输出结果，可以看到断点被触发的次数。在这个程序中，我们看到insert被调用了 19 次。
虽然这与当前讨论不是特别相关，但知道某个函数被调用了多少次可能对优化或性能分析很有用。

我们将这个断点保存到名为的文件中my-insert-breakpoint：

::

    (gdb) save breakpoints my-insert-breakpoint
    Saved to file 'my-insert-breakpoint'.

该my-insert-breakpoint文件现在包含 GDB 命令，运行时将重新创建insert()断点及其相关命令以供将来的 GDB 会话使用：

::

    break tree.c:insert
    commands
        silent
        call (void) printf("Entering insert(tree=%lx, data=%s)\n", tree, data)
        if (tree != 0)
        call (void) printf("Tree is...\n")
        call (void) print_tree(tree)
        end
        continue
    end

使用 insert 和 dprintf 断点运行程序
-----------------------------------------------------------

我现在有两个保存了断点的文件，一个名为my-dprintf-breakpoints，
另一个名为my-insert-breakpoint。让我们启动 GDB，加载文件中列出的dprintf和命令，
然后运行程序并将输出重定向到：breakpointmy-program-output

::

    $ gdb -q ./tree
    Reading symbols from ./tree...
    (gdb) source my-dprintf-breakpoints
    Dprintf 1 at 0x401281: file tree.c, line 41.
    Dprintf 2 at 0x4012b9: file tree.c, line 47.
    Dprintf 3 at 0x4012de: file tree.c, line 49.
    (gdb) source my-insert-breakpoint
    Breakpoint 4 at 0x40127a: file tree.c, line 40.
    (gdb) set dprintf-style call
    (gdb) run >my-program-output
    Starting program: /home/kev/ctests/tree >my-program-output
    [Inferior 1 (process 327130) exited normally]
    (gdb) quit

请注意，该set dprintf-style call命令尚未自动添加到通过source命令加载的任何一个文件中。
手动将其添加到文件可能更有意义my-dprintf-breakpoints。
或者，可以将其放入另一个文件中 — 我们称之为tree-debugging-commands：

::

    file tree
    source my-dprintf-breakpoints
    source my-insert-breakpoint
    set dprintf-style call

此文件首先通过filetree-debugging-commands命令指定要调试的程序。
在前面的示例中，我们通过在命令行中提及它来加载它；但是，在这里，我们没有在命令行中列出它，
而是通过命令来加载它。treegdbfile

tree-debugging-commands现在您应该已经熟悉了中的其余命令。
my-dprintf-breakpoints和my-insert-breakpoints文件中包含的命令将被执行，
然后执行 命令set dprintf-style call。 
回想一下，此命令会导致断点在正在调试的程序中dprintf调用（而不是使用 GDB 的内部命令）。printf()printf

有了该文件，我们可以按如下方式运行 GDB：

::

    $ gdb -q -x tree-debugging-commands
    Dprintf 1 at 0x401281: file tree.c, line 41.
    Dprintf 2 at 0x4012b9: file tree.c, line 47.
    Dprintf 3 at 0x4012de: file tree.c, line 49.
    Breakpoint 4 at 0x40127a: file tree.c, line 40.
    (gdb) run >my-program-output
    Starting program: /home/kev/ctests/tree >my-program-output
    [Inferior 1 (process 351102) exited normally]
    (gdb) quit

其他命令
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

通过使用以下命令也可以实现相同的效果，但无需与 GDB 交互：

::

    $ gdb -q -x tree-debugging-commands -ex 'run >my-program-output' -ex quit

如本系列第 1 部分所述，-q选项 会在 GDB 启动时隐藏 GDB 横幅、版权和帮助信息。
-x 在本例中，选项 使 GDB 加载并执行文件 中的命令tree-debugging-commands。
-ex选项 使选项后面的命令运行。因此，在本例中，在加载并运行 中的命令后，会从第一个选项发出tree-debugging-commands一个命令；
此外，运行的输出会重定向到文件。第二个选项后面的命令是；这会导致 GDB 退出而不显示提示。run-exmy-program-output-exquit

run和命令quit也可以放在命令文件中tree-debugging-commands。如果这样做，命令行将缩短为如下所示：

::

    $ gdb -q -x tree-debugging-commands

修复了 dprintf 断点的错误
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

在撰写本文时，我发现GDB 中有一个错误dprintf，当从命令行或 GDB 脚本中运行程序时，
该错误会导致断点（基本上）被禁用。上游 GDB 源代码已修复此错误。在 Fedora Linux 上（及更高版本）包含此修复程序。
如果您使用的 GDB 版本没有此修复程序，则需要从 GDB 提示符gdb-11.1-5发出命令。run

使用 GDB 进行进一步了解
-----------------------------------------------------------

我希望本系列文章对那些熟悉使用 print 语句调试代码但之前对 GDB 知之甚少或一无所知的开发人员有所帮助。
我还希望它能激发您使用 GDB 做更多事情的兴趣。

本文演示了如何设置断点并运行直到断点被触发，这是 GDB 的一种非常常见的用法。
一旦 GDB 在断点处停止，您就可以输入各种 GDB 命令来了解有关该点处程序状态的更多信息。
如果您想进一步了解 GDB 命令，我建议您使用以下命令：

* GDB 开发人员的 GNU 调试器教程，第 1 部分是使用 GNU 调试器进行调试的一般指南。
* GDB 手册 `《使用 GDB 进行调试》 <https://sourceware.org/gdb/current/onlinedocs/gdb.html/>`_ 是使用 GDB 的权威参考。
