##!/bin/bash
#set -x
DROPRECCHECK=1
#BROCTL=/opt/bro/bin/broctl
#DROPS CRI Y WARN
CRIT=100000
WARN=10

OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3

#date
HORA=$(date +"%H")
#HORA=13
DIA=$(date +"%d")
MES=$(date +"%m")
ANO=$(date +"%Y")
MIN=$(date +"%M")
BROLOGSDIR="/mnt/data/bro/log/$ANO-$MES-$DIA"
COMP=0
VAL1=0
VAL2=0

if [ $DROPRECCHECK -eq 1 ]; then
#set -x
if test "$(find $BROLOGSDIR/capture_loss.$HORA*.log 2>/dev/null)"; then
#if [ -e $BROLOGSDIR/capture_loss.$HORA*.log ]; then
CMD1=$(cat $BROLOGSDIR/capture_loss.$HORA*.log | /opt/bro/bin/bro-cut -d ts acks percent_lost | tail -1  2>&1)
#megabit to bit
   INT_1=$(/bin/echo $CMD1 | awk '{print $2}' ) #nr of processed
   INT_2=$(/bin/echo $CMD1 | awk '{print $3}' ) #pct of packet loss
   INT_3=$(/bin/echo $CMD1 | awk '{ rec += $2 ; losspcnt += $3 } { printf("%d\n",( rec * losspcnt ) / 100 ) }' ) #nr of packets lost
#paso a decimal para comparador
COMP=$(/usr/bin/printf "%d\n" $INT_3 2>/dev/null) #nr of lost
VAL1=$(/usr/bin/printf "%d\n" $INT_1 2>/dev/null) #nr packets
VAL2=$(/usr/bin/printf "%0.2f\n" $INT_2 2>/dev/null) #pcnt of lost

fi #of fileexits

  if [ $COMP -gt $CRIT ] ;then
    echo "CRITICAL - Loss(pkts/15min)=$COMP Loss(%)=$VAL2 | Processed(pkts/15min)=$VAL1 Loss(pkts)=$COMP Loss(%)=$VAL2"
    exit $CRITICAL
  elif [ $COMP -gt $WARN ]; then
    echo "WARNING - Loss(pkts/15min)=$COMP Loss(%)=$VAL2 | Processed(pkts/15min)=$VAL1 Loss(pkts)=$COMP Loss(%)=$VAL2"
    exit $WARNING
  else
    echo "OK - Loss(pkts/15min)=$COMP Loss(%)=$VAL2 | Processed(pkts/15min)=$VAL1 Loss(pkts)=$COMP Loss(%)=$VAL2"
    exit $OK
  fi

#set +x
fi

