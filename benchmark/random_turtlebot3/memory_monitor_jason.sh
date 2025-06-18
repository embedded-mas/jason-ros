#!/bin/bash

TARGET="./gradlew run"
LOG="random_rosnode_memlog_jason.csv"
INTERVAL=0.1

echo "timestamp,pid,cpu_percent,rss_kb,vsz_kb,cmdline" > "$LOG"

# Marca o tempo inicial (em nanossegundos)
start_time_ns=$(date +%s%N)
# Energia antes da execução
before=$(cat /sys/class/powercap/intel-rapl:0/energy_uj)

# Flag de execução
already_cleaned_up=false

# Função de encerramento
cleanup() {
    if [ "$already_cleaned_up" = true ]; then
        return
    fi
    already_cleaned_up=true

    end_time_ns=$(date +%s%N)
    after=$(cat /sys/class/powercap/intel-rapl:0/energy_uj)

    duration_ns=$((end_time_ns - start_time_ns))
    duration_s=$(echo "scale=6; $duration_ns / 1000000000" | bc)
    energy_j=$(echo "scale=6; ($after - $before) / 1000000" | bc)
    average_power=$(echo "scale=6; $energy_j / $duration_s" | bc)

    echo
    echo "Energia consumida (J): $energy_j"
    echo "Tempo de execução (s): $duration_s"
    echo "Potência média (W):    $average_power"

    # Finaliza o monitoramento
    kill $MON_PID 2>/dev/null
    wait $MON_PID 2>/dev/null

    exit
}

trap cleanup SIGINT

# Inicia monitoramento de uso de CPU/memória
(
    JVM_PID=""
    while true; do
        if [[ -z "$JVM_PID" ]]; then
            JVM_PID=$(pgrep -P $$ -f 'java.*')
        fi

        TIMESTAMP=$(date +"%Y-%m-%d;%H:%M:;%S.%N;%z")
        if [[ -n "$JVM_PID" && -e /proc/$JVM_PID ]]; then
            STATS=$(ps -o %cpu=,rss=,vsz=,cmd= -p "$JVM_PID" --no-headers)
            echo "$TIMESTAMP,$JVM_PID,$STATS" >> "$LOG"
        else
            echo "$TIMESTAMP,0,0,0,0,processo_finalizado" >> "$LOG"
        fi

        sleep $INTERVAL

        if [[ -n "$JVM_PID" && ! -e /proc/$JVM_PID ]]; then
            break
        fi
    done
) &
MON_PID=$!

# Executa o alvo
$TARGET

# Aguarda o fim do monitoramento
wait $MON_PID

# Finaliza normalmente
cleanup

