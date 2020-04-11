# actions
github actions编译脚本, 实现api调用不同的shell执行不同功能

# 运行轨迹
.github/workflows/blank.yml -> ./test.sh(此脚本选择最终脚本) -> 最终脚本  

通过api调用POST /repos/:owner/:repo/dispatches  

```shell
#$user:用户名  
#$password:密码
#$repo:库名
#$shell:运行shell脚本
#$param:参数,json格式
curl -X POST -u "$user:$password" -H "Accept: application/vnd.github.everest-preview+json" -H "Content-Type: application/json" \
             --data '{"event_type":"$shell", "client_payload": $param}'\ 
             https://api.github.com/repos/$user/$repo/dispatches
```

# 其他记录 
本地测试命令  
GITHUB_EVENT_PATH=$PWD/tmp/test.json LOCALTEST=y ./run.sh

# 最终脚本共解释
|脚本名|功能|参数|
|---|---|---|
|test.sh|测试||
|openwrt.sh|openwrt编译例程 k3为例||
|socat.sh|反向隧道登录actions 注意修改服务器名字||

# 版本说明
|文章url|版本号|分支|
|---|---|---|
|0|ac9fcf46971f70f404272c61883a1856761254e3|/|
|0|67d7b4fd6456b4157dc31feeaea34f59642b1829|/|

