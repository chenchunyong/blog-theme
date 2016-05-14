---
title: iterm2使用solarized配色 
date: 2016-05-04 16:04:16
tags: [itmer2,solarized]
categories: vim
---

# iterm2使用solarized配色

 采用iterm2、terminal搭配solarized 配色方案，可以配置出界面清新的开发环境。

 **先放在最终效果图**
 ![](/images/vim/效果图.png)

 ## 配置步骤

 #### 1. 下载[iterm2](http://www.iterm2.com/downloads.html)
   下载并打开iterm2。
 #### 2. 安装oh-my-zsh，并设置主题主题为`agnoster`

 	```bash
 		$ curl -L https://raw.github.com/
 		  robbyrussell/oh-my-zsh/master/tools/install.sh | sh

 	```
   编辑`~/.zshrc `，找到ZSH_THEME，设置为`agnoster`主题。

 #### 3. 安装powerline字体
 	```
 	$ git clone https://github.com/powerline/fonts.git
 	    && cd fonts
 	$ ./install.sh
 	```
 #### 4. 安装solarized字体
 	```
 	$ git clone http://github.com/altercation/solarized.git
 	```
 进入下载的`solarized/iterm2-colors-solarized`目录，双击`Solarized Dark.itermcolors` 和 `Solarized Light.itermcolors` 两个文件就可以把配置文件导入到 iterm2里。

 #### 5. 设置iterm2 Color、Text

 1. 把iterm2的设置里的Profile中的Text 选项卡中里的Regular Font和Non-ASCII Font的字体都设置成 Powerline的字体，我这里设置的字体是13pt Meslo LG S DZ Regular for Powerline。
 	 ![](/images/vim/iterm2text设置.png)

 2. 在iterm2 Profile设置中，Color 选择导入`Solarized Dark`。
 	 ![](/images/vim/iterm2color设置.png)

#### 6. iterm2其他主题
参考:[iterm2](http://github.com/mbadolato/iTerm2-Color-Schemes)
 
 ## 结束

 通过上述简单的配置,即可搭建一个漂亮的界面了。

