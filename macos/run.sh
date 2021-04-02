#!/bin/bash -e

cat $GITHUB_EVENT_PATH
ifconfig
netstat -ant
