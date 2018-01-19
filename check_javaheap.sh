##!/bin/sh
#//!/bin/bash
#set -x
CHECK=1
#BROCTL=/opt/bro/bin/broctl
#DROPS CRI Y WARN
CRIT=20000
WARN=8000

OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3


if [ $CHECK -eq 1 ]; then

CMD1=$(/usr/bin/jstat -gc $(/usr/bin/pgrep java) | tail -n 1 | awk '{split($0,a," "); sum=a[3]+a[4]+a[6]+a[8]+a[10]+a[12]; print sum/1024}')
RESULT=$(/usr/bin/printf "%d\n" $CMD1 2>/dev/null)

  if [ $RESULT -gt $CRIT ] ;then
    echo "CRITICAL - | HeapSize(MB)=$RESULT"
    exit $CRITICAL
  elif [ $RESULT -gt $WARN ]; then
    echo "WARNING - | HeapSize(MB)=$RESULT"
    exit $WARNING
  else
    echo "OK - | HeapSize(MB)=$RESULT"
    exit $OK
  fi
fi
