#!/bin/bash
echo "i've done nothing"
export >> $1/log.txt
env >> $1/log.txt
cat $GITHUB_EVENT_PATH >> $1/log.txt
cp  $GITHUB_EVENT_PATH >> $1/
