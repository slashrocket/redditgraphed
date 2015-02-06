#!/bin/bash
PID=$(ps aux | grep puma | grep -v grep | awk '{print $2}')
if [[ $PID ]]; then
	kill -kill $PID
fi
puma -p 3000 > /dev/null &
