# IPv6-In-Tsinghua-for-Ubuntu

Set up ipv6 tunnel automaticly when available for ubuntu in THU. The code is still dirty and buggy. It works on most occations, but gives buggy behaviors sometimes.

How to use:

Download ipv6tunnelcfg.sh:

```bash
wget https://github.com/SuanNiZhouZi/IPv6-In-Tsinghua-for-Ubuntu/blob/master/ipv6tunnelcfg.sh
```

Put ipv6tunnelcfg.sh at /etc/NetworkManager/dispatcher.d/ :

```bash
sudo cp ipv6tunnelcfg.sh /etc/NetworkManager/dispatcher.d/
```

Give ipv6tunnelcfg.sh excute permission:

```bash
sudo chmod 744 /etc/NetworkManager/dispatcher.d/ipv6tunnelcfg.sh
```
