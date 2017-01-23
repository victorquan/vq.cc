---
title: 让git忽略ssl证书错误
date: 2017-01-23 16:21:21
tags: git,版本控制
---

当你通过HTTPS访问Git远程仓库，如果服务器的SSL证书未经过第三方机构签署，那么Git就会报错。这是十分合理的设计，毕竟未知的没有签署过的证书意味着很大安全风险。但是，如果你正好在架设Git服务器，而正式的SSL证书没有签发下来，你为了赶时间生成了自签署的临时证书，怎样才是最便捷的测试手段。

<!--more-->

一种比较好的做法：

### 第一步，克隆远程仓库时，用env命令设置GIT_SSL_NO_VERIFY环境变量为"ture"，并同时调用正常的git clone命令。完整的命令如下：
```
env GIT_SSL_NO_VERIFY=true git clone https://<host_name/git/project.git
```

### 第二步，在克隆完毕的仓库中将http.sslVerify设置为"false"。完整的命令如下：
```
git config http.sslVerify"false"
```

以上方法应该是Git处理可信任的SSL临时证书很好的方法，第一步使用env命令保证了忽略证书错误是单次行为，不会成为默认的设置。第二次，则把忽略证书错误的设置限定在特定的仓库，避免扩大该设置的适用范围而引起的潜在安全风险。

或者直接就使用命令：
```
git config --global http.sslVerifyfalse
```

