# 建议使用LC_ALL=C， 而不是LANG=C
LC_ALL=C 7za x -pPassword <目标.zip> && convmv -f gbk -t utf8 --notest -r .