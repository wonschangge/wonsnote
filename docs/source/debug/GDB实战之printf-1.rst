GDB实战之printf-1
===========================================================

.. note:: 来自 `使用 GDB 进行 Printf 样式的调试，第 1 部分 <https://developers.redhat.com/articles/2021/10/05/printf-style-debugging-using-gdb-part-1#>`_

程序员经常通过在源代码中添加打印语句来调试软件。知道程序已经到达某个点会非常有帮助。
在程序执行期间的不同点打印变量的值也很有用。这种技术的一个明显缺点是需要更改源代码，
既要添加打印语句，又要在修复错误后删除或禁用它们。添加新代码可能会引入新的错误，
如果您添加了许多打印语句，您可能会在调试后清理时忘记删除其中一些。

您可以使用流行的GNU 项目调试器(GDB) 对各种编程语言（尤其是C 和 C++）执行相同风格的调试，
而无需更改源文件。本文是介绍如何使用 GDB 向 C 和 C++ 代码添加打印语句的系列文章中的第一篇。
我们将从一些基础知识开始，然后介绍更高级的方法来调用显示数据的程序定义函数。

先决条件
-----------------------------------------------------------

要使用本文描述的技术，您需要满足以下先决条件：

* 您的开发机器上必须安装 C/C++ 编译器，例如GCC或Clang 。
* 同样，您需要在开发机器上安装 GDB。
* 需要调试的程序需要编译时带有调试信息。使用gcc或clang命令时，请添加-g启用调试信息的选项。
* 该程序（或者至少是您希望使用 GDBdprintf命令的源文件）应该在未优化的情况下进行编译。

关于最后一点，您可以通过从编译器标志集（例如，或）中删除任何现有的-O、-等选项，或者通过添加或作为最后一个优化选项来禁用优化。当您在不指定任何优化选项的情况下运行时，将用作默认值。当使用大量选项编译程序时，可能更容易将或附加到编译器选项列表中，因为最终优化选项将覆盖任何先前的优化选项。选项与选项略有不同，因为后者启用了一些不会影响调试体验的优化，而禁用所有优化。O2CFLAGSCXXFLAGS-O0-Oggcc-O0-O0-Og-O0-Og-O0

还要注意，后两点可能要求您在启用调试选项并禁用优化的情况下重新编译和重新链接程序。

这里介绍的技术可能也适用于某些优化代码。近年来，gcc使用时，优化代码的调试信息质量已大大提高；
但是，仍然存在变量值不可用甚至可能不正确的情况。程序员可以通过禁用优化来避免这些问题。

示例代码
-----------------------------------------------------------

本文演示了如何使用 GDB 为名为 的小函数添加 printf 样式的输出insert。
该函数来自我为教学目的编写的一个小程序。该程序长度略超过 100 行，包含在名为tree.c的单个源文件中，
可从我的 `GitHub 存储库 <https://github.com/KevinBuettner/tree.c>`_ 获得。

以下insert函数将节点插入二叉搜索树。请注意行号，我们将在本文后面使用它们：

::

    37      struct node *
    38      insert (struct node *tree, char *data)
    39      {
    40        if (tree == NULL)
    41          return alloc_node (NULL, NULL, data);
    42        else
    43          {
    44            int cmp = strcmp (tree->data, data);
    45     
    46            if (cmp > 0)
    47              tree->left = insert (tree->left, data);
    48            else if (cmp < 0)
    49              tree->right = insert (tree->right, data);
    50            return tree;
    51          }
    52      }

该main函数包含对函数的调用insert以及对用于打印树的函数的额外调用。请注意此处的行号：

::

    96    struct node *tree = NULL;
    97     
    98    tree = insert (tree, "dog");
    99    tree = insert (tree, "cat");
    100   tree = insert (tree, "wolf");
    101   tree = insert (tree, "javelina");
    102   tree = insert (tree, "gecko");
    103   tree = insert (tree, "coyote");
    104   tree = insert (tree, "scorpion");
    105   
    106   print_tree_flat (tree);
    107   printf ("\n");
    108   print_tree (tree);

我使用以下命令进行了编译以供 GDB 使用：

::

    $ gcc -o tree -g tree.c

该-g选项将调试信息放在二进制文件中。此外，程序的编译不带优化。

使用 GDB 进行 printf 样式的输出
-----------------------------------------------------------

使用系统上正确编译的二进制文件，您可以在 GDB 中模拟打印语句。

使用 GDB 进行调试
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

我们可以使用gdb命令来调试示例程序：

::

    $ gdb ./tree

此命令首先打印版权信息以及法律和帮助信息。如果您希望不显示该输出，请-q向命令行添加该选项。使用此选项gdb时，输出应如下所示：-q

::
    
    $ gdb -q ./tree
    Reading symbols from ./tree...
    (gdb) 

如果您还看到消息(No debugging symbols found in ./tree)，则意味着您在程序编译和链接期间没有启用调试信息的生成。 
如果是这种情况，请使用 GDB 的quit命令退出 GDB，然后通过使用选项重新编译来解决问题-g。

