
pid=$1
cd /proc/$pid
printstr=""

while true
do
    stats=`find -name stat -type f`
    for stat in $stats
    do
#        echo $stat
        awkstr=`awk '{print $1, "\t", $2, "\t", $39}' $stat`
        printstr="${printstr}${awkstr}\n"
    done

    clear
    echo -e "$printstr"
    printstr=""
    sleep 1
done
