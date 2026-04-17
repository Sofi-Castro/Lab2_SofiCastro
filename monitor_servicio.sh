#!/bin/bash

touch /var/log/monitor_sistema.log
chmod 707 /var/log/monitor_sistema.log

while true; do
	echo "$(date) $(ps -eo pid,comm,%cpu,%mem --sort=%cpu | tail -n 5)" >> /var/log/monitor_sistema.log
        sleep 5
done
