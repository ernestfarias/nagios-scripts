##!/bin/sh
#//!/bin/bash
#set -x
CHECK=1
#BROCTL=/opt/bro/bin/broctl
#DROPS CRI Y WARN
CRIT=4000000000
WARN=3000000000

OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3
#jstat -gc $(pgrep java)
# 1S0C    2S1C    3S0U    4S1U      5EC       6EU        7OC         8OU       9MC     10MU    11CCSC   12CCSU   13YGC     14YGCT    15FGC    16FGCT     17GCT
#445952.0 477184.0 73785.0  0.0   2402304.0 300970.6  840192.0   196324.9  68608.0 67210.4 8448.0 8201.2     54    4.127   5      1.156    5.283
#HEAP:old space OU, YOUNG=S0U+S1U+EU
#MESTASPACE



# sudo -u sensor jcmd $(pgrep java) VM.native_memory summary  | grep Native |tail -1 | awk '{print $5}'| /bin/sed 's/[^0-9]*//g' 
#/usr/bin/jstat -gc $(/usr/bin/pgrep java) | tail -1 | awk '{split($0,a," "); val +=$16; printf("%.2f\n",val)}
#if [ $CHECK -eq 1 ]; then
#CMD1=$(/usr/bin/jstat -gc $(/usr/bin/pgrep java) | tail -n 1 2>&1)
#INT_1=$(echo $CMD1 | awk '{split($0,a," "); val +=$8; printf("%d\n",val * 1024)}') #O


if [ $CHECK -eq 1 ]; then
CMD1=$(/usr/bin/jcmd $(/usr/bin/pgrep java) VM.native_memory summary |grep Native |tail -1 | awk '{print $5}'| /bin/sed 's/[^0-9]*//g'  2>&1)
INT_1=$(echo $CMD1 |awk '{ val += $1 } END { printf("%d\n",val * 1024) }')
#INT_1=$(echo -e $CMD1 | awk '{print $5}' | /bin/sed 's/[^0-9]*//g')
#INT_2=$(echo $CMD1 | awk '{split($0,a," "); print $9}')
#RESULT=$(/usr/bin/printf "%d\n" $INT_1 2>/dev/null)
COMP=$(/usr/bin/printf "%d\n" $INT_1 2>/dev/null)
RESULT=$INT_1
#RESULT2=$(/usr/bin/printf "%d\n" $INT_2 2>/dev/null)
#echo "RESULTADO1: $RESULT  and $RESULT2"
#RESULT=$(($RESULT * 1024))
#RESULT2=$(($RESULT2 * 1024))

#echo "RESULTADO: $RESULT  and $RESULT2"


#WARN=
#CRIT=$(($RESULT2 + 50000000))

#echo "RESULTADO3: $WARN  and $CRIT  and $TEST"

  if [ $COMP -gt $CRIT ] ;then
    echo "CRITICAL - Native Mem Allocated(bytes)=$RESULT | Allocated(bytes)=$RESULT"
    exit $CRITICAL
  elif [ $COMP -gt $WARN ]; then
    echo "WARNING - Native Mem Allocated(bytes)=$RESULT | Allocated(bytes)=$RESULT"
    exit $WARNING
  else
    echo "OK - Native Mem Allocated(bytes)=$RESULT | Allocated(bytes)=$RESULT"
    exit $OK
  fi
fi
