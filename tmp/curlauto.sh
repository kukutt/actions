#!/bin/bash

if [ $# != 4 ];then
    echo ./tmp/curlauto.sh username password type param[\''{"txt": "hello world", "msg": "nothing"}'\']
    exit 1
fi

datastr="'{\"event_type\":\"$3\", \"client_payload\": $4}'"

run="curl -X POST -u \"$1:$2\" -H \"Accept: application/vnd.github.everest-preview+json\" -H \"Content-Type: application/json\" --data $datastr https://api.github.com/repos/kukutt/actions/dispatches"

echo $run
`echo $run | /bin/bash`

