tmux教程
=========================

使用 tmux 的详细资料

tmux 是一个终端复用器，允许用户在一个终端窗口中管理多个终端会话。以下是使用 tmux 的一些基本命令和配置方法：

1. 启动 tmux
启动一个新的 tmux 会话：

::

    tmux new -s mysession

附加到已存在的会话：

::

    tmux attach -t mysession

列出所有会话：

::

    tmux ls

2. 基本快捷键
创建新窗口：

::

    Ctrl+b c
切换窗口：

::

    Ctrl+b n  # 下一个窗口
Ctrl+b p  # 上一个窗口
Ctrl+b 0-9  # 切换到指定编号的窗口
分割窗格：

::

    Ctrl+b %  # 垂直分割
Ctrl+b "  # 水平分割
切换窗格：

::

    Ctrl+b o  # 切换到下一个窗格
Ctrl+b ;  # 切换到上一个窗格
调整窗格大小：

::

    Ctrl+b Ctrl+箭头键  # 调整当前窗格大小
关闭当前窗格：

::

    Ctrl+b x
关闭当前窗口：

::

    Ctrl+b &  # 确认后关闭当前窗口
3. 配置文件
默认配置文件位置：

用户级别的配置文件：~/.tmux.conf
系统级别的配置文件：/etc/tmux.conf
常用配置示例：

::

    # 设置前缀键为 Ctrl+a
set-option -g prefix C-a

# 启用鼠标支持
set-option -g mouse on

# 设置状态栏颜色
set-option -g status-bg black
set-option -g status-fg white

# 设置窗口名称自动更新
set-window-option -g automatic-rename on

# 设置窗口索引从 1 开始
set-option -g base-index 1
set-window-option -g pane-base-index 1
重新加载配置文件：

::

    tmux source-file ~/.tmux.conf
4. 其他高级功能
复制模式：

::

    Ctrl+b [  # 进入复制模式
Ctrl+b ]  # 粘贴选中的文本
重命名会话：

::

    tmux rename-session -t oldname newname
重命名窗口：

::

    Ctrl+b ,  # 重命名当前窗口
捕获窗格内容：

::

    tmux capture-pane -p -S -10  # 捕获当前窗格的最后 10 行内容
发送命令到窗格：

::

    tmux send-keys -t session:window.pane "command" Enter
5. 实用脚本
创建一个包含多个窗口的会话：

::

    tmux new-session -d -s mysession
tmux new-window -t mysession:1 -n "window1"
tmux new-window -t mysession:2 -n "window2"
tmux attach -t mysession
自动启动 tmux 会话：

::

    # 在 .bashrc 或 .zshrc 中添加
if [ "$TMUX" = "" ]; then
    tmux attach || tmux new
fi
希望这些资料能帮助你更好地使用 tmux！如果你有更多具体的问题或需要进一步的帮助，请随时提问。