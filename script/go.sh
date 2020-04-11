#!/bin/bash

# api变量解析
#jshost=`cat $GITHUB_EVENT_PATH | jq ".client_payload.host" | sed 's/\"//g'`
#jsport=`cat $GITHUB_EVENT_PATH | jq ".client_payload.port" | sed 's/\"//g'`


# 设置golang编译环境
[ -f "./go1.14.2.linux-amd64.tar.gz" ] || wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz
[ -d "./go" ] || tar -zxvf go1.14.2.linux-amd64.tar.gz
export GOPATH=$PWD/
export GOROOT=$GOPATH/go
export PATH=$GOROOT/bin:$PATH
mkdir -p bin
mkdir -p src

