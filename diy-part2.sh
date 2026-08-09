#!/bin/bash
#
# OpenWrt DIY script part 2 (After Install feeds)
#

# Modify default IP to bypass router LAN IP
sed -i 's/192.168.1.1/192.168.8.110/g' package/base-files/files/bin/config_generate

# Modify hostname to 玩客云
sed -i 's/LEDE/玩客云/g' package/base-files/files/bin/config_generate

# ========== Download OpenClash kernels (armv7) ==========
mkdir -p files/etc/openclash/core

# Get latest mihomo (Clash.Meta) release URL for armv7
MIHOMO_LATEST=$(curl -sL https://api.github.com/repos/MetaCubeX/mihomo/releases/latest | grep -oP '"tag_name":\s*"\K[^"]+')
if [ -n "$MIHOMO_LATEST" ]; then
    MIHOMO_URL="https://github.com/MetaCubeX/mihomo/releases/download/${MIHOMO_LATEST}/mihomo-linux-armv7-${MIHOMO_LATEST}.gz"
    curl -L "$MIHOMO_URL" -o /tmp/clash-armv7.gz
    if [ -f /tmp/clash-armv7.gz ]; then
        gzip -d -f /tmp/clash-armv7.gz
        cp /tmp/clash-armv7 files/etc/openclash/core/clash
        cp /tmp/clash-armv7 files/etc/openclash/core/clash_tun
        chmod +x files/etc/openclash/core/clash
        chmod +x files/etc/openclash/core/clash_tun
        echo "OpenClash kernels downloaded successfully: $MIHOMO_LATEST"
    else
        echo "WARNING: Failed to download mihomo kernel"
    fi
else
    echo "WARNING: Failed to get latest mihomo release version, trying direct download"
    # Fallback to a known stable version
    curl -L "https://github.com/MetaCubeX/mihomo/releases/download/v1.19.8/mihomo-linux-armv7-v1.19.8.gz" -o /tmp/clash-armv7.gz
    if [ -f /tmp/clash-armv7.gz ]; then
        gzip -d -f /tmp/clash-armv7.gz
        cp /tmp/clash-armv7 files/etc/openclash/core/clash
        cp /tmp/clash-armv7 files/etc/openclash/core/clash_tun
        chmod +x files/etc/openclash/core/clash
        chmod +x files/etc/openclash/core/clash_tun
        echo "OpenClash kernels downloaded (fallback v1.19.8)"
    fi
fi

# ========== Set executable permissions for scripts ==========
chmod +x files/etc/rc.local 2>/dev/null
chmod +x files/etc/firewall.user 2>/dev/null
chmod +x files/usr/bin/onecloud-led.sh 2>/dev/null
chmod +x files/etc/init.d/onecloud-led 2>/dev/null
chmod +x files/etc/uci-defaults/99-openclash-settings 2>/dev/null
chmod +x files/etc/uci-defaults/99-harbor-settings 2>/dev/null
chmod +x files/etc/uci-defaults/99-vsftpd-settings 2>/dev/null
chmod +x files/etc/uci-defaults/99-led-settings 2>/dev/null
