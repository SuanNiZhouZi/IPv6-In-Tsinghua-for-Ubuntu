# IPv6-In-Tsinghua-for-Ubuntu

Set up ipv6 tunnel automaticly when available for ubuntu in THU. For Linux PCs can not config ISATAP automaticly in Tsinghua University, it is much of inconvenience. This script is written to free Ubuntu users from configing ipv6 tunnel manually when they are in libraries or laboratories where DHCPv6 is not available. It works by checking the IP address a Ubuntu computer get belongs to THU or not (so it only works when connects to THU network derectly). If it does, an ipv6 tunnel named "sit1" will be set up automaticly and be destoryed when disconnected. It supports multiple network, if you set your Ubuntu PC as a router or sth else. If you use other distrbutions of Linux, such as Debian or CentOS, you can divide the script into "ifup" part and "ifdown" part to adapt it to your system.

The code is still dirty. It works on most occations, but gives buggy behaviors sometimes (I'm still testing). 

##How to use:

Download ipv6tunnelcfg.sh:

```bash
wget https://github.com/SuanNiZhouZi/IPv6-In-Tsinghua-for-Ubuntu/archive/v0.5.tar.gz
```

Unzip IPv6-In-Tsinghua-for-Ubuntu-0.5.tar.gz
```bash
tar -xf IPv6-In-Tsinghua-for-Ubuntu-0.5.tar.gz
```

Put ipv6tunnelcfg.sh at /etc/NetworkManager/dispatcher.d/ :

```bash
cd IPv6-In-Tsinghua-for-Ubuntu-0.5
sudo cp ipv6tunnelcfg.sh /etc/NetworkManager/dispatcher.d/
```

Give ipv6tunnelcfg.sh excute permission:

```bash
sudo chmod 744 /etc/NetworkManager/dispatcher.d/ipv6tunnelcfg.sh
```
