---
title: nvm快速安装node
date: 2017-02-21 11:01:04
tags: [node,nvm]
---

### 安装nvm：
```
git clone https://github.com/creationix/nvm.git .nvm
```

### 配置环境变量：
```
source ~/.nvm/nvm.sh
```

### 永久配置淘宝源：
```
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
```

<!--more-->

### 安装node：
```
nvm install v6.9.5
```

### 默认使用node指定版本
```
nvm use v6.9.5
nvm alias default v6.9.5
```

### 验证
```
nvm ls
```


