# 拼接多张图片.sh
CODES="
000218
004253
004855
006724
007810
008888
012769
014304
015178
016573
017611
"

TMP_DIR=/tmp/myimgs
mkdir -p $TMP_DIR
TIMESTAMP=`date +%Y%m%d%H%M%S`
SOURCE_DIR=`mktemp -d $TMP_DIR/tmpd.XXXXXX`
INTERMEDIATE_DIR=`mktemp -d $TMP_DIR/tmpd.XXXXXX`
OUT_FILE=`mktemp $TMP_DIR/temp.XXXXXX_$TIMESTAMP.png`

LINE=4 #每行4个

for code in $CODES
do
    # 范例
    # https://j4.dfcfw.com/charts/pic6/004855.png?v=20240808093000
    url="https://j4.dfcfw.com/charts/pic6/$code.png?v=$TIMESTAMP"
    aria2c $url -d $SOURCE_DIR
done

# 横向
i=0
j=0
x=""
for code in $CODES
do
    x="$x $SOURCE_DIR/$code.png"
    i=$(($i + 1))
    if [ $i = $LINE ]; then
        echo $x
        j=$(($j + 1))
        convert +append $x $INTERMEDIATE_DIR/$j.png
        x=""
        i=0
    fi
done
if [ "$x" != "" ]; then
    echo $x
    j=$(($j + 1))
    convert +append $x $INTERMEDIATE_DIR/$j.png
fi

# 纵向
y=""
for ximg in $INTERMEDIATE_DIR/*
do
    echo $ximg
    y="$y $ximg"
done
convert -append $y $OUT_FILE

echo $OUT_FILE