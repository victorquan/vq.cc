---
title: crontab的一些使用
date: 2017-01-23 16:18:50
tags: [crontab,Linux]
---
## 一、安装
```
yum -y install vixie-cron
yum -y install crontabs
```

vixie-cron 软件包是 cron 的主程序；
crontabs 软件包是用来安装、卸装、或列举用来驱动 cron 守护进程的表格的程序。

<!--more-->

## 二、配置

需要手动启动crontab，设置开机自动启动
```
service crond start    //启动服务
service crond stop    //关闭服务
service crond restart    //重启服务
service crond reload    //重新载入配置
service crond status    //查看crontab服务状态
chkconfig --level 345 crond on    //centos开机自动启动
```

## 三、crontab基本操作

```
crontab -u    //设定某个用户的cron服务，一般root用户在执行这个命令的时候需要此参数
crontab -l    //列出某个用户cron服务的详细内容
crontab -r    //删除没个用户的cron服务
crontab -e    //编辑某个用户的cron服务
```

## 四、时程表格式
```
时程表格式:
f1  f2  f3  f4  f5program
分　 时  日  月　 周　 命令
f1表示分钟,1～59每分钟用*或者 */1表示
f2表示小时,1～23（0表示0点）
f3表示日期即一个月份中的第几日,1～31
f4表示月份,1～12
f5标识星期,0～6（0表示星期天）
f6要执行的程序
```

## 五、问题排除

如果crontab安装正常、进程正常，脚本没跑起来，排查原因：

#### 1）看log：/var/log/cron

如果找不到/var/log/cron文件，则重启rsyslog：service rsyslog start

#### 2）如果看到/var/log/cron文件报错：FAILED to open PAM security session (Cannot make/remove an entry for the specified session)，则说明是权限问题

解决办法：把/etc/pam.d/crond文件中的“session    optional   pam_loginuid.so”注释掉，点击参考这里，然后重启crontab即可