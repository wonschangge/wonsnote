cpus=`ls /sys/devices/system/cpu | grep "^cpu[0-9]\{1,\}$" | sort -t "u" -n -k2`
printstr="\tmax\tmin\tcur\n"
errorstr=""


while true
do
    for cpu in $cpus
    do
        cpufreq=/sys/devices/system/cpu/${cpu}/cpufreq

        if test -r "$cpufreq/cpuinfo_max_freq"; then
            max=`cat $cpufreq/cpuinfo_max_freq`
        else
            errorstr="Err: cannot read $cpufreq/cpuinfo_max_freq\n"
        fi

        if test -r "$cpufreq/cpuinfo_min_freq"; then
            min=`cat $cpufreq/cpuinfo_min_freq`
        else
            errorstr="Err: cannot read $cpufreq/cpuinfo_min_freq\n"
        fi

        if test -r "$cpufreq/cpuinfo_cur_freq"; then
            cur=`cat $cpufreq/cpuinfo_cur_freq`
        else
            errorstr="${errorstr}Err: cannot read $cpufreq/cpuinfo_cur_freq\n"
        fi

        printstr="${printstr}${cpu}\t${max}\t${min}\t${cur}\n"
    done

    clear

    echo -e "$errorstr"
    echo -e "$printstr"

    printstr="\tmax\tmin\tcur\n"
    sleep 1
done


#      max min cur
# cpu0 ... ... ...
# cpu1 ... ... ...
# ...
# cpu7 ... ... ...

# 禁用CPU核心
# https://stackoverflow.com/questions/44907731/programmatically-disable-cpu-core