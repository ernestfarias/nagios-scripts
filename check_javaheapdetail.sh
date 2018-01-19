##!/bin/sh
#//!/bin/bash
#set -x
CHECK=1
#BROCTL=/opt/bro/bin/broctl
#DROPS CRI Y WARN
CRIT=9900000000
WARN=9500000000

OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3
#jstat -gc $(pgrep java)
# 1S0C    2S1C    3S0U    4S1U      5EC       6EU        7OC         8OU       9MC     10MU    11CCSC   12CCSU   13YGC     14YGCT    15FGC    16FGCT     17GCT
#445952.0 477184.0 73785.0  0.0   2402304.0 300970.6  840192.0   196324.9  68608.0 67210.4 8448.0 8201.2     54    4.127   5      1.156    5.283
#HEAP:old space OU, YOUNG=S0U+S1U+EU
#MESTASPACE

#/usr/bin/jstat -gc $(/usr/bin/pgrep java) | tail -1 | awk '{split($0,a," "); val +=$16; printf("%.2f\n",val)}


if [ $CHECK -eq 1 ]; then
CMD1=$(/usr/bin/jstat -gc $(/usr/bin/pgrep java) | tail -n 1 2>&1)
INT_1=$(echo $CMD1 | awk '{split($0,a," "); val +=$8; printf("%d\n",val * 1024)}') #O
INT_2=$(echo $CMD1 | awk '{split($0,a," "); val +=$6; printf("%d\n",val * 1024)}') #E
INT_3=$(echo $CMD1 | awk '{split($0,a," "); val +=$4; printf("%d\n",val * 1024)}') #S0
INT_4=$(echo $CMD1 | awk '{split($0,a," "); val +=$3; printf("%d\n",val * 1024)}') #S1

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
    echo "CRITICAL - HeapUsage(bytes) Eden=$(($INT_2 / 1048576 ))MB S0=$(($INT_3 / 1048576))MB S1=$(($INT_4 / 1048576))MB Old=$(($INT_1 / 1048576))MB | Eden(bytes)=$INT_2 S0(bytes)=$INT_3 S1(bytes)=$INT_4 Old(bytes)=$INT_1"
    exit $CRITICAL
  elif [ $COMP -gt $WARN ]; then
    echo "WARNING - HeapUsage(bytes) Eden=$(($INT_2 / 1048576 ))MB S0=$(($INT_3 / 1048576))MB S1=$(($INT_4 / 1048576))MB Old=$(($INT_1 / 1048576))MB | Eden(bytes)=$INT_2 S0(bytes)=$INT_3 S1(bytes)=$INT_4 Old(bytes)=$INT_1"
    exit $WARNING
  else
    echo "OK - HeapUsage(bytes) Eden=$(($INT_2 / 1048576 ))MB S0=$(($INT_3 / 1048576))MB S1=$(($INT_4 / 1048576))MB Old=$(($INT_1 / 1048576))MB | Eden(bytes)=$INT_2 S0(bytes)=$INT_3 S1(bytes)=$INT_4 Old(bytes)=$INT_1"
    exit $OK
  fi
fi
