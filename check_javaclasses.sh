##!/bin/sh
#//!/bin/bash
#set -x
CHECK=1
#BROCTL=/opt/bro/bin/broctl
#DROPS CRI Y WARN
CRIT=100000
WARN=20000

OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3


if [ $CHECK -eq 1 ]; then

#jstat -class $(pgrep java) | tail -1 | awk '{print $1}'

CMD1=$(/usr/bin/jstat -class $(/usr/bin/pgrep java) | tail -n 1 | awk '{print $1}')
RESULT=$(/usr/bin/printf "%d\n" $CMD1 2>/dev/null)

  if [ $RESULT -gt $CRIT ] ;then
    echo "CRITICAL - #LoadedClasses=$RESULT | #LoadedClasses=$RESULT"
    exit $CRITICAL
  elif [ $RESULT -gt $WARN ]; then
    echo "WARNING - #LoadedClasses=$RESULT | #LoadedClasses=$RESULT"
    exit $WARNING
  else
    echo "OK - #LoadedClasses=$RESULT | #LoadedClasses=$RESULT"
    exit $OK
  fi
fi

