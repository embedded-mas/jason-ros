#!/bin/bash

NODE_NAME="random_turtlebot3_publisher_with_perception_c"
LOG="random_rosnode_memlog_ros.csv"
INTERVAL=0.1

echo "timestamp;pid;cpu_percent;rss_kb;vsz_kb;cmdline" > "$LOG"

(
    PID=""
    while true; do
        if [[ -z "$PID" ]]; then
            PID=$(pgrep -f "$NODE_NAME")
        fi

        TIMESTAMP=$(date +"%Y-%m-%d, %H:%M:%S;%3N")

        if [[ -n "$PID" && -e /proc/$PID ]]; then
            # Obtém CPU, RSS, VSZ e CMD
            STATS=$(ps -o %cpu=,rss=,vsz=,cmd= -p "$PID" --no-headers)
            # Substitui separador decimal de ponto por vírgula
            STATS_FORMATTED=$(echo "$STATS" | sed 's/\./,/')
            echo "$TIMESTAMP;$PID;$STATS_FORMATTED" >> "$LOG"
        else
            echo "$TIMESTAMP;0;0;0;0;processo_finalizado" >> "$LOG"
        fi

        sleep $INTERVAL

        if [[ -n "$PID" && ! -e /proc/$PID ]]; then
            break
        fi
    done
) &
MON_PID=$!

# Executa o nó
rosrun embedded_mas_examples random_turtlebot3_publisher_with_perception_c

wait $MON_PID

