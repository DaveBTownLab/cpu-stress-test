#!/bin/bash

clear
tput civis
trap 'tput cnorm; clear; exit' INT TERM

MAX_TEMP=0
MIN_FREQ=999

get_cpu() {
    awk -F: '/model name/ {
        gsub(/^[ \t]+/, "", $2)
        sub(/ with Radeon Graphics/, "", $2)
        print $2
        exit
    }' /proc/cpuinfo
}

get_freq() {
    awk '
    {
        sum += $1
        n++
    }
    END {
        if (n)
            printf "%.2f GHz", (sum/n)/1000000
        else
            print "N/A"
    }' /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq 2>/dev/null
}

get_temp() {
    sensors 2>/dev/null | awk '
        /Package id 0:/ {print $4; exit}
        /Tctl:/         {print $2; exit}
        /edge:/         {print $2; exit}
        /^temp1:/       {print $2; exit}
    '
}

get_usage() {

    read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
    idle1=$((idle+iowait))
    total1=$((user+nice+system+idle+iowait+irq+softirq+steal))

    sleep 0.2

    read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
    idle2=$((idle+iowait))
    total2=$((user+nice+system+idle+iowait+irq+softirq+steal))

    usage=$((100*(total2-total1-(idle2-idle1))/(total2-total1)))
    echo "${usage}%"
}

while true; do

    printf "\033[H"

    CPU=$(get_cpu)
    FREQ=$(get_freq)
    TEMP=$(get_temp)
    USAGE=$(get_usage)

    CUR_FREQ=$(echo "$FREQ" | awk '{print $1}')
    CUR_TEMP=$(echo "$TEMP" | tr -d '+°C')

    if [ "${USAGE%\%}" -ge 95 ];
    then

    # Maximaltemperatur merken
    if [[ "$CUR_TEMP" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        if awk "BEGIN {exit !($CUR_TEMP > $MAX_TEMP)}"; then
            MAX_TEMP=$CUR_TEMP
        fi
    fi

    # Niedrigste Frequenz merken
    if [[ "$CUR_FREQ" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        if awk "BEGIN {exit !($CUR_FREQ < $MIN_FREQ)}"; then
            MIN_FREQ=$CUR_FREQ
        fi
    fi
    fi
    echo "========================================"
    printf " %-38s\n" "Stress Monitor"
    echo "========================================"
    echo

    printf "%-10s %s\n" "CPU:" "$CPU"
    printf "%-10s %s\n" "Usage:" "$USAGE"
    printf "%-10s %-10s %-12s %s GHz\n" \
        "Freq:" "$FREQ" "Min:" "$MIN_FREQ"
    printf "%-10s %-10s %-12s %s°C\n" \
        "Temp:" "$TEMP" "Max:" "$MAX_TEMP"

    echo
    echo "Ctrl+C to quit."

    sleep 1
done