三言两语聊Kernel：linux Kernel和bsd Kernel实现doubly-linked List的差异
===========================================================

https://laoar.github.io/blogs/367/

TL;DR
-----------------------------------------------------------

First thing first，实现的目的是为了应用，所以我打算从应用的角度来开始写。为此我先写了两个用例，一个是双向链表在linux系统上的应用，一个是在bsd系统上的应用，代码放在了我的github上：list paradigm （P.S. : paradigm这个单词是公司里的英语老师Michael教的，所以在这里忍不住想用一下）。

源码解释
-----------------------------------------------------------

先简单解释下我写的这两个C文件。

1. linux_list.c


在linux系统上，它的/usr/include目录就是我们编译C代码的头文件所在路径的其中一个。这个目录里有一个特殊的子目录，叫做/usr/inlude/linux, 之所以叫linux这个名字，是因为它是从linux kernel里面导出来的头文件，而不是从glibc库里面导出来的头文件。按理说，linux kernel导出来的头文件是给kernel module用的，所以一般都放在kernel module的编译路径里，现在既然在/usr/include/目录里也放了一份，那目的很明显了，用户态程序想用就用吧。但是坑爹的是，linux kernel头文件不是你想用就能用，因为linux kernel是GPL协议，而Glibc是LGPL协议，也就是说如果你include了linux kernel头文件，那么你的代码也必须是GPL的，你只有copyleft，没有copyright，你的代码就别指望着卖钱了，乖乖开源吧。 而如果你是include的glibc的头文件，那么没关系，你无需开源，你具有你写的代码的copyright。 需要声明的是，我不是一个开源的反对者，相反我认为开源挺有好处的，把代码提交给社区，总有热心人会帮你挑错或者帮你改进代码，这不挺好嘛。但是，我也不是一个GPL的提倡者，GPL这个东西，多少感觉有点社会主义大锅饭或者共产主义的味道，大锅饭的后果是某些人钻空子不劳而获，而另外一些人会丧失劳动的积极性进而生产力得不到很好的发展。

既然放在了/usr/include/ 这个目录下，那就是告诉应用程序开发者们想用就用吧，大不了开源。然而事情没有想象中的那么简单，就比如这个蛋疼的/usr/include/linux/list.h这个头文件，它竟然很操蛋的说＃ifdef __KERNEL__, 就是说，你是内核模块才能接着用后面这段代码。于是我被逼无奈在自己的C代码里面定义了这个宏，当然这是非常规手法，莫学，我只是为了写它的使用示例才这么干的。

至于gcc的-D选项，想必大家都明白，它是为了方便选择性编译用的。

2. bsd_list.c


BSD的设计就很优雅，包括它的应用程序编译环境，不像linux那样一锅乱炖。 BSD kernel导出来的头文件是放在了 /usr/include/sys这个目录下，与linux list.h相对应的文件是queue.h,这个文件则是想用就能用，而且BSD协议也不要求你必须开源，所以尽管放心大胆的使用“＃include <sys/queue.h>”就好了。 另外，牛逼哄哄的Mac也是使用了很多BSD的组件，我的这个C文件就是在Mac上编译并执行的。当然，对于Mac而言，它有自己的sysroot路径，所以事实上queue.h是在/$%^&!@###/sys/queue.h这个地方，$%^&!@###这个鬼东西就是Mac的编译环境路径的名字，不必care。

说了那么多，还没有说到正题，好了，言归正传。

在网络系统上，不过就是收包和发包，所以Network里面对链表的使用主要就是添加和删除，很少涉及查找某一个元素或者把一个元素插入到中间某一个位置。对于添加和删除，无非就是，从头还是从尾添加，从头还是从为删除，或者说，先进先出，还是先进后出，也就是队列和栈。

Linux在这方面设计的比较精巧，而且是一招鲜吃遍天。它的具体实现思想是，我先指定一个全局变量header，你可以选择往这个header的prev方向插也可以选择往这个header的next方向插，嗯，想必你已经明白了，它实现的是一个双向循环链表。对于栈而言就是，每来一个新元素，我就插入到header的next位置，遍历的时候我也往next方向遍历，那么first元素就是最新插入的元素。对于队列而言是，每来一个新元素，我就插入到header的prev位置，遍历的时候仍然是往next方向遍历，但这个时候first元素显然是最老插入的元素。是不是又是前又是后插来插去的把你插糊涂了？这怨不得我，谁让您的思想太邪恶了哪。 于是linux就靠struct list_head这个东西几乎搞定了所有涉及到链表的操作，这也是为什么我说它一招鲜吃遍天的原因。

BSD kernel则是实现了list的family， 比如SLIST／LIST／TAILQ等，在这里我说一下有代表性的TAILQ。我们知道BSD就是network的祖师爷，network协议的第一次编码实现就是在BSD系统上。 所以BSD链表的实现也带有明显的网络应用场景痕迹，就像queue.h里面解释的，“因为我们总是会从前往后查找（收包嘛自然是先来的先走了），所以我们双向链表的prev域并不是指向前一个元素，而是指向前一个元素的next域，而前一个元素的next域是指向我这个元素自身”，这样设计的好处从TAIQ_LAST()这个函数的实现里就可以一窥端倪。 BSD并没有像linux那样靠循环链表的表头header就可以想怎么玩就怎么玩，bsd不是一个循环链表。但是我又想实现从头从尾插从头从尾删怎么办，所以它得记录这个链表的first和last元素，这样就可以想从前就从前想从后就从后的插入和删除了。

说一下TAILQ_LAST()这个函数。TAILQ_LAST()的一个技巧就是，指针就是指针，它不过就是4字节(32bit CPU)或者8字节(64bit CPU)而已，和名字无关。 比如我有下面两个结构体：

::
    
    struct XX{
        struct XX *first；
        struct XX **last;
    } header;

    struct  YY{
        struct YY *next;
        struct YY **prev;
    } type;

如果我知道了type的next域的地址，我想要获取type的prev元素里面的内容怎么办？ 最直接点的实现就是next域的地址加4再访问就好了，但是这样不优雅，太过于丑陋，作为优雅的BSD，自然要使用其他方法，这也是为什么我说container_of太过于简单粗暴的原因。BSD的实现是，我使用header和type具有相同的内存layout来做文章， 因为next域指向的元素类型跟type一样，那么我把type类型强制转换为header类型，访问header的last域就可以了。说的有点绕，请看代码实现，一看就明白。

总结一下，linux kernel双向链表的基本结构体是，

::

    struct type {
        struct type *next;
        struct type *prev;
    };

BSD kernel双向链表的基本结构体是，

::
    
    struct type {
        struct type *next;
        struct type **prev;
    };

BSD的实现由应用场景来决定的，Linux Kernel则纯粹是为了一药治百病。

现在已经很晚了，有点疲累，所以匆匆写完，也没有到处找链接给索引。所以只是作为一个入门参考，具体细节您还得自己慢慢分析。另外再说一句，BSD的TAIQ确实设计的很巧妙，不像Linux Kernel的list简单粗暴的用0指针来实现container_of(). 具体细节您得看代码，如有不明白，尽管google，有很多好事者写了这方面的解析，当然大多数不过C+V而已。