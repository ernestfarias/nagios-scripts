##!/bin/bash
#set -x
DROPRECCHECK=1
#BROCTL=/opt/bro/bin/broctl
#DROPS CRI Y WARN
CRIT=20000
WARN=100

OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3
#1			2   3		4	5	6	  7	     8   9   10  11   12	
#1504708566.801490 pkts=3 kpps=0.0 kbytes=0 mbps=0.0 nic_pkts=3 nic_drops=0 u=2 t=0 i=0 o=0 nonip=1
#pkts:	Absolute number of packets seen by capstats during interval.
#kpps:	Number of thousands of packets per second.
#kbytes:	Absolute number of KBytes during interval.
#mbps:	Mbits/sec.
#nic_pkts:	Number of packets as reported by libpcap‘s pcap_stats() (may not match pkts)
#nic_drops:	Number of packet drops as reported by libpcap‘s pcap_stats().
#u:	Number of UDP packets.
#t:	Number of TCP packets.
#i:	Number of ICMP packets.
#o:	Number of IP packets with protocol other than TCP, UDP, and ICMP.
#nonip:	Number of non-IP packets.

#iostat -x -k  1 1 -d /dev/sda | tail -2
#1		2	3	    4	    5	    6	     7	     8	      9		10	11	12	13    14	
#Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
#sda               0,02     2,00    1,41    1,58     9,14   116,07    83,72     0,00    0,39    0,23    0,53   0,12   0,04
#
#  FLOAT_LOSS=$($BROCTL netstats | grep "$WORKERS" | sed 's/[a-z]*=//g' | awk '{ drop += $4 ; link += $5 } END { printf("%f\n", ((drop/NR) / (link/NR))* 100) }')
#  LOSS=$(/usr/bin/printf "%d\n" $FLOAT_LOSS 2>/dev/null)

#

if [ $DROPRECCHECK -eq 1 ]; then
CMD1=$(iostat -x -k  1 1 -d /dev/sdb | tail -2 2>&1)
   INT_1=$(/bin/echo $CMD1 |  /bin/sed 's/[a-z]*=//g' | sed '/[0-9]\,/s/\,/./g' | /usr/bin/awk '{ rec += $2 } END { printf("%.2f\n",rec) }')
   INT_2=$(/bin/echo $CMD1 | /bin/sed 's/[a-z]*=//g' | sed '/[0-9]\,/s/\,/./g' |/usr/bin/awk '{ dropped += $3 } END { printf("%.2f\n",dropped) }')
   INT_3=$(/bin/echo $CMD1 | /bin/sed 's/[a-z]*=//g' |sed '/[0-9]\,/s/\,/./g' | /usr/bin/awk '{ dropped += $9 } END { printf("%.2f\n",dropped) }')

CRITINT=$(/usr/bin/printf "%d\n" $INT_3 2>/dev/null)
#IREC=$(/usr/bin/printf "%d\n" $INT_REC 2>/dev/null)


  if [ $CRITINT -gt $CRIT ] ;then
    echo "CRITICAL - Queue:$INT_3 | 'IO-ReadReq(req/s)'=$INT_1 IO-WriteReq(req/s)=$INT_2 QueueSize(#Req)=$INT_3"
    exit $CRITICAL
  elif [ $CRITINT -gt $WARN ]; then
    echo "WARNING - Queue:$INT_3 | 'IO-ReadReq(req/s)'=$INT_1 IO-WriteReq(req/s)=$INT_2 QueueSize(#Req)=$INT_3"
    exit $WARNING
  else
    echo "OK - Queue:$INT_3 | 'IO-ReadReq(req/s)'=$INT_1 IO-WriteReq(req/s)=$INT_2 QueueSize(#Req)=$INT_3" #aca $CMD1 aa $BROCTL"
    exit $OK
  fi
fi

