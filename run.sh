#!/bin/bash
mkdir -p output
echo "start run $github.event.event_type" >> output/log.txt
./test.sh output
#./openwrt.sh output
#./socat.sh output
