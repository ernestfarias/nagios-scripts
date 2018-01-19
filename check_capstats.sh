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


if [ $DROPRECCHECK -eq 1 ]; then
CMD1=$(/opt/wh-utils/capstats -i bond0 -I 1 -n 1 2>&1)
   INT_REC=$(/bin/echo $CMD1 |  /bin/sed 's/[a-z]*=//g' | /usr/bin/awk '{ rec += $2 } END { printf("%d\n",rec) }')
   INT_DROP=$(/bin/echo $CMD1 | /bin/sed 's/[a-z]*=//g' | /usr/bin/awk '{ dropped += $7 } END { printf("%d\n",dropped) }')
   INT_UDP=$(/bin/echo $CMD1 | /bin/sed 's/[a-z]*=//g' | /usr/bin/awk '{ dropped += $8 } END { printf("%d\n",dropped) }')
   INT_TCP=$(/bin/echo $CMD1 | /bin/sed 's/[a-z]*=//g' | /usr/bin/awk '{ dropped += $9 } END { printf("%d\n",dropped) }')
   INT_ICMP=$(/bin/echo $CMD1 | /bin/sed 's/[a-z]*=//g' | /usr/bin/awk '{ dropped += $10 } END { printf("%d\n",dropped) }')
   INT_NOPROTO=$(/bin/echo $CMD1 | /bin/sed 's/[a-z]*=//g' | /usr/bin/awk '{ dropped += $11 } END { printf("%d\n",dropped) }')
   INT_NOIP=$(/bin/echo $CMD1 | /bin/sed 's/[a-z]*=//g' | /usr/bin/awk '{ dropped += $12 } END { printf("%d\n",dropped) }')

IDROP=$(/usr/bin/printf "%d\n" $INT_DROP 2>/dev/null)
IREC=$(/usr/bin/printf "%d\n" $INT_REC 2>/dev/null)


  if [ $INT_DROP -gt $CRIT ] ;then
    echo "CRITICAL - | 'REC(pkt/s)'=$INT_REC DROP=$INT_DROP UDP(pkt)=$INT_UDP TCP(ptk)=$INT_TCP ICMP(pkt)=$INT_ICMP NoProto(pkt)=$INT_PROTO NoIP(pkt)=$INT_NOIP"
    exit $CRITICAL
  elif [ $INT_DROP -gt $WARN ]; then
    echo "WARNING - | 'REC(pkt/s)'=$INT_REC DROP=$INT_DROP UDP(pkt)=$INT_UDP TCP(ptk)=$INT_TCP ICMP(pkt)=$INT_ICMP NoProto(pkt)=$INT_PROTO NoIP(pkt)=$INT_NOIP"
    exit $WARNING
  else
    echo "OK - | 'REC(pkt/s)'=$INT_REC DROP=$INT_DROP UDP(pkt)=$INT_UDP TCP(ptk)=$INT_TCP ICMP(pkt)=$INT_ICMP NoProto(pkt)=$INT_PROTO NoIP(pkt)=$INT_NOIP" #aca $CMD1 aa $BROCTL"
    exit $OK
  fi
fi

