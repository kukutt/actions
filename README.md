# actions
github actions编译脚本, 实现api调用不同的shell执行不同功能
关注我的[头条](https://www.toutiao.com/c/user/105101072129/#mid=0)

# 运行轨迹
.github/workflows/blank.yml -> ./run.sh(此脚本选择最终脚本) -> script中最终脚本  

通过api调用POST /repos/:owner/:repo/dispatches  
```shell
#$user:用户名  
#$password:密码
#$repo:库名
#$shell:运行shell脚本
#$param:参数,json格式
curl -X POST -u "$user:$password" -H "Accept: application/vnd.github.everest-preview+json" \
             -H "Content-Type: application/json" \
             --data '{"event_type":"$shell", "client_payload": $param}'\ 
             https://api.github.com/repos/$user/$repo/dispatches
```

# script中最终脚本解释
|脚本名|功能|备注|
|---|---|---|
|test.sh|测试|/|
|openwrt.sh|openwrt编译例程 k3为例|/|
|socat.sh|反向隧道登录actions,公网ip服务器`./socat file:`tty`,raw,echo=0 tcp-listen:8888`|'{"host": "xxx.com", "port": "8888"}'|
|ss.sh|查看国外文献工具|/|
|go.sh|go get 后,下载|/|
|vps.sh|socat.sh升级版|登录后,touch run可以让脚本保持 '{"sshport": "16543", "sshpwd": "xxx", "frpserver": "xxx.com", "frpport": "7008", "frptk": "xxx"}'|

# 测试工具
测试工具放在./tmp/下  
|文件名|功能|备注|
|---|---|---|
|test.json|模拟GITHUB_EVENT_PATH文件,方便本地调试|GITHUB_EVENT_PATH=$PWD/tmp/test.json LOCALTEST=y ./run.sh|
|curlauto.sh|建议api发送工具|./tmp/curlauto.sh username password repo type param['{"txt": "hello world", "msg": "nothing"}']|


# 头条文章对应说明
|文章url|版本号|分支|
|---|---|---|
|https://www.toutiao.com/i6813342317114556931/?group_id=6813342317114556931|ac9fcf46971f70f404272c61883a1856761254e3|/|
|https://www.toutiao.com/i6814079749422318087/?group_id=6814079749422318087|67d7b4fd6456b4157dc31feeaea34f59642b1829|/|

