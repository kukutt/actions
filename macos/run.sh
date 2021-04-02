#!/bin/bash -e

ifconfig
netstat -ant

brew update
brew install jq

# api变量解析
jssshport=`cat $GITHUB_EVENT_PATH | jq ".inputs.sshport" | sed 's/\"//g'`
jssshuser=`whoami`
jssshpwd=`cat $GITHUB_EVENT_PATH | jq ".inputs.sshpwd" | sed 's/\"//g'`
jsfrpserver=`cat $GITHUB_EVENT_PATH | jq ".inputs.frpserver" | sed 's/\"//g'`
jsfrpport=`cat $GITHUB_EVENT_PATH | jq ".inputs.frpport" | sed 's/\"//g'`
jsfrptk=`cat $GITHUB_EVENT_PATH | jq ".inputs.frptk" | sed 's/\"//g'`

echo $jsfrptk
