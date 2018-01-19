##!/bin/bash
#set -x
DROPRECCHECK=1
#BROCTL=/opt/bro/bin/broctl
#DROPS CRI Y WARN
CRIT=800000000
WARN=100000000

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


if [ $DROPRECCHECK -eq 1 ]; then
CMD1=$(/opt/wh-utils/capstats -i bond0 -I 1 -n 1 2>&1)
#megabit to bit
   INT_1=$(/bin/echo $CMD1 |  /bin/sed 's/[a-z]*=//g' | /usr/bin/awk '{ rec += $5 } END { printf("%d\n",rec*1000000) }')
#paso a decimal para comparador
COMP=$(/usr/bin/printf "%d\n" $INT_DROP 2>/dev/null)


  if [ $COMP -gt $CRIT ] ;then
    echo "CRITICAL - bits/sec=$INT_1 | bits/sec=$INT_1"
    exit $CRITICAL
  elif [ $COMP -gt $WARN ]; then
    echo "WARNING - bits/sec=$INT_1 |  bits/sec=$INT_1"
    exit $WARNING
  else
    echo "OK - bits/sec=$INT_1 |  bits/sec=$INT_1" #aca $CMD1 aa $BROCTL"
    exit $OK
  fi
fi

