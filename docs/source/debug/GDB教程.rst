GDB实战之printf-3
===========================================================

.. note:: 来自 `GDB 开发人员的 GNU 调试器教程，第 1 部分：开始使用调试器 <https://developers.redhat.com/articles/the-gdb-developers-gnu-debugger-tutorial-part-1-getting-started-with-the-debugger>`_

本文是系列文章的第一篇，该系列文章演示了如何有效地使用GNU 调试器 (GDB)来调试C 和 C++应用程序。
如果您使用 GDB 的经验有限或没有经验，本系列将教您如何更有效地调试代码。
如果您已经是使用 GDB 的经验丰富的专业人士，也许您会发现一些以前从未见过的东西。

除了为许多 GDB 命令提供开发人员提示和技巧之外，未来的文章还将涵盖调试优化代码、离线调试（核心文件）
和基于服务器的会话（又名 gdbserver，用于容器调试）等主题。

为什么需要另一个 GDB 教程？
-----------------------------------------------------------

网络上的大多数 GDB 教程仅包含对基本list、break、print和run命令的介绍。新 GDB 用户不妨阅读（或唱）官方 GDB 之歌！

本系列的每一篇文章都不会简单地演示一些有用的命令，而是从 GDB 开发人员的角度来重点介绍使用 GDB 的一个方面。
我每天都会使用 GDB，这些技巧和窍门是我（以及许多其他高级 GDB 用户和开发人员）用来简化调试会话的技巧和窍门。

因为这是本系列的第一篇文章，所以请允许我遵循 GDB Song 的建议，从最开始开始：如何运行 GDB。

编译器选项
-----------------------------------------------------------

