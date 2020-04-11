#!/bin/bash

# api变量解析
jstxt=`cat $GITHUB_EVENT_PATH | jq ".client_payload.txt" | sed 's/\"//g'`


# 正常执行
echo [$jstxt] >> $1/log.txt
#export >> $1/log.txt
#env >> $1/log.txt
#sudo cat $GITHUB_EVENT_PATH >> $1/log.txt
#sudo cp  $GITHUB_EVENT_PATH >> $1/
