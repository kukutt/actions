#!/bin/bash

# api变量解析
#jshost=`cat $GITHUB_EVENT_PATH | jq ".client_payload.host" | sed 's/\"//g'`
#jsport=`cat $GITHUB_EVENT_PATH | jq ".client_payload.port" | sed 's/\"//g'`

# 准备ss
[ -f "./shadowsocks-server.tar.gz"] || wget https://github.com/shadowsocks/shadowsocks-go/releases/download/1.2.1/shadowsocks-server.tar.gz
[ -f "./bin/shadowsocks-server" ] || tar -zxf shadowsocks-server.tar.gz -C ./bin

# 准备frp
[ -f "./frp_0.20.0_linux_amd64.tar.gz" ] || wget https://github.com/fatedier/frp/releases/download/v0.20.0/frp_0.20.0_linux_amd64.tar.gz
[ -f "./frp_0.20.0_linux_amd64/frpc" ] || tar -zxvf frp_0.20.0_linux_amd64.tar.gz
[ -f "./bin/frpc" ] || cp ./frp_0.20.0_linux_amd64/frpc ./bin/
