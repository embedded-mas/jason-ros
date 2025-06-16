#!/bin/bash

NODE_NAME="random_turtlebot3_publisher_with_perception.py"
LOG="random_rosnode_memlog_ros.csv"
INTERVAL=0.1
CPU_POWER_WATTS=15  # estimativa

POWERLOG="powerstat_output.txt"

echo "timestamp,pid,cpu_percent,rss_kb,vsz_kb,cmdline" > "$LOG"

TOTAL_CPU=0.0
SAMPLES=0

# Sourcing dos ambientes ROS
source /opt/ros/noetic/setup.bash
source /mnt/1C4C766F4C764414/maiquel/git/embedded_mas_ros_example_package/devel/setup.bash

# Executa o nó ROS em segundo plano
rosrun embedded_mas_examples "$NODE_NAME" &
NODE_PID=$!
echo "PID do processo rosrun: $NODE_PID"

# Inicia o powerstat (se possível, com sudo)
powerstat -R -z -c -d $INTERVAL > "$POWERLOG" &
PWR_PID=$!

# Função de monitoramento
monitor_process() {
    while kill -0 "$NODE_PID" 2> /dev/null; do
        TIMESTAMP=$(date +%s.%N)

        if [[ -e /proc/$NODE_PID ]]; then
            STATS=$(ps -o %cpu=,rss=,vsz=,cmd= -p "$NODE_PID" --no-headers)
            echo "$TIMESTAMP,$NODE_PID,$STATS" >> "$LOG"

            CPU_USAGE=$(echo "$STATS" | awk '{print $1}')
            TOTAL_CPU=$(echo "$TOTAL_CPU + $CPU_USAGE" | bc)
            SAMPLES=$((SAMPLES + 1))
        fi

        sleep $INTERVAL
    done

    echo "$(date +%s.%N),$NODE_PID,0,0,0,processo_finalizado" >> "$LOG"
}

# Inicia monitoramento em background
monitor_process &

# Espera o nó encerrar
wait $NODE_PID

# Termina o powerstat e coleta dados
kill $PWR_PID 2>/dev/null
wait $PWR_PID 2>/dev/null

# Estimativa via %CPU
if [[ $SAMPLES -gt 0 ]]; then
    AVG_CPU=$(echo "$TOTAL_CPU / $SAMPLES" | bc -l)
    TOTAL_TIME=$(echo "$SAMPLES * $INTERVAL" | bc -l)
    ENERGY=$(echo "$AVG_CPU / 100 * $CPU_POWER_WATTS * $TOTAL_TIME" | bc -l)
    echo
    echo "[Estimativa com %CPU]"
    echo "Uso médio de CPU: $AVG_CPU %"
    echo "Energia estimada consumida: $ENERGY Joules"
fi

# Resultado do powerstat
if grep -q "Average power" "$POWERLOG"; then
    AVG_LINE=$(grep -A1 "Average power" "$POWERLOG" | tail -n1)
    POWER_VAL=$(echo "$AVG_LINE" | awk '{print $1}')
    POWER_UNIT=$(echo "$AVG_LINE" | awk '{print $2}')
    echo
    echo "[Medição via powerstat]"
    echo "Consumo médio de energia: $POWER_VAL $POWER_UNIT"
else
    echo "Falha ao obter dados de energia via powerstat."
fi

