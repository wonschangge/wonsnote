Suricatta对lua模块的支持
===========================================================

server_lua.c 是C到Lua的桥接器，支持使用Lua编写Suricatta模块，它为Lua领域提供了SWUpdate核心接口方面的基础设施，使业务逻辑（如处理更新流、与后端服务器API通信）
能够用Lua建模。
对于Lua来说，桥接器提供的功能与其他用C编写的Suricatta模块一样