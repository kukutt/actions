#!/bin/bash

# api变量解析
jssshport=`cat $GITHUB_EVENT_PATH | jq ".client_payload.sshport" | sed 's/\"//g'`
jssshuser=`whoami`
jssshpwd=`cat $GITHUB_EVENT_PATH | jq ".client_payload.sshpwd" | sed 's/\"//g'`
jsfrpserver=`cat $GITHUB_EVENT_PATH | jq ".client_payload.frpserver" | sed 's/\"//g'`
jsfrpport=`cat $GITHUB_EVENT_PATH | jq ".client_payload.frpport" | sed 's/\"//g'`
jsfrptk=`cat $GITHUB_EVENT_PATH | jq ".client_payload.frptk" | sed 's/\"//g'`
jsssport=`cat $GITHUB_EVENT_PATH | jq ".client_payload.ssport" | sed 's/\"//g'`
jssskey=`cat $GITHUB_EVENT_PATH | jq ".client_payload.sskey" | sed 's/\"//g'`
jsssm=`cat $GITHUB_EVENT_PATH | jq ".client_payload.ssm" | sed 's/\"//g'`
jstimeout=`cat $GITHUB_EVENT_PATH | jq ".client_payload.timeout" | sed 's/\"//g'`

mkdir -p bin
# 准备ss
[ -f "./shadowsocks-server.tar.gz" ] || wget https://github.com/shadowsocks/shadowsocks-go/releases/download/1.2.1/shadowsocks-server.tar.gz
[ -f "./bin/shadowsocks-server" ] || tar -zxf shadowsocks-server.tar.gz -C ./bin

# 准备frp
[ -f "./frp_0.20.0_linux_amd64.tar.gz" ] || wget https://github.com/fatedier/frp/releases/download/v0.20.0/frp_0.20.0_linux_amd64.tar.gz
[ -f "./frp_0.20.0_linux_amd64/frpc" ] || tar -zxvf frp_0.20.0_linux_amd64.tar.gz
[ -f "./bin/frpc" ] || cp ./frp_0.20.0_linux_amd64/frpc ./bin/

# 修改用户名
[ -n "$LOCALTEST" ] || sudo echo $jssshuser:$jssshpwd | sudo chpasswd

# 运行
./bin/shadowsocks-server -u -k $jssskey -p $jsssport -m $jsssm > /dev/null 2>&1 &

rm -rf frpc.ini
cat >> frpc.ini <<EOF
[common]
server_addr = $jsfrpserver
server_port = $jsfrpport
privilege_token = $jsfrptk

[ss_actions_ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = $jssshport

[ss_actions_tcp]
type = tcp
local_ip = 127.0.0.1
local_port = $jsssport
remote_port = $jsssport

[ss_actions_udp]
type = udp
local_ip = 127.0.0.1
local_port = $jsssport
remote_port = $jsssport
EOF
./bin/frpc -c frpc.ini > /dev/null 2>&1 &


echo user[$jssshuser] sleep[$jstimeout]
sleep $jstimeout
killall shadowsocks-server
killall frpc
