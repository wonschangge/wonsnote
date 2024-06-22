import os
import re

# 数据可视化、web应用开发等经常用到一些特殊字体，但由于一款字体包含的字符数量多体积比较大
# 在进行网络加载、读取字体文件带来更多的耗时。

# 可针对字体文件运用“按需引入”的思想，从原始的体积较大的全量字体文件中，
# 根据我们实际使用到的文字范围，进行子集的提取，从而大幅度提升效率。

# Python中的fonttools库可实现此需求，它由谷歌开源，自带了若干实用的字体处理相关命令行工具，
# 使用pip install fonttools安装完成后，我们只需要按照下列格式执行命令行工具pyftsubset即可：

# pyftsubset 原始字体文件路径 --text=需要保留的字符 --output-file=输出子集字体文件路径

# 读入目标文本内容
with open('./将进酒.txt', encoding='utf-8') as t:
    source_content = t.read()
    
# 模拟执行pyftsubset命令生成字体子集
os.system(
    'pyftsubset 钟齐志莽行书.ttf --text={} --output-file=钟齐志莽行书mini.ttf'.format(
        # 去除空白字符后去重
        ''.join(set(re.sub('\s', '', source_content)))
    )
)
