#!/bin/sh

# OpenClash Crash Guard Script
# Checks if clash API is responsive, restarts if needed
# After 3 failed retries, forcefully解除劫持

max_retry=3
count=0

while [ $count -lt $max_retry ]; do
    if curl -s --connect-timeout 2 http://127.0.0.1:9090 >/dev/null 2>&1; then
        # 健康
        exit 0
    fi
    /etc/init.d/openclash restart
    sleep 5
    count=$((count+1))
done

# 三次重启均失败，强制解除劫持
uci del_list dhcp.@dnsmasq[0].server='127.0.0.1#7874' 2>/dev/null
uci set dhcp.@dnsmasq[0].noresolv='0'
uci set dhcp.@dnsmasq[0].resolvfile='/tmp/resolv.conf.d/resolv.conf.auto'
uci commit dhcp
/etc/init.d/dnsmasq restart
