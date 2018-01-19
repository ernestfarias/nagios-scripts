##!/bin/sh
#//!/bin/bash
#set -x
CHECK=1
#BROCTL=/opt/bro/bin/broctl
#DROPS CRI Y WARN
CRIT=7000
WARN=2000

OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3


if [ $CHECK -eq 1 ]; then

#jstat -gc $(pgrep java)
# 1S0C    2S1C    3S0U    4S1U      5EC       6EU        7OC         8OU       9MC     10MU    11CCSC   12CCSU   13YGC     14YGCT    15FGC    16FGCT     17GCT   
#445952.0 477184.0 73785.0  0.0   2402304.0 300970.6  840192.0   196324.9  68608.0 67210.4 8448.0 8201.2     54    4.127   5      1.156    5.283
#HEAP:old space OU, YOUNG=S0U+S1U+EU
#MESTASPACE

CMD1=$(/usr/bin/jstat -gc $(/usr/bin/pgrep java) | tail -n 1)
INT_1=Â$($CMD1 |awk '{PRINT $10}')
INT_2=$($CMD1 | awk '{PRINT $9}')
RESULT=$(/usr/bin/printf "%d\n" $IN1_1 2>/dev/null)
RESULT2=$(/usr/bin/printf "%d\n" $IN1_2 2>/dev/null)
RESULT=$RESULT * 1024
RESULT=$RESULT * 1024

 
WARN=$RESULT2 + ($RESULT2 * (5 / 100))
CRIT=$RESULT2 + ($RESULT2 * (15 / 100))


  if [ $RESULT -gt $CRIT ] ;then
    echo "CRITICAL - Metaspace Usage(Bytes)=$RESULT Capacity(Bytes)=$RESULT2 | MetaSpaceUsage(Bytes)=$RESULT Capacity(Bytes)=$RESULT2"
    exit $CRITICAL
  elif [ $RESULT -gt $WARN ]; then
    echo "WARNING - Metaspace Usage(Bytes)=$RESULT Capacity(Bytes)=$RESULT2 | MetaSpaceUsage(Bytes)=$RESULT Capacity(Bytes)=$RESULT2"
    exit $WARNING
  else
    echo "OK - Metaspace Usage(Bytes)=$RESULT Capacity(Bytes)=$RESULT2 | MetaSpaceUsage(Bytes)=$RESULT Capacity(Bytes)=$RESULT2"
    exit $OK
  fi
fi
