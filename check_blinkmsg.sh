##!/bin/sh
#//!/bin/bash
#set -x
CHECK=1
CRIT=50
WARN=40

OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3


if [ $CHECK -eq 1 ]; then
CMD1=$(tail -1 /mnt/data/sensor/sensorhealthblinkstick.log  2>&1)
RESULT=$(echo $CMD1)
#INT_1=$(echo -e $CMD1 | awk '{print $5}' | /bin/sed 's/[^0-9]*//g')
#INT_2=$(echo $CMD1 | awk '{split($0,a," "); print $9}')
#RESULT=$(/usr/bin/printf "%d\n" $INT_1 2>/dev/null)
#COMP=$(/usr/bin/printf "%d\n" $INT_1 2>/dev/null)
#RESULT=$INT_1
#RESULT2=$(/usr/bin/printf "%d\n" $INT_2 2>/dev/null)


COMP=0

  if [ $COMP -gt $CRIT ] ;then
    echo "CRITICAL - Native Mem Allocated(bytes)=$RESULT | Allocated(bytes)=$RESULT"
    exit $CRITICAL
  elif [ $COMP -gt $WARN ]; then
    echo "WARNING - Native Mem Allocated(bytes)=$RESULT | Allocated(bytes)=$RESULT"
    exit $WARNING
  else
    echo "MSG=$RESULT"
    exit $OK
  fi
fi
