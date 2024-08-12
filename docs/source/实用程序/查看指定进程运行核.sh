
pid=$1
cd /proc/$pid
stats=`find -name stat -type f`

printstr=""

while true
do
    for stat in $stats
    do
        echo $stat
        awkstr=`awk '{print $1, "\t", $2, "\t", $39}' $stat`
        printstr="${printstr}${awkstr}\n"
    done

    clear
    echo -e "$printstr"
    printstr=""
    sleep 1
done
# find -name stat -type f | xargs awk '{print $1,$2,$39}' | grep 7