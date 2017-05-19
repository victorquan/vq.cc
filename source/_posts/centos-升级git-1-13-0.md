---
title: centos 升级git 1.13.0
date: 2017-05-19 08:23:38
cover:
tags: [git]
---

## 一、安装相关工具
```
# yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
# yum install  gcc perl-ExtUtils-MakeMaker
```

## 二、卸载默认的git-1.7.1版本
```
# yum remove git
```

## 三、下载git安装包
在 [这里](https://www.kernel.org/pub/software/scm/git/) 查看并选择git版本

```
# cd /usr/src
# wget https://www.kernel.org/pub/software/scm/git/git-2.13.0.tar.gz
# tar xzf git-2.13.0.tar.gz
```

## 四、安装git && 添加环境变量
```
# cd /usr/src/git-2.13.0
# make prefix=/usr/local/git all
# make prefix=/usr/local/git install
# echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
$ source /etc/bashrc
```

## 五、检验git安装是否成功
```
$ git --version
git version 2.13.0
```

