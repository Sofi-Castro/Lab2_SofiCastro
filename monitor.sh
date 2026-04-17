#!/bin/bash

if [ $# -lt 1 ]; then
        echo "Uso: ./monitor.sh <comando> <intervalo_segundo_opcional>"
        exit 1
elif [ $# -eq 1 ]; then
	intervalo=2
else
	intervalo=$2 
fi

bash -c "$1" &
PID_PROCESO=$!

tiempo=0

trap '
echo "Se ejecutó Cntrl+C"
kill $PID_PROCESO
        break
        ' SIGINT

while true; do
	ESTADO=$(ps -o stat -p $PID_PROCESO | tail -1 | cut -c1)

	if ! ps -p $PID_PROCESO > /dev/null; then
		echo "El proceso $PID_PROCESO ya terminó."
        	break
	fi


	if [[ "$ESTADO" == "R" || "$ESTADO" == "S" ]]; then
		echo "$tiempo $(ps -p $PID_PROCESO -o %cpu,%mem,rss --no-header) $(date)" >> monitor_$PID_PROCESO.log
                sleep $intervalo
		tiempo=$((tiempo + intervalo))
	fi

done

chmod 700 monitor_$PID_PROCESO.log
cat monitor_$PID_PROCESO.log

gnuplot <<  EOF
set terminal png size 1000,600
set output "monitor_${PID_PROCESO}.png"

set title "Monitoreo de $1 con PID ${PID_PROCESO}"
set xlabel "Tiempo (s)"
set y1label "%CPU"
set y2label "Memoria RSS (KB)"

set ytics nomirror
set y2tics
set grid

plot "monitor_$PID_PROCESO.log" using 1:2 with lines title "% CPU" axes x1y1, "monitor_$PID_PROCESO.log" using 1:3 with lines title "RSS KB" axes x1y2
EOF
 
