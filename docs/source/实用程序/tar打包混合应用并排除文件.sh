# 根据 .gitignore 构建排除
exclude_str=""

read_ignore_file() {
    while read line
    do
        ([[ $line =~ ^# ]] || [[ $line =~ ^! ]] || [[ $line = "" ]]) && continue
        exclude_str="${exclude_str} --exclude=\"`dirname $1`/${line}\""
    done < $1
}

for inogre_file in `find -name .gitignore`
do
    inogre_file=`echo $inogre_file | sed 's/^\.\///g'`
    # echo "$inogre_file"
    read_ignore_file $inogre_file
done

echo $exclude_str
# for ignore_str in $exclude_str
# do
#     echo $ignore_str
# done

# tar --exclude='.git' --exclude='node_modules' --exclude='dist' --exclude='.idea' --exclude='.gradle' -zcvf excalidraw.tgz excalidraw