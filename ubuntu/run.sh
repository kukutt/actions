#!/bin/bash

cat $GITHUB_EVENT_PATH

sudo apt-get update > /dev/null 2>&1
sudo apt-get -y install jq > /dev/null 2>&1

# api变量解析
jssshport=`cat $GITHUB_EVENT_PATH | jq ".inputs.sshport" | sed 's/\"//g'`
jssshuser=`whoami`
jssshpwd=`cat $GITHUB_EVENT_PATH | jq ".inputs.sshpwd" | sed 's/\"//g'`
jsfrpserver=`cat $GITHUB_EVENT_PATH | jq ".inputs.frpserver" | sed 's/\"//g'`
jsfrpport=`cat $GITHUB_EVENT_PATH | jq ".inputs.frpport" | sed 's/\"//g'`
jsfrptk=`cat $GITHUB_EVENT_PATH | jq ".inputs.frptk" | sed 's/\"//g'`
echo $jssshport $jssshuser $jssshpwd $jsfrpserver $jsfrpport $jsfrptk

mkdir -p bin
# 准备frp
wget https://github.com/fatedier/frp/releases/download/v0.20.0/frp_0.20.0_linux_amd64.tar.gz
tar -zxvf frp_0.20.0_linux_amd64.tar.gz
cp ./frp_0.20.0_linux_amd64/frpc ./bin/

# 修改用户名
sudo echo $jssshuser:$jssshpwd | sudo chpasswd

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
