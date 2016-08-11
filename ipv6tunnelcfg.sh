#!/bin/bash

if [ -z "$1" ]; then
    echo "$0: called with no interface" 1>&2
    exit 1;
fi

case "$2" in
    up)
      #Get established connections' IP address
      local_ip=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "{addr}:" `
      
      #If there are more than 1 interfaces, set up tunnel on eth0 as default
      local_ip_num=`wc -l <<< "$local_ip"`

      if [ "$local_ip_num" -gt 1 ]; then
          local_ip=`/sbin/ifconfig eth0|grep inet|grep -v inet6|awk '{print $2}'|tr -d "{addr}:" `
      fi
      
      #IP addresses of Tsinghua University
      tsinghua_ip=(59.66.0.0/16 101.5.0.0/16 101.6.0.0/16 106.120.132.0/22 118.229.0.0/19 166.111.0.0/16 183.172.0.0/16 183.173.0.0/16 202.112.3.0/24 202.112.35.0/24 202.112.39.0/24 202.112.43.0/24 202.112.44.0/24 202.112.45.0/24 202.112.47.0/24 202.112.48.0/24 202.112.49.0/24 202.112.50.0/24 202.112.51.0/24 202.112.52.0/24 202.112.53.0/24 202.112.54.0/24 202.112.55.0/24 202.112.56.0/24 202.112.57.0/24 202.112.58.0/24 202.38.99.0/24 211.68.126.0/24 211.68.17.0/24)

      #A bool vairable to denote whether $local_ip is in $tsinghua_ip, 1 for is, 1 for not. 0 default. 
      in_tsinghua=0

      for i in "${tsinghua_ip[@]}"
      do
        ip_segment=$( echo $i | cut -d"/" -f1 )
        ip_CIDR=$( echo $i | cut -d"/" -f2 )
        IFS=. read -r a b c d <<< "$ip_segment"
        ip_num="$(((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d)>>(32-ip_CIDR)))"
        IFS=. read -r a b c d <<< "$local_ip"
        local_ip_num="$(((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d)>>(32-ip_CIDR)))"
        if [ "$ip_num" == "$local_ip_num" ]; then
          in_tsinghua=1
          break
        fi
      done 
      
      #If the system get a THU IP
      if [ "$in_tsinghua" == "1" ]; then
        #If the system don't get IPv6 address through DHCPv6
        if [ ! -n "`/sbin/ifconfig -a|grep inet6|grep Scope:Global`" ]; then
          #If there are not existing tunnel
          if [ ! -n "`ip tunnel list|grep sit1`" ]; then
            ip tunnel add sit1 mode sit remote 166.111.21.1 local $local_ip
            ifconfig sit1 up
            ifconfig sit1 add 2402:f000:1:1501:200:5efe:$local_ip/64
            ip route add ::/0 via 2402:f000:1:1501::1 metric 1
          fi
        fi
      fi
      ;;
      
    down)
      if [ ! -n "$local_ip" ]; then
        if [ -n "`ip tunnel list|grep sit1`" ]; then
          ip route del ::/0 via 2402:f000:1:1501::1 dev sit1
          ip link set sit1 down
          ip tunnel del sit1
        fi
      fi
      ;;
esac