让我把（通常不太明显的）事情说清楚：为了获得最佳调试体验，请在构建应用程序时不要进行优化，而要提供调试信息。
这是微不足道的建议，但 GDB 的公共 freenode.net IRC 频道 (#gdb) 经常看到这些问题，值得一提。

TL;DR：如果可以避免，请不要调试带有优化的应用程序。请关注未来有关优化的文章。

如果您不了解“幕后”可能发生的事情，优化可能会导致 GDB 以令人惊奇的方式运行。
在开发周期中，我总是使用 C 编译器选项-O0（字母O后跟数字零）来构建可执行文件。

我还总是让工具链发出调试信息。这是通过选项实现的-g。指定确切的调试格式不再是必要的（或理想的）；
多年来，DWARF 一直是 GNU/Linux 上的默认调试信息格式。因此，请忽略使用-ggdb或 的建议-gdwarf-2。

值得添加的一个特定选项是-g3，它告诉编译器包含有关#define FOO ...应用程序中使用的宏 ( ) 的调试信息。
然后这些宏可以在 GDB 中像程序中的任何其他符号一样使用。

简而言之，为了获得最佳调试体验，请-g3 -O0在编译代码时使用。某些环境（例如使用 GNU autotools 的环境）
设置了控制编译器输出的环境变量（CFLAGS和CXXFLAGS）。检查这些标志以确保您对编译器的调用启用了所需的调试环境。

有关调试体验的影响的更多信息，请参阅 Alexander Oliva 的论文-g《GCC gOlogy：研究优化对调试的影响》。-O

启动脚本
-----------------------------------------------------------

在实际使用 GDB 之前，必须先了解一下 GDB 的启动方式以及它执行的脚本文件。
启动后，GDB 将执行包含在多个系统和用户脚本文件中的命令。这些文件的位置和执行顺序如下：

1. /etc/gdbinit（FSF GNU GDB 上没有）：在许多 GNU/Linux 发行版中，
   包括 Fedora 和Red Hat Enterprise Linux，GDB 首先查找系统默认初始化文件并执行其中包含的命令。
   在基于 Red Hat 的系统上，此文件执行安装在 中的任何脚本文件（包括Python脚本）/etc/gdbinit.d。
2. $HOME/.gdbinit：如果此文件存在，GDB 将从主目录读取用户的全局初始化脚本。
3. ./.gdbinit：最后，GDB 将在当前目录中查找启动脚本。可以将其视为特定于应用程序的自定义文件，
   您可以在其中添加每个项目的用户定义命令、漂亮的打印机和其他自定义设置。

所有这些启动文件都包含要执行的 GDB 命令，但它们也可能包含 Python 脚本，
只要它们以命令开头python，例如python print('Hello from python!')。

我的.gdbinit其实很简单。它最重要的几行启用了命令历史记录，以便 GDB 记住上一个会话中执行的一定数量的命令。
这类似于 shell 的历史记录机制和.bash_history。整个文件如下：

::

    set pagination off
    set history save on
    set history expansion on

第一行关闭 GDB 的内置分页。下一行启用保存历史记录（~/.gdb_history默认情况下），
最后一行启用使用感叹号 (!) 字符的 shell 样式历史记录扩展。此选项通常被禁用，因为感叹号在 C 中也是一个逻辑运算符。

为了防止 GDB 读取初始化文件，请给它提供--nx命令行选项。

在 GDB 中获取帮助
-----------------------------------------------------------

有几种方法可以获得使用 GDB 的帮助，包括大量（虽然枯燥）的 `文档 <https://sourceware.org/gdb/documentation/>`_，
解释每个小开关、旋钮和功能。

GDB 社区资源
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

社区在两个地方为用户提供帮助：

* 通过电子邮件： `GDB 邮件列表 <https://sourceware.org/mailman/listinfo/gdb/>`_
* 通过 IRC： `libera.chat <https://libera.chat/>`_ 上的 #gdb

但是，由于本文是关于使用GDB 的，因此用户获取命令帮助的最简单方法是使用 GDB 的内置帮助系统（接下来讨论）。

访问帮助系统
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

help通过和命令访问 GDB 的内置帮助系统apropos。不知道如何使用printf命令？询问 GDB：

::

    (gdb) help printf
    Formatted printing, like the C "printf" function.
    Usage: printf "format string", ARG1, ARG2, ARG3, ..., ARGN
    This supports most C printf format specifications, like %s, %d, etc.
    (gdb)

help接受任何 GDB 命令或选项的名称并输出该命令或选项的使用信息。

与所有 GDB 命令一样，该help命令支持 Tab 补全。这也许是找出许多命令接受哪些类型的参数的最有用方法。
例如，输入help show ar并按下 Tab 键将提示您完成：

::

    (gdb) help show ar
    architecture   args         arm
    (gdb) help show ar

GDB 让你在命令提示符下准备好接受进一步的输入细化。g在命令中添加，然后按 Tab 键，将完成为help show args：

::

    (gdb) help show args
    Show argument list to give program being debugged when it is started.
    Follow this command with any number of args, to be passed to the program.
    (gdb)

不知道您要查找的命令的确切名称？使用该apropos命令在帮助系统中搜索特定术语。可以将其视为 grepping 内置帮助。

现在您知道了如何以及在何处寻求帮助，我们已经准备好启动 GDB（终于）。

启动 GDB
-----------------------------------------------------------

毫不奇怪，GDB 接受大量命令行选项来改变其行为，但启动 GDB 的最基本方法是在命令行上将应用程序的名称传递给 GDB：

::

    $ gdb myprogram
    GNU gdb (GDB) Red Hat Enterprise Linux 9.2-2.el8
    Copyright (C) 2020 Free Software Foundation, Inc.
    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.
    Type "show copying" and "show warranty" for details.
    This GDB was configured as "x86_64-pc-linux-gnu".
    Type "show configuration" for configuration details.
    For bug reporting instructions, please see:
    <https://www.gnu.org/software/gdb/bugs/>.
    Find the GDB manual and other documentation resources online at:
        <http://www.gnu.org/software/gdb/documentation/>.

    For help, type "help".
    Type "apropos word" to search for commands related to "word"...
    Reading symbols from /home/blog/myprogram...
    (gdb) 

GDB 启动后，打印出一些版本信息（图中显示 GCC Toolset 10），加载程序及其调试信息，并显示版权和帮助信息，
最后显示命令提示符。GDB(gdb)现在可以接受输入了。

避免消息：-q 或 --quiet 选项
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

我已经看过 GDB 的启动消息数千次了，因此我使用以下选项来抑制（或“静音”）它-q：

::

    $ gdb -q myprogram
    Reading symbols from /home/blog/myprogram...
    (gdb) 

阅读起来就少多了。如果你真的是 GDB 新手，你可能会发现完整的启动消息很有用或令人安心，
但过了一段时间，你也会gdb在 shell 中使用别名gdb -q。
如果你确实需要隐藏的信息，请使用-v命令行选项或show version命令。

传递参数：--args 选项
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

程序通常需要命令行参数。GDB 提供了多种方式将这些参数传递给您的程序（或用 GDB 术语来说为“次要”）。
最有用的两种方法是通过命令run或在启动时通过--args命令行选项传递应用程序参数。
如果您的应用程序通常以 启动myprogram 1 2 3 4，则只需在其前面加上gdb -q --args，GDB 就会记住您的应用程序应如何运行：

::

    $ gdb -q --args myprogram 1 2 3 4
    Reading symbols from /home/blog/myprogram...
    (gdb) show args
    Argument list to give program being debugged when it is started is "1 2 3 4".
    (gdb) run
    Starting program: /home/blog/myprogram 1 2 3 4
    [Inferior 1 (process 1596525) exited normally]
    $

附加到正在运行的进程：--pid 选项
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

如果某个应用程序已在运行但“卡住了”，您可能需要查看内部以找出原因。只需使用以下命令向 GDB 提供应用程序的进程 ID --pid：

::

    $ sleep 100000 &
    [1] 1591979
    $ gdb -q --pid 1591979
    Attaching to process 1591979
    Reading symbols from /usr/bin/sleep...
    Reading symbols from .gnu_debugdata for /usr/bin/sleep...
    (No debugging symbols found in .gnu_debugdata for /usr/bin/sleep)
    Reading symbols from /lib64/libc.so.6...
    Reading symbols from /usr/lib/debug/usr/lib64/libc-2.31.so.debug...
    Reading symbols from /lib64/ld-linux-x86-64.so.2...
    Reading symbols from /usr/lib/debug/usr/lib64/ld-2.31.so.debug...
    0x00007fc421d5ef98 in __GI___clock_nanosleep (requested_time=requested_time@entry=0, remaining=remaining@entry=0x0)
        at ../sysdeps/unix/sysv/linux/clock_nanosleep.c:28
    28	  return SYSCALL_CANCEL (nanosleep, requested_time, remaining)
    (gdb) 

使用此选项，GDB 会自动加载具有构建 ID 信息的程序（例如发行版提供的软件包）的符号，并中断程序以便您与其交互。
在以后的文章中查找有关 GDB 如何以及在何处查找调试信息的更多信息。

跟进失败：--core 选项
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

如果您的进程中止并转储了核心，请使用该--core选项告诉 GDB 加载核心文件。
如果核心文件包含中止进程的构建 ID，GDB 会自动加载该二进制文件及其调试信息（如果可以）。
但是，大多数开发人员需要使用此选项将可执行文件传递给 GDB：

::

    $ ./abort-me
    Aborted (core dumped)
    $ gdb -q abort-me --core core.2127239
    Reading symbols from abort-me...
    [New LWP 2127239]
    Core was generated by `./abort-me'.
    Program terminated with signal SIGABRT, Aborted.
    #0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:50
    50	  return ret;
    (gdb)

提示：找不到核心文件？在使用 systemd 的 GNU/Linux 系统上，检查ulimit -cshell 是否阻止程序创建核心文件。
如果值为unlimited，则使用coredumpctl查找核心文件。或者，运行sysctl -w kernel.core_pattern=core配置 systemd 以输出名为 的核心文件core.PID，就像我在上一个示例中所做的那样。

加速命令执行：--ex、--iex、--x 和 --batch 选项
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

我经常从 shell 反复运行 GDB 命令来测试问题或运行脚本。这些命令行选项有助于实现这一点。
大多数用户将使用（多个）--ex参数来指定在启动时运行的命令以重新创建调试会话，
例如。gdb -ex "break some_function if arg1 == nullptr" -ex r myprogram

* --ex CMDCMD在程序（和调试信息）加载后运行 GDB 命令。--iex执行相同操作，但在加载指定程序CMD之前执行。
* -x FILEFILE在程序加载并执行命令后执行 GDB 命令--ex。如果我需要大量--ex参数来重现特定的调试会话，我最常使用此选项。
* --batch导致 GDB 在第一个命令提示符下立即退出；即，在所有命令或脚本运行完毕后。请注意，这--batch将使更多的输出静音，而不是-q方便在脚本中使用 GDB：

::

    $ # All commands complete without error
    $ gdb -batch -x hello.gdb myprogram
    Reading symbols from myprogram...
    hello
    $ echo $?
    0
    $ # Command raises an exception
    $ gdb -batch -ex "set foo bar"
    No symbol "foo" in current context.
    $ echo $?
    1
    $ # Demonstrate the order of script execution
    $ gdb -x hello.gdb -iex 'echo before\n' -ex 'echo after\n' simple
    GNU gdb (GDB) Red Hat Enterprise Linux 9.2-2.el8
    Copyright (C) 2020 Free Software Foundation, Inc.
    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.
    Type "show copying" and "show warranty" for details.
    This GDB was configured as "x86_64-redhat-linux-gnu".
    Type "show configuration" for configuration details.
    For bug reporting instructions, please see:
    <https://www.gnu.org/software/gdb/bugs/>.
    Find the GDB manual and other documentation resources online at:
        <http://www.gnu.org/software/gdb/documentation/>.

    For help, type "help".
    Type "apropos word" to search for commands related to "word"...
    before
    Reading symbols from simple...
    hello
    after
    (gdb) 

接下来
-----------------------------------------------------------

在本文中，我分享了有关 GDB 如何启动、读取脚本（以及何时读取脚本）以及高级 GDB 用户常用的几个启动选项的详细信息。

本系列的下一篇文章将稍微绕道来解释什么是调试信息、如何检查它、GDB 在哪里查找它以及如何在发行版提供的软件包中安装它。

您有与 GDB 脚本或启动相关的建议或提示，或者有关如何使用 GDB 的未来主题的建议吗？请对本文发表评论并与我们分享您的想法。