虚拟打印报表
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

现在，我们将使用 GDB 的 `dprintf 命令放置一种特殊的断点`，以模拟在源代码中添加类似的printf()语句。我们将在第 41、47 和 49 行放置虚拟打印语句：

::

    (gdb) dprintf 41,"Allocating node for data=%s\n", data
    Dprintf 1 at 0x401281: file tree.c, line 41.
    (gdb) dprintf 47,"Recursing left for %s at node %s\n", data, tree->data
    Dprintf 2 at 0x4012b9: file tree.c, line 47.
    (gdb) dprintf 49,"Recursing right for %s at node %s\n", data, tree->data
    Dprintf 3 at 0x4012de: file tree.c, line 49.
    (gdb) 

dprintf显示的第一条命令41大致相当于在第 40 行和第 41 行附近添加三行代码：

::

    if (tree == NULL)
    { /* DEBUG - delete later.  */
        printf ("Allocating node for data=%s\n", data); /* DEBUG - delete later. */
        return alloc_node (NULL, NULL, data);
    } /* DEBUG - delete later.  */

请注意，以传统方式添加对printf()的调用时，需要在此特定位置添加三行代码。
（如果添加printf()不带花括号的 ，则该if语句将仅执行printf()，
并且return alloc_node语句将不再有条件地执行 - 相反，它将始终执行。）

正如注释所示，您需要在调试完成后删除这些添加的行（尽管添加的括号实际上可以保留）。
如果您在代码中添加了大量调试语句，则可能会在调试完成后忘记删除其中一些。
如前所述，这是使用 GDB dprintf命令的一个明显优势：无需修改源代码，
因此添加打印语句时不会引入细微的错误；调试后清理时也无需记住添加打印语句的所有位置。

运行程序
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

使用 GDB 的run命令来运行你的程序。一旦发出命令，GDB 输出和程序输出就会混合出现在用于 GDB 会话的终端中。以下是运行我们的树程序的示例：

::

    (gdb) run
    Starting program: /home/kev/ctests/tree 
    Allocating node for data=dog
    Recursing left for cat at node dog
    Allocating node for data=cat
    Recursing right for wolf at node dog
    Allocating node for data=wolf
    Recursing right for javelina at node dog
    Recursing left for javelina at node wolf
    Allocating node for data=javelina
    Recursing right for gecko at node dog
    Recursing left for gecko at node wolf
    Recursing left for gecko at node javelina
    Allocating node for data=gecko
    Recursing left for coyote at node dog
    Recursing right for coyote at node cat
    Allocating node for data=coyote
    Recursing right for scorpion at node dog
    Recursing left for scorpion at node wolf
    Recursing right for scorpion at node javelina
    Allocating node for data=scorpion
    cat coyote dog gecko javelina scorpion wolf 

    cat
        coyote
    dog
        gecko
        javelina
        scorpion
    wolf
    [Inferior 1 (process 306927) exited normally]
    (gdb) 


在此显示中，用户run在提示符下输入了命令(gdb)。其余行来自 GDB 或程序。唯一的程序输出出现在末尾，以“cat coyote dog...”行开始，以“wolf”行结束。以“Recursing”或“Allocating”开头的行由dprintf先前建立的命令输出。重要的是要了解，默认情况下，这些行是由 GDB 输出的。这与传统的 printf 样式调试不同，我们将在本系列的下一篇文章中讨论这种差异。最后，有两行 GDB 输出，第二行和倒数第二行，显示程序正在启动和退出。

比较 dprintf 和 printf()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

dprintf GDB的命令与C语言函数有区别和相同之处printf()：

* 该dprintf命令不使用括号来对命令的参数进行分组。
* 该命令的第一个参数指定应放置dprintf动态语句的源位置。
  动态的输出在执行该源位置之前打印。源位置可能是行号，例如，但位置通常包括文件名和行号，
  例如。位置也可以是程序中的函数名称或指令地址。
  对于函数位置，动态的输出发生在函数的第一个可执行行之前。
  当位置是指令地址时，输出发生在执行该地址处的指令之前。printfprintf41tree.c:41printf
* 该dprintf命令会创建一种特殊的断点。只有当程序运行期间遇到这些特殊断点之一时，才会打印输出。
* dprintf使用的格式字符串与printf()使用的格式字符串相同。
  事实上，正如我们稍后会看到的，命令中指定的格式字符串可能会传递给正在调试的程序中dprintf动态构造的printf()调用。
* 在dprintf和printf()中，逗号分隔的表达式跟在格式字符串后面。这些表达式根据格式字符串提供的规范进行评估和输出。

结论
-----------------------------------------------------------

本文介绍了 GDB 中 printf 样式调试的基础知识。
本系列的下一篇文章将带您进入更高级别的调试控制，
向您展示如何保存dprintf命令和 GDB 输出以供日后使用。
