#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CPU_SCRIPT="$SCRIPT_DIR/scripts/stresscpu.sh"
MONITOR_SCRIPT="$SCRIPT_DIR/scripts/stressmon.sh"

DURATION=${1:-60}

echo "$SCRIPT_DIR"
echo "$CPU_SCRIPT"
echo "$MONITOR_SCRIPT"


konsole \
    --title="CPU Stress Test" \
    --workdir="$SCRIPT_DIR/scripts" \
    -e "$CPU_SCRIPT $DURATION" &

sleep 0.5

konsole \
    --title="Stress Monitor" \
    --workdir="$SCRIPT_DIR/scripts" \
    -e "$MONITOR_SCRIPT" &