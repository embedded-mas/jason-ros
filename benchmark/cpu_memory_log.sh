#!/bin/bash

# collect memory and cpu data


# Output file
OUTPUT="sar_log.csv"

# Header of CSV
echo "hora,%user,kbmemused" > "$OUTPUT"

# Loop for 5 minutes
for i in {1..300}; do
    hora=$(date +"%H:%M:%S")
    user=$(sar -u 1 1 | awk 'NF > 5 {print $3}' | tail -n 1)
    mem=$(sar -r 1 1 | awk 'NF > 5 {print $4}' | tail -n 1)
    echo "$hora,$user,$mem" >> "$OUTPUT"
done

echo "Log file saved at $OUTPUT"

