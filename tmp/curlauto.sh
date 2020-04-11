#!/bin/bash

if [ $# != 5 ];then
    echo ./tmp/curlauto.sh username password repo type param[\''{"txt": "hello world", "msg": "nothing"}'\']
    exit 1
fi

datastr="'{\"event_type\":\"$4\", \"client_payload\": $5}'"

run="curl -X POST -u \"$1:$2\" -H \"Accept: application/vnd.github.everest-preview+json\" -H \"Content-Type: application/json\" --data $datastr https://api.github.com/repos/$1/$3/dispatches"

echo $run
`echo $run | /bin/bash`

