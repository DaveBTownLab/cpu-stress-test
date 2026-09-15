#!/bin/bash

clear
tput civis
trap 'tput cnorm; clear; exit' INT TERM

MAX_TEMP=0
MAX_TEMP_TIME=0

MIN_FREQ=999
MIN_FREQ_TIME=0

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

    #################################################
    # Nur während des Stresstests Werte speichern
    #################################################

    if [ "${USAGE%\%}" -ge 95 ]; then

        # Höchste Temperatur
        if [[ "$CUR_TEMP" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            if awk "BEGIN {exit !($CUR_TEMP > $MAX_TEMP)}"; then
                MAX_TEMP="$CUR_TEMP"
                MAX_TEMP_TIME="$SECONDS"
            fi
        fi

        # Niedrigste Frequenz
        if [[ "$CUR_FREQ" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            if awk "BEGIN {exit !($CUR_FREQ < $MIN_FREQ)}"; then
                MIN_FREQ="$CUR_FREQ"
                MIN_FREQ_TIME="$SECONDS"
            fi
        fi
    fi

    #################################################
    # Anzeige vorbereiten
    #################################################

    if [ "$MAX_TEMP_TIME" -eq 0 ]; then
        SHOW_MAX_TEMP="..."
        SHOW_MAX_TEMP_TIME="..."
    else
        SHOW_MAX_TEMP="$MAX_TEMP"
        SHOW_MAX_TEMP_TIME="$MAX_TEMP_TIME"
    fi

    if [ "$MIN_FREQ_TIME" -eq 0 ]; then
        SHOW_MIN_FREQ="..."
        SHOW_MIN_FREQ_TIME="..."
    else
        SHOW_MIN_FREQ="$MIN_FREQ"
        SHOW_MIN_FREQ_TIME="$MIN_FREQ_TIME"
    fi

    #################################################
    # Ausgabe
    #################################################

    echo "========================================"
    printf " %-38s\n" "Stress Monitor"
    echo "========================================"
    echo

    printf "%-10s %s\n" "CPU:" "$CPU"
    printf "%-10s %s\n" "Usage:" "$USAGE"

    printf "%-10s %-10s %-12s %s GHz @ %ss\n" \
        "Freq:" "$FREQ" "Min:" "$SHOW_MIN_FREQ" "$SHOW_MIN_FREQ_TIME"

    printf "%-10s %-10s %-12s %s °C @ %ss\n" \
        "Temp:" "$TEMP" "Max:" "$SHOW_MAX_TEMP" "$SHOW_MAX_TEMP_TIME"

    echo
    echo "Ctrl+C to quit."

    sleep 1
done