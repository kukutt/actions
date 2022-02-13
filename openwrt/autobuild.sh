#!/bin/bash

# 获取工作路径
homePath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workPath=$PWD
echo work dir [$homePath] [$workPath]

cd $homePath

# 安装基础工具
if [ ! -f "./openwrt_tool" ];then
    touch ./openwrt_tool
    sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint
fi

# clone代码
if [ ! -d "$homePath/openwrt" ];then
    git clone -b v21.02.1 https://github.com/openwrt/openwrt
fi
cd ./openwrt

# 更新
if [ ! -f "./updateok" ];then
    touch ./updateok
    ./scripts/feeds update -a
    ./scripts/feeds install -a
fi

# 配置
if [ ! -d "./files" ];then
    ln -s ../files ./files
fi

. ../cfg.sh $1
if [ ! -f "./.config" ];then
    cp .configtmp .config
    make defconfig
fi

# 编译
if [ ! -d "./bin" ];then
    make V=99
fi

# output

#OUTDIR=../output-$BUILDDEV
OUTDIR=../output/
rm -rf $OUTDIR
mkdir -p $OUTDIR
find $PWD/bin/targets -name $BINNAME | xargs -I {} cp {} $OUTDIR
find $PWD/bin/targets -name $MFNAME | xargs -I {} cp {} $OUTDIR

