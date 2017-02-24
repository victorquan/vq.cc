---
title: XX-net的配置笔记
date: 2017-02-24 17:04:34
cover:
tags: [xx-net,Internet]
---


昨晚[全球最大的同性交友网站 Github 上不去了](https://www.v2ex.com/t/342757#reply46)！

感觉我们就像是在一个庞大的局域网中不亦乐乎地生活着，作为对科学技术有浓厚兴趣的每一位朋友来讲，学会科学合法上网非常有必要。

今天笔者将记录一种科学上网的一种方法（仅介绍Mac下），方便自己日后再次使用。如果能给大家带来微小的帮助的话，我也很开心。

#### 1、首先下载xx-net源码
```
$ cd ~
$ git clone https://github.com/XX-net/XX-Net.git
```

源项目详见：[xx-net](https://github.com/XX-net/XX-Net)

#### 2、安装chrome SwitchyOmega扩展
在以下文章中，我有介绍过安装SwitchyOmega扩展的方法：
[SwitchyOmega安装](http://victorquan.com/2017/02/22/%E9%85%8D%E7%BD%AE%E8%87%AA%E5%B7%B1%E7%9A%84MAC/)

```
$ wget https://github.com/victorquan/Mac-Terminal-and-Vim-configuration/blob/master/SwitchyOmega.crx
```

#### 3、启动xx-net
```
$ ~/XX-net/start
```

如果你不想使用XX-net自带的公共appid的话，那么需要按照以下方法申请自己的appid

#### 4、登录google账户
进入[https://www.google.com/ncr](https://www.google.com/ncr)


#### 5、创建appid
点击页面右上角“project”->“创建项目”，输入“项目名称”之后自动为你生成了一个appid，把它记下来。

![创建appid](/img/xx-net/createPrj.png)


#### 6、设置appid引擎
进入[https://console.cloud.google.com/start](https://console.cloud.google.com/start)

点击激活云端shell，如下图所示

![激活shell](/img/xx-net/shell.png)

等激活云端shell之后，输入以下命令：

```
$ gcloud config set project 刚才记下来的appid
$ gcloud beta app create --region us-central
```

当显示success之后表示已设置成功

反复操作5、6步骤可以重复创建多个appid，最多可以创建12个。

#### 7、部署服务端配置

- 1）打开设置页：[http://127.0.0.1:8085/](http://127.0.0.1:8085/)

- 2）如下图输入appid，点击“开始部署”

![部署服务端](/img/xx-net/deploySetting.png)

- 3）配置GAEProxy

![配置GAEProxy](/img/xx-net/config.png)

- 4）确认状态

![确认状态](/img/xx-net/status.png)

- 5）done






