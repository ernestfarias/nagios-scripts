##!/bin/bash
#set -x
DROPRECCHECK=1
#BROCTL=/opt/bro/bin/broctl
#DROPS CRI Y WARN
CRIT=900000000000
WARN=100000000000

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

#du /mnt/data/* -s | grep /mnt/data/bro | awk '{print $1}'


if [ $DROPRECCHECK -eq 1 ]; then
CMD1=$(du /mnt/data* -sb  2>&1)
#megabit to bit
   INT_1=$(/bin/echo $CMD1 |grep /mnt/data/bro | awk '{print $1}')
   INT_2=$(/bin/echo $CMD1 |grep /mnt/data2/steno | awk '{print $7}')
#echo $CMD1
#paso a decimal para comparador
COMP=$(/usr/bin/printf "%d\n" $INT_1 2>/dev/null)


  if [ $COMP -gt $CRIT ] ;then
    echo "CRITICAL - BRO:DiskUsage(Bytes)=$INT_1 Steno:DiskUsage(Bytes)=$INT_2| BRO:DiskUsage(Bytes)=$INT_1 Steno:DiskUsage(Bytes)=$INT_2"
    exit $CRITICAL
  elif [ $COMP -gt $WARN ]; then
    echo "WARNING - BRO:DiskUsage(Bytes)=$INT_1 Steno:DiskUsage(Bytes)=$INT_2| BRO:DiskUsage(Bytes)=$INT_1 Steno:DiskUsage(Bytes)=$INT_2"
    exit $WARNING
  else
    echo "OK - BRO:DiskUsage(Bytes)=$INT_1 Steno:DiskUsage(Bytes)=$INT_2| BRO:DiskUsage(Bytes)=$INT_1 Steno:DiskUsage(Bytes)=$INT_2"
    exit $OK
  fi
fi

