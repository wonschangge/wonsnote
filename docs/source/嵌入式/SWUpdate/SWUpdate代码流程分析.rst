SWUpdate代码流程分析
===============================

1. 初始化变量、结构体
2. 初始化主数据结构 swupdate_cfg
3. 初始化通知器(server/client),包含console/process/progress
4. 输入参数处理
5. 处理bootloader相关
6. 初始化lua处理器
7. 注册syslog通知器
8. 启动网络线程
9. 启动进度线程
10. 启动配置中定义的子进程
11. 从文件中安装




bootloader.c 函数:

.. code:: c

    typedef struct {
        // 修改变量
        int (*env_set)(const char *, const char *);
        // 丢弃变量
        int (*env_unset)(const char *);
        // 获取变量
        char* (*env_get)(const char *);
        // 设置多个变量
        int (*apply_list)(const char *);
    } bootloader;

    typedef struct {
        const char *name;
        bootloader *funcs;
    } entry;

    // 注册bootloader
    int register_bootloader(const char *name, bootloader *bl);
    // 设置将要使用的bootloader
    int set_bootloader(const char *name)
    // 测试当前是否选择了bootloader
    bool is_bootloader(const char *name)
    // 获取bootloader的名字
    const char* get_bootloader(void)
    // 打印已注册的bootloader
    void print_registered_bootloaders(void)



