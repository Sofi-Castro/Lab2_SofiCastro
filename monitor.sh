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

while true; do
	ESTADO=$(ps -o stat -p $PID_PROCESO | tail -1)

	trap '
	kill $PID_PROCESO
	break
	' SIGINT

	cat /proc/$PID_PROCESO/cmdline > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		break
	fi

	if [[ "$ESTADO" == "R" -o "$ESTADO" == "S" ]]; then
		echo "$(date) $(ps -p $PID_PROCESO -o %cpu,%mem,rss --no-header>
                sleep $intervalo
	fi

done#!bin/bash

if [ $# -ne 1]; then
        echo "Uso: ./monitor.sh <comando> <intervalo_segundo_opcional>"
        exit 1
fi
