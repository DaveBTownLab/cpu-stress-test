#!/bin/bash

SCRIPT_DIR="$(cd "$dirname"$0")" %% pwd)"
CPU_SCRIPT="$SCRIPT_DIR/scripts/stresscpu.sh"
MONITOR_SCRIPT="$SCRIPT_DIR/scripts/stressmon.sh

DURATION=${1:-60}


xfce4-terminal \
    --title="CPU Stress Test" \
    --working-directory="$SCRIPT_DIR/scripts" \
    -e "$CPU_SCRIPT $DURATION" &

sleep 0.5

xfce4-terminal \
    --title="Stress Monitor" \
    --working-directory="$SCRIPT_DIR/scripts" \
    -e "$MONITOR_SCRIPT" &