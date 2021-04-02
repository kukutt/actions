#!/bin/bash -e

#brew update
#brew install jq
brew install socat


# api变量解析
jssshport=`cat $GITHUB_EVENT_PATH | jq ".inputs.sshport" | sed 's/\"//g'`
jssshuser=`whoami`
jssshpwd=`cat $GITHUB_EVENT_PATH | jq ".inputs.sshpwd" | sed 's/\"//g'`
jsfrpserver=`cat $GITHUB_EVENT_PATH | jq ".inputs.frpserver" | sed 's/\"//g'`
jsfrpport=`cat $GITHUB_EVENT_PATH | jq ".inputs.frpport" | sed 's/\"//g'`
jsfrptk=`cat $GITHUB_EVENT_PATH | jq ".inputs.frptk" | sed 's/\"//g'`

mkdir -p bin
# 准备frp
wget https://github.com/fatedier/frp/releases/download/v0.20.0/frp_0.20.0_darwin_amd64.tar.gz
tar -zxvf frp_0.20.0_darwin_amd64.tar.gz
cp frp_0.20.0_darwin_amd64/frpc ./bin/

# 修改用户名
#echo "aaaaa1"$jssshuser
#dscl . -list /Users
#echo "aaaaa2"
#sudo rm -r /Users/$jssshuser/Library/Keychains/*
#echo "aaaaa3"
#sudo dscl . -passwd /Users/$jssshuser $jssshpwd
#echo "aaaaa4"
#sudo dscl . -create /Users/tttt UserShell /bin/bash
#sudo dscl . -create /Users/tttt
echo "aaaaa5"
#sudo dscl . -passwd /Users/tttt $jssshpwd
#echo socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:$jsfrpserver:$jsfrpport
#socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:$jsfrpserver:$jsfrpport
resetpassword
dscl . -passwd /Users/$jssshuser $jssshpwd

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
