构建OpenWrt系统基础知识
===========================================================

简介
-----------------------------------------------------------

.. _镜像生成器: https://openwrt.org/docs/guide-user/additional-software/imagebuilder

构建系统用于从源代码构建OpenWrt，需要大量的硬件资源、时间和知识。 
您可以应用自定义补丁，并使用特定的编译标志和选项构建单个软件包和OpenWrt镜像。 
作为替代方案，您可以使用 `镜像生成器`_ 以更快、更简单的方式构建OpenWrt镜像，但定制性有限。

先决条件
-----------------------------------------------------------

构建系统基于buildroot，需要具有区分大小写的文件系统的GNU/Linux环境。 
这可以通过运行本机或虚拟化的Linux发行版（如VirtualBox、VMware、QEMU等）来实现。 
一些用户也在WSL和macOS上有积极的使用经验，但这些系统不受官方支持。 
要生成一个可刷写的固件镜像文件并包含默认软件包，您至少需要10-15 GB的可用磁盘空间（最好更多），
以及至少2 GB的RAM用于编译阶段。 编译x86镜像需要4 GB的RAM。 
进行额外的优化，如启用LTO编译标志，也会增加构建过程中的RAM消耗。

您在镜像中添加的附加软件包越多，所需的空间就越多，但空间需求应该会缓慢增加，
大部分存储需求是用于构建基础设施和固件镜像的核心组件。

请注意，这些数字仅为粗略估计，您可能在某些设备上可以使用更少的资源，但不能保证。

描述
-----------------------------------------------------------

构建系统是一组Makefiles和补丁，它自动化了构建交叉编译的工具链的过程，然后使用该工具链构建Linux内核、
根文件系统和可能需要的其他软件（如uboot），以在特定设备上运行OpenWrt。 典型的工具链包括：

* 编译器，如 gcc
* 二进制实用工具，用作汇编和链接，如 binutils
* C标准库，如 glibc, musl, uClibc 或 dietlibc

通常，工具链会为与其运行在同一指令集架构（ISA）上的代码生成器生成代码（例如大多数个人电脑和服务器上的x86_64）。 
然而，在OpenWrt中，情况并非如此。 大多数路由器使用的处理器与我们用于运行构建系统的处理器架构不同。 
如果我们使用构建系统的工具链为我们的路由器构建OpenWrt，它将生成在我们的路由器上无法运行的代码。 
不能使用主机系统的任何内容。 包括C标准库、Linux内核和所有用户空间程序在内的所有内容都必须使用这个交叉编译工具链进行编译。

让我们来看一个例子。 我们在一个x86_64系统上为一个使用MIPS32架构的路由器构建OpenWrt，
因此我们不能使用用于在x86_64系统上运行的相同工具链。 我们需要首先为MIPS32系统构建一个工具链，
然后使用该工具链构建运行OpenWrt所需的所有内容。

创建交叉编译器的过程可能会很棘手。 这不是经常尝试的事情，因此它有一定的神秘和黑魔法。 当您处理嵌入式设备时，
通常会提供一个编译器和基本库的二进制副本，而不是提供创建自己的指令 - 这是一个节省时间的步骤，
但同时通常意味着您将使用一个相当陈旧的工具集。 通常还会提供来自板卡或芯片供应商的补丁过的Linux内核副本，
但这也是过时的，很难准确地发现为使内核在嵌入式平台上运行而进行了哪些更改。

虽然可以手动创建工具链，然后使用它构建OpenWrt，但这很困难且容易出错。 
OpenWrt构建系统采用了一种不同的方法来构建固件：它从头开始下载、打补丁和编译所有内容，包括交叉编译器。 
或者用更简单的话说，OpenWrt的构建系统不包含任何可执行文件甚至源代码。 它是一个自动化系统，用于下载源代码，
将其打补丁以适应给定的平台，并正确地为该平台编译它们。 这意味着只需更改模板，就可以更改流程中的任何步骤。 
当然，这样做的附带好处是构建是自动化的，节省时间，并且每次都能保证相同的结果。

例如，如果发布了一个新的内核，只需更改一个Makefile，就可以下载最新的内核，对其进行打补丁以在请求的平台上运行，
并生成一个新的固件镜像。 不需要费力去追踪未修改的现有内核副本以查看进行了哪些更改 - 补丁已经提供，该过程几乎完全透明。 
这不仅适用于内核，还适用于OpenWrt中包含的任何内容 - 正是这种策略使得OpenWrt能够始终使用最新的编译器、内核和应用程序。

目录结构
-----------------------------------------------------------

构建系统中有四个关键目录：

* tools - 包含构建工具链和软件包所需的各种实用程序（例如autoconf automake），
   或用于镜像生成的实用程序（例如mkimage，squashfs）。其中一些实用程序也可以安装在主机系统中，
   但我们将它们包含在OpenWrt源代码中，这样我们就不必担心在各种Linux发行版中使用不同版本会导致故障，
   或者为了支持在macOS上构建。

