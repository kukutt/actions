#!/bin/bash
echo "i've done nothing"
export >> $1/log.txt
env >> $1/log.txt
sudo cat $GITHUB_EVENT_PATH >> $1/log.txt
#sudo cp  $GITHUB_EVENT_PATH >> $1/
