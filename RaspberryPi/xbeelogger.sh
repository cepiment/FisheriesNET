#!/bin/bash

sleep 60

killall cat

cat /dev/ttyUSB0 > /media/ubuntu/SANDISK3/$(date +"%Y-%m-%d").csv
