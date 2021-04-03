#!/bin/bash -e

#brew update
#brew install jq
brew install socat
socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp::8888


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

# 新增用户
sudo dscl . -create /Users/panyao
sudo dscl . -create /Users/panyao UserShell /bin/bash
sudo dscl . -create /Users/panyao RealName "PanYao"
## 注意 UniqueID必须唯一
sudo dscl . -create /Users/panyao UniqueID "1010"
sudo dscl . -create /Users/panyao PrimaryGroupID 80
sudo dscl . -create /Users/panyao NFSHomeDirectory /Users/panyao
## 修改密码:
sudo dscl . -passwd /Users/panyao $jssshpwd
## 加入admin用户组
sudo dscl . -append /Groups/admin GroupMembership panyao


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
pwd
sleep 300
while [ -f "$HOME/run" ]
do
    sleep 60
done
sleep 60

killall frpc
