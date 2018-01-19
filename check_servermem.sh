##!/bin/sh
#//!/bin/bash
#set -x
CHECK=1
#BROCTL=/opt/bro/bin/broctl
#DROPS CRI Y WARN
CRIT=50
WARN=15

OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3
#jstat -gc $(pgrep java)
# 1S0C    2S1C    3S0U    4S1U      5EC       6EU        7OC         8OU       9MC     10MU    11CCSC   12CCSU   13YGC     14YGCT    15FGC    16FGCT     17GCT
#445952.0 477184.0 73785.0  0.0   2402304.0 300970.6  840192.0   196324.9  68608.0 67210.4 8448.0 8201.2     54    4.127   5      1.156    5.283
#HEAP:old space OU, YOUNG=S0U+S1U+EU
#MESTASPACE


#root@localhost:/home/whuser# free -b
#1              2total        3used        4free      5shared  6buff/cache   7available
#Mem:    33479974912  8838234112   557682688       53248 24084058112 24139440128
#Swap:    3745509376   139030528  3606478848
#root@localhost:/home/whuser# free -b | grep Mem
#Mem:    33479974912  8764284928   624803840       53248 24090886144 24212402176

# sudo -u sensor jcmd $(pgrep java) VM.native_memory summary  | grep Native |tail -1 | awk '{print $5}'| /bin/sed 's/[^0-9]*//g' 
#/usr/bin/jstat -gc $(/usr/bin/pgrep java) | tail -1 | awk '{split($0,a," "); val +=$16; printf("%.2f\n",val)}
#if [ $CHECK -eq 1 ]; then
#CMD1=$(/usr/bin/jstat -gc $(/usr/bin/pgrep java) | tail -n 1 2>&1)
#INT_1=$(echo $CMD1 | awk '{split($0,a," "); val +=$8; printf("%d\n",val * 1024)}') #O


if [ $CHECK -eq 1 ]; then
CMD1=$(free -b |grep Mem 2>&1)
INT_1=$(echo $CMD1 |awk '{print $2}')
INT_2=$(echo $CMD1 |awk '{print $3}')
INT_3=$(echo $CMD1 |awk '{print $6}')
INT_4=$(echo $CMD1 |awk '{print $5}')
INT_5=$(echo $CMD1 |awk '{print $4}')


#RESULT=$(/usr/bin/printf "%d\n" $INT_1 2>/dev/null)
COMP=$(/usr/bin/printf "%d\n" $INT_1 2>/dev/null)
#RESULT=$INT_1
#RESULT2=$(/usr/bin/printf "%d\n" $INT_2 2>/dev/null)
#echo "RESULTADO1: $RESULT  and $RESULT2"
#RESULT=$(($RESULT * 1024))
#RESULT2=$(($RESULT2 * 1024))

#echo "RESULTADO: $RESULT  and $RESULT2"


#WARN=
CRIT=$INT_1
WARN=$(($INT_1 - 000000000))


#echo "RESULTADO3: $WARN  and $CRIT  and $TEST"

  if [ $COMP -gt $CRIT ] ;then
    echo "CRITICAL - Free(bytes)=$INT_5 | Total(bytes)=$INT_1 Used=$INT_2 Shared=$INT_4 Buff/cache=$INT_3"
    exit $CRITICAL
  elif [ $COMP -gt $WARN ]; then
    echo "WARNING - Free(bytes)=$INT_5 | Total(bytes)=$INT_1 Used=$INT_2 Shared=$INT_4 Buff/cache=$INT_3"
    exit $WARNING
  else
    echo "OK - Free(bytes)=$INT_5 | Total(bytes)=$INT_1 Used=$INT_2 Shared=$INT_4 Buff/cache=$INT_3"
    exit $OK
  fi
fi
