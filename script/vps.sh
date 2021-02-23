#!/bin/bash

# api变量解析
# ./tmp/curlauto.sh kukutt token actions vps '{"sshport": "16543", "sshpwd": "xxx", "frpserver": "xxx.com", "frpport": "7008", "frptk": "xxx"}'
jssshport=`cat $GITHUB_EVENT_PATH | jq ".client_payload.sshport" | sed 's/\"//g'`
jssshuser=`whoami`
jssshpwd=`cat $GITHUB_EVENT_PATH | jq ".client_payload.sshpwd" | sed 's/\"//g'`
jsfrpserver=`cat $GITHUB_EVENT_PATH | jq ".client_payload.frpserver" | sed 's/\"//g'`
jsfrpport=`cat $GITHUB_EVENT_PATH | jq ".client_payload.frpport" | sed 's/\"//g'`
jsfrptk=`cat $GITHUB_EVENT_PATH | jq ".client_payload.frptk" | sed 's/\"//g'`

mkdir -p bin
# 准备frp
[ -f "./frp_0.20.0_linux_amd64.tar.gz" ] || wget https://github.com/fatedier/frp/releases/download/v0.20.0/frp_0.20.0_linux_amd64.tar.gz
[ -f "./frp_0.20.0_linux_amd64/frpc" ] || tar -zxvf frp_0.20.0_linux_amd64.tar.gz
[ -f "./bin/frpc" ] || cp ./frp_0.20.0_linux_amd64/frpc ./bin/

# 修改用户名
[ -n "$LOCALTEST" ] || sudo echo $jssshuser:$jssshpwd | sudo chpasswd

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
EOF
./bin/frpc -c frpc.ini > /dev/null 2>&1 &


echo user[$jssshuser]
sleep 300
while [ -f "$HOME/run" ]
do
    sleep 60
done
sleep 60

killall frpc
