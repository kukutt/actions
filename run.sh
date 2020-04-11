#!/bin/bash

sudo apt-get update
sudo apt-get -y install jq

# api变量解析
jsshell=`cat $GITHUB_EVENT_PATH | jq ".action" | sed 's/\"//g'`

mkdir -p output
if [ ! -f "./$jsshell.sh" ];then
    echo "start run $jsshell" >> output/log.txt
    ./$jsshell.sh output
else
    echo "not find $jsshell !!" >> output/log.txt
fi
./test.sh
