Linux编译Windows应用
=========================

现有 Linux 上开发的 Rust 通信库一份，需将其分享给 Windows 上的一个示例应用使用。

可行的路线有：

1. 交叉编译分享静态库 .a 给 windows，windows 拿到后在 MinGW 环境下，补全所需链接的 windows 平台的静态库，编译。

    Cargo.toml中指定静态库：

    ::

        [lib]
        name = "rust"
        #crate-type = ["staticlib", "cdylib"] # musl only support staticlib
        crate-type = ["staticlib"] # musl only support staticlib

    编译：

    ::
        
        cargo build --release --target x86_64-pc-windows-gnu


2. 交叉编译分享动态库 .dll 给 windows。

技术路线2很顺利的完成。

技术路线1补全静态库这个比较费劲，先通过ldd检查路线2编出的dll，再据此 -l 所缺静态库。

::

    在 MinGW 下 ldd 通信库.dll，找出依赖/关联的库
    gcc 目标.c -L. -l通信库 -l关联的库

.. note:: 所缺的静态库必须在 mingw 的 lib 下能找到。

和同事交流后得知，如果 mingw 工作环境正常的情况下，gcc编译链接关联的静态库文件这一步可自动完成。所以我算是逆向进行了。

虽然繁琐了点，但有参考意义，值得记录。
