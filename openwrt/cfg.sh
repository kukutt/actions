#!/bin/bash

# 获取工作路径
homePath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workPath=$PWD
echo work dir [$homePath] [$workPath]

BUILDDEV=r7800
if [ -n "$1" ]; then  
    BUILDDEV=$1
fi    

init_head() {
    cat > files/root/init.sh << EOF
#!/bin/sh

. /root/myapi.sh
EOF
}

init_port() {
    cat >> files/root/init.sh << EOF
uci add firewall rule
uci set firewall.@rule[-1].src='wan'
uci set firewall.@rule[-1].target='ACCEPT'
uci set firewall.@rule[-1].proto='tcp'
uci set firewall.@rule[-1].dest_port='22'
EOF
}

init_setsta() {
    cat >> files/root/init.sh << EOF
uci set wireless.default_radio0.network='wanb'
uci set wireless.default_radio0.mode='sta'
uci set wireless.default_radio0.ssid='chouchouchou-test'
uci set wireless.default_radio0.key='xianxianxian'
uci set wireless.default_radio0.encryption='psk-mixed'
uci commit wireless

uci set network.wanb=interface
uci set network.wanb.proto='dhcp'
uci commit network

uci set firewall.@zone[1].network='wan wanb wan6'
uci commit firewall

/etc/init.d/network restart
/etc/init.d/firewall restart
EOF
}

cd $homePath/openwrt
git checkout .
export MFNAME="*.manifest"

init_head
init_port
case $1 in
    7688)
        echo 7688
        cat > .configtmp << EOF
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt76x8=y
CONFIG_TARGET_ramips_mt76x8_DEVICE_mediatek_linkit-smart-7688=y
EOF
        export BINNAME="*linkit-smart*sysupgrade*.bin"
        sed -i 's/set wireless.radio${devidx}.disabled=1/set wireless.radio${devidx}.disabled=0/g' ./package/kernel/mac80211/files/lib/wifi/mac80211.sh
        init_setsta
        ;;
    mimini)
        echo mimini
        cat > .configtmp << EOF
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7620=y
CONFIG_TARGET_ramips_mt7620_DEVICE_xiaomi_miwifi-mini=y
EOF
        export BINNAME="*miwifi*sysupgrade*.bin"
        ;;
    k3)
        echo k3
        cat > .configtmp << EOF
CONFIG_TARGET_bcm53xx=y
CONFIG_TARGET_bcm53xx_generic_DEVICE_phicomm_k3=y
EOF
        export BINNAME="*k3*.trx"
        sed -i '/TARGET_DEVICES += tplink_archer-c5-v2/d' ./target/linux/bcm53xx/image/Makefile
        sed -i '/TARGET_DEVICES += tplink_archer-c9-v1/d' ./target/linux/bcm53xx/image/Makefile
        ;;
    *)
        echo 7800
        cat > .configtmp << EOF
CONFIG_TARGET_ipq806x=y
CONFIG_TARGET_ipq806x_generic=y
CONFIG_TARGET_ipq806x_generic_DEVICE_netgear_r7800=y
EOF
        export BINNAME="*r7800*.bin"
        ;;
esac

    cat >> .configtmp << EOF
CONFIG_ALL_KMODS=y
CONFIG_ALL_NONSHARED=y
CONFIG_DEVEL=y
CONFIG_TARGET_PER_DEVICE_ROOTFS=y
CONFIG_AUTOREMOVE=y
CONFIG_BUILDBOT=y
CONFIG_COLLECT_KERNEL_DEBUG=y
CONFIG_IB=y
CONFIG_IMAGEOPT=y
CONFIG_JSON_OVERVIEW_IMAGE_INFO=y
CONFIG_KERNEL_BUILD_DOMAIN="buildhost"
CONFIG_KERNEL_BUILD_USER="builder"
# CONFIG_KERNEL_KALLSYMS is not set
CONFIG_TARGET_PREINIT_IP="192.168.0.1"
CONFIG_TARGET_PREINIT_NETMASK="255.255.255.0"
CONFIG_TARGET_PREINIT_BROADCAST="192.168.0.255"
EOF