* toolchain - 指的是编译器、C库和用于构建固件镜像的常用工具。其结果是两个新目录，
  toolchain_build_<arch>是用于为特定架构构建工具链的临时目录，
  而staging_dir_<arch>则是安装生成的工具链的目录。除非您打算添加上述组件的新版本，
  否则不需要对toolchain目录进行任何操作。

* target - 指的是嵌入式平台，其中包含特定于特定嵌入式平台的项目。特别值得关注的是target/linux目录，
  它按平台进行了细分，并包含特定平台的内核配置和内核补丁。还有target/image目录，描述了如何为特定平台打包固件。

* package - 这个目录就是用来存放软件包的。在OpenWrt固件中，几乎所有的东西都是ipk格式的软件包，
  可以将其添加到固件中以提供新功能，或者删除以节省空间。

* dl - 由工具链、目标或软件包步骤下载的任何内容都将放置在此目录中。

target 和 package包步骤都将使用build_<arch>目录作为编译的临时目录。

build_dir和staging_dir之间的区别
-----------------------------------------------------------

build_dir目录用于存放解压后的源代码和编译过程中生成的临时文件。
在构建过程中，所有的编译工作都在build_dir目录中进行。

staging_dir目录用于存放编译后的程序和库文件，这些文件将被安装到staging_dir目录中，
以备后续构建其他软件包或准备固件镜像时使用。staging_dir目录中的文件是构建系统生成的最终结果，
可以被用于构建固件镜像或其他目标设备上的应用程序。

在build_dir下有三个区域：:

* build_dir/host：这个目录用于存放主机工具链和与主机平台相关的构建工具和库文件。

* build_dir/toolchain-<arch>：这个目录用于存放交叉编译工具链和与目标平台相关的构建工具和库文件。

* build_dir/target-<arch>：这个目录用于存放在目标平台上编译的软件包和库文件。这些文件在构建过程中生成，并最终被安装到staging_dir目录中。

在staging目录下，也有三个区域：

* staging_dir/host是一个带有自己的bin/、lib/等目录的迷你Linux根目录，用于安装主机工具。构建系统会将其路径前缀添加到PATH中的其他目录中。

* staging_dir/toolchain...是一个带有自己的bin/、lib/等目录的迷你Linux根目录，其中包含用于构建其余固件的交叉C编译器。实际上，您可以使用它来编译OpenWrt之外的简单C程序，然后将其加载到固件中。C编译器的路径可能类似于：staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin/mips-openwrt-linux-uclibc-gcc。您可以看到CPU、C库和gcc的版本编码在其中；这允许在同一区域同时构建多个目标。

* staging_dir/target.../root-...包含每个目标软件包的“已安装”版本，同样按照bin/、lib/等方式进行排列。这将成为实际的根目录，稍作调整后将被压缩为固件镜像，例如root-ar71xx。staging_dir/target...中还有一些其他文件，主要用于生成软件包和开发包等。

特点
-----------------------------------------------------------

* 简化软件移植的过程

* 使用kconfig（Linux内核menuconfig）来配置功能

* 提供集成的交叉编译工具链（gcc、ld等）

* 提供对autotools（automake、autoconf）、cmake、scons的抽象支持
  
* 处理标准的下载、打补丁、配置、编译和打包工作流程

* 提供一些常见的修复方法，用于处理行为不良的软件包

Make目标
-----------------------------------------------------------

提供一些高级的make目标，用于标准的软件包工作流程

目标的格式始终为component/name/action，例如toolchain/gdb/compile或package/mtd/install

准备软件包源代码树：package/foo/prepare

编译软件包：package/foo/compile

清理软件包：package/foo/clean

构建顺序
-----------------------------------------------------------

1. tools – automake、autoconf、sed、cmake等工具
2. toolchain/binutils – as、ld等工具
3. toolchain/gcc – gcc、g++、cpp等工具
4. target/linux – 内核模块
5. package – 核心和feed软件包
6. target/linux – 内核镜像
7. target/linux/image – 固件镜像文件生成

补丁管理
-----------------------------------------------------------

.. _quilt: https://en.wikipedia.org/wiki/Quilt%20(software)

许多软件包在目标平台上无法正常工作，需要进行补丁处理才能工作或者甚至编译

构建系统集成了 `quilt`_ ，用于简化补丁管理

将软件包补丁转换为quilt系列：make package/foo/prepare QUILT=1

从修改后的系列中更新补丁：make package/foo/update

在更新后自动重新基于补丁：make package/foo/refresh

打包考虑事项
-----------------------------------------------------------

主要目标是占用小的内存和存储空间

在嵌入式系统上没有意义的功能通过配置或补丁禁用

软件包必须在不考虑主机系统的情况下兼容，它们应该是自包含的

提供的“configure”脚本通常存在问题，在交叉编译环境中无法使用，通常需要进行autoreconf或打补丁

构建变体和kconfig包含允许进行可配置的编译时设置

没有标准的软件移植方式，在许多情况下，软件包可以直接工作，但通常需要对软件包构建过程进行调整

参考资料
-----------------------------------------------------------

`OpenWrt论坛：OpenWrt Buildroot简介 <https://forum.openwrt.org/viewtopic.php?pid=31794#p31794>`_