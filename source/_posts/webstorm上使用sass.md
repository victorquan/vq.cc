---
title: webstorm上使用sass
date: 2017-01-23 16:00:29
tags: [sass,前端]
cover: /img/sea1.png
---


本文主要介绍一下如何在webstorm上使用sass，实时自动编译sass文件。

## 一、安装

### 1、在翻*墙的情况下：

1）首先要为自己电脑安装ruby

2）执行命令行：

$ gem install sass

<!--more-->

### 2、未翻*墙的情况下：
```
$ gem sources --remove https://rubygems.org/
$ gem sources -a https://ruby.taobao.org/
$ gem sources -l
*** CURRENT SOURCES ***
https://ruby.taobao.org
请确保只有ruby.taobao.org
$ gem install sass
```

## 二、webstorm参数配置

1）打开webstorm->settings -> tools -> file watchers

2）参数配置

```
Program：/usr/local/bin/sass
Arguments：--no-cache --update --style expanded --watch $FileName$:$FileParentDir$\$FileNameWithoutExtension$.css
Working directory：$FileDir$
Output paths to refresh：$FileNameWithoutExtension$.css
```

![webstorm参数配置](/img/webstorm-sass-config.png)





## 另外笔者推荐另一种方法：

### 使用compass

1）安装：$ gem install compass

2）编写config.rb文件

```
require 'compass/import-once/activate'
\# Require any additional compass plugins here.
\# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "/pc/style/css"
sass_dir = "/pc/style/sass"
images_dir = "/pc/style/img"
javascripts_dir = "/pc/js"
\# You can select your preferred output style here (can be overridden via the command line):
\# output_style = :expanded or :nested or :compact or :compressed
\# To enable relative paths to assets via compass helper functions. Uncomment:
relative_assets = true
\# To disable debugging comments that display the original location of your selectors. Uncomment:
\# line_comments = false
preferred_syntax = :sass
```

3）在webstorm的Terminal中输入$ compass watch即可


