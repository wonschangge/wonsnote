# 详情参考Chrome 无头模式: 
# https://developer.chrome.com/docs/chromium/new-headless?hl=zh-cn#how_does_headless_work

# 无头模式输出dom
google-chrome \
    --headless=new \
    --dump-dom \
    https://google.com

# 无头模式输出截图
google-chrome \
    --headless=new \
    --screenshot=test.png \
    --window-size=412,892 \
    https://google.com/

# 无头模式输出超长截图，1页100个搜索结果
google-chrome \
    --headless=new \
    --screenshot=test.png \
    --window-size=1000,10000 \
    "https://www.google.com/search?q=filetype%3Apdf+site%3Ami.com&oq=filetype%3Apdf+site%3Ami.com&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIGCAEQRRg60gEIODAxOGowajeoAgCwAgA&sourceid=chrome&ie=UTF-8&num=200"

# 无头模式输出PDF文稿
google-chrome \
    --headless=new \
    --disable-gpu \
    --no-pdf-header-footer \
    --timeout=1000 \
    --virtual-time-budget=1000 \
    --remote-debugging-port=0 \
    --print-to-pdf=test.pdf \
    https://google.com

# --no-pdf-header-footer 忽略页眉页脚
# --timeout 标志定义了最长等待时间（以毫秒为单位），之后进行dom、png、pdf的输出
# --virtual-time-budget 它会强制浏览器执行任何尽可能快地检查网页代码，同时让网页相信真的需要这么长时间
# --allow-chrome-scheme-url 标志。 Chrome 123 及更高版本提供此标志。示例如下：
chrome --headless=new --print-to-pdf --allow-chrome-scheme-url chrome://gpu
# --remote-debugging-port 用于调试无头chrome
chrome --headless=new --remote-debugging-port=0 https://developer.chrome.com/
# DevTools listening on ws://127.0.0.1:60926/devtools/browser/b4bd6eaa-b7c8-4319-8212-225097472fd9
# 在 about:inspect 中打开并 configure ip:port 即可见到该无头浏览器下的网页


google-chrome \
    --headless=new \
    --window-size=1000,10000 \
    --disable-gpu \
    --no-pdf-header-footer \
    --timeout=1000 \
    --virtual-time-budget=1000 \
    --print-to-pdf=test.pdf \
    "https://www.google.com/search?q=filetype%3Apdf+site%3Ami.com&oq=filetype%3Apdf+site%3Ami.com&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIGCAEQRRg60gEIODAxOGowajeoAgCwAgA&sourceid=chrome&ie=UTF-8&num=200"
    https://google.com