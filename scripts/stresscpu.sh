#!/bin/bash

DURATION="${1:-60}"

echo "Starting CPU stress test for ${DURATION} seconds..."
echo

stress-ng \
    --cpu "$(nproc)" \
    --timeout "${DURATION}s" \
    --metrics-brief

echo
echo "Stress test finished."