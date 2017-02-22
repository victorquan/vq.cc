---
title: 配置自己的MAC
date: 2017-02-22 13:10:42
tags: Mac,代理,终端
---


### 一、安装 brew 工具
```
$ curl -LsSf http://github.com/mxcl/homebrew/tarball/master | sudo tar xvz -C/usr/local --strip 1
```

### 二、安装 Solarized 配色工具

    Solarized是目前最完整的Terminal/Editor/IDE配色项目，要在 Mac OS X 终端里舒服的使用命令行（至少）需要给3个工具配色，terminal、vim 和 ls。这里不得不提和Terminal相同功能的工具iTerm2。


#### 1、下载 Solarized：
```
$ git clone git://github.com/altercation/solarized.git
```

#### 2、配色方案 Solarized 导入
    
    Mac OS X 自带的 Terminal 和免费的 iTerm2 都是很好用的工具，iTerm2 可以切分成多窗口，更方便一些。
    
    如果你使用的是 Terminal，在solarized/osx-terminal.app-colors-solarized 下双击 Solarized Dark ansi.terminal 和 Solarized Light ansi.terminal 就会自动导入两种配色方案 Dark 和 Light 到 Terminal.app 里。
    
    如果你使用的是 iTerm2 的话，到 solarized/iterm2-colors-solarized 下双击 Solarized Dark.itermcolors 和 Solarized Light.itermcolors 两个文件就可以把配置文件导入到 iTerm 里。

#### 3、vim的配色最好和终端一致
```    
$ cd solarized
$ cd vim-colors-solarized/colors
$ mkdir -p ~/.vim/colors
$ cp solarized.vim ~/.vim/colors/
$ vi ~/.vimrc 添加以下代码
	syntax on
	set background=dark
	colorscheme solarized
```
    
#### 4、ls
    MacOSX是基于FreeBSD的，所以一些工具ls，top等都是BSD那一套，ls不是GNU ls，所以即使 Terminal / iTerm2 配置了颜色，但是在Mac上敲入ls命令也不会显示高亮，可以通过安装coreutils来解决（brew install coreutils），不过如果对ls颜色不挑剔的话有个简单办法就是在 .bash_profile 里输出 CLICOLOR=1：

```
$ vi ~/.bash_profile
	export CLICOLOR=1
```

#### 5、ls高亮设置
```   
$ sudo brew install xz coreutils
$ gdircolors --print-database > ~/.dir_colors
$ vim ~/.bash_profile 添加以下代码
	if brew list | grep coreutils > /dev/null ; then
		PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
		alias ls='ls -F --show-control-chars --color=auto'
		eval `gdircolors -b $HOME/.dir_colors`
	fi
```

#### 6、grep高亮设置
```
$ vim ~/.bash_profile 添加以下代码
	alias grep='grep --color'
	alias egrep='egrep --color'
	alias fgrep='fgrep --color'
```

### 三、增强命令行工具
    添加ll、l、la指令

```
$ vim ~/.bash_profile 添加以下代码
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
```


### 四、补充
    也可以玩一下 Terminal + Tmux、zsh + oh-my-zsh + powerline 一套。
    windows下的 [babun](http://babun.github.io/) 也不错


### 五、安装homebrew、solarized
[homebrew & solarized](https://github.com/victorquan/Mac-Terminal-and-Vim-configuration)

### 六、安装whistle代理工具
[whistle github 源码](https://github.com/avwo/whistle) 

#### 1、安装node（npm）
[详见快速安装node](http://victorquan.com/2017/02/21/%E5%BF%AB%E9%80%9F%E5%AE%89%E8%A3%85node%E7%AC%94%E8%AE%B0/)


#### 2、安装whistle
```
$ sudo npm install -g whistle
```


#### 3、安装chrome的switch插件
```
$ wget https://github.com/victorquan/Mac-Terminal-and-Vim-configuration/blob/master/SwitchyOmega.crx
```


#### 4、SwitchOmega 配置参数
```
127.0.0.1:8899
```


#### 5、启动whistle
```
$ sudo whistle start
```


### 七、安装markdown转成ppt插件landslide
[参考landslide](https://github.com/adamzap/landslide)

    如果你还未安装pip，见 [https://pip.pypa.io/en/latest/installing/](https://pip.pypa.io/en/latest/installing/)
    使用方法

```
$ landslide test.md -i -o > test.html
```

### 八、安装php composer
#### 1、安装方法
方法一，使用curl安装: 

```
$ curl -sS https://getcomposer.org/installer | php
```

方法二，若没有安装curl，可以通过另外一种方式安装: 

```
$ php -r "readfile('https://getcomposer.org/installer');" | php
```

方法三，手动下载:

[Download Composer](https://getcomposer.org/composer.phar)
    
#### 2、将下载好的composer.phar移动到bin中成为全域指令
```
$ sudo mv composer.phar /usr/local/bin/composer
```


#### 3、修改权限
```
$ sudo chmod a+x composer
```



