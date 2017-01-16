---
title: git 常使用命令
date: 2016-05-14 14:59:09
tags: [git]
categories: git
---
# git 常使用命令
记录自己常用的git使用命令。
## git config
配置git信息。
#### 1. git config \-\-global user.name “xxx”
设置用户名信息。
#### 2. git config \-\-global user.email "xxx”
设置用户邮件信息。
#### 3. git config \-\-list
查看config 配置信息。
#### 4. git config \-\-global core.autocrlf true
假如你正在Windows上写程序，又或者你正在和其他人合作，他们在Windows上编程，而你却在其他系统上，在这些情况下，你可能会遇到行尾结束符问题。这是因为Windows使用回车和换行两个字符来结束一行，而Mac和Linux只使用换行一个字符。

Git可以在你提交时自动地把行结束符CRLF转换成LF，而在签出代码时把LF转换成CRLF。用core.autocrlf来打开此项功能，如果是在Windows系统上，把它设置成true，这样当签出代码时，LF会被转换成CRLF。

## git clone
从远程仓库克隆代码。
#### 1. git clone "http://abc.com/abc.git" dirName
从远程仓库克隆代码到dirName文件夹下。如果dirName参数，则克隆下来的文件夹默认为远程仓库的名称。

## git init
初始化git仓库。
#### 1. git init
初始化git仓库。

## git add
从工作区添加文件到暂存区。
#### 1. git add .
添加`修改`、`新增`文件到暂存区。
#### 2. git add -A
添加`修改`、`新增`、`删除`的文件到暂存区。
#### 3. git add -u
添加`修改`、`删除`的文件到暂存区。
#### 4. git add file|dir
添加具体文件、文件夹到暂存区，支持正则表达式。

如：
```
$ git add abc* 
```
表示添加abc开头的文件到暂存区。
## git commit
提交添加到暂存区的修改内容。
#### 1. git commit -m “xxx”
直接在`-m`后面填需要提交的内容。
#### 2. git commit -a -m “xxx”
提交的内容 Git 就会自动把所有已经跟踪过的文件暂存起来一并提交，从而跳过`git add`步骤。
#### 3. git commit \-\-amend
- 当不小心写错提交信息时，git commit提供了`amend`的参数，用来修改最后一次提交的commit信息，前提是最后一次commit还未push到服务器。
- 通过此命令可以把当前的修改合并到最后一个commit中。

## git rm
删除工作区文件，并且将这次删除放入暂存区。
#### 1. git rm file
删除某个文件，同时添加到暂存区中。
#### 2. git rm \-\-cached file
停止追踪指定文件，但该文件会保留在工作区。
#### 3. git rm file -f
最后提交的时候，该文件就不再纳入版本管理了。如果删除之前修改过并且已经放到暂存区域的话，则必须要用强制删除选项 `-f`（译注：即 force 的首字母），以防误删除文件后丢失修改的内容。
## git checkout
切换分支。
#### 1. git checkout feature
切换到某个分支。
#### 2. git checkout -b feature
新建分支，同时切换到该分支下。相当于：
```
$ git branch feature
$ git checkout feature
```
#### 3. git checkout \-\-file
撤销工作区file的修改。此命令对已在暂存区的file无效。

## git reset
撤销文件改动。
#### 1. git reset file
把暂存区文件撤销到工作区。

#### 2. git reset \-\-hard HEAD
撤销工作区与暂存区文件到HEAD版本。使用`git reset --hard `需要小心点，因为此命令会重写log历史。 
如下:

- `git reset --hard HEAD^` 回退到HEAD的前一个,HEAD当前commit会被撤销掉。
- `git reset --hard commitId` 回退到commit版本，commit前版本会被撤销掉。

**温馨提示：**如果错误的运行`git reset --hard`，还有机会找回以前版本信息，采用`git reflog`找回。
## git revert 
撤销文件改动。与`git reset` 不同是，`git revert`不会重写log历史。
##### 1. git revert commit
撤销某个commit改动，并提交新的commit。

## git branch
管理git分支。
#### 1. git branch feature
新建feature分支。
#### 2. git branch -a
 查看远程与本地的所有分支。
#### 3. git branch -r
 查看远程分支。
#### 4. git branch -v
查看本地分支及最后一次提交的commit
#### 5. git branch -vv
查看本地分支以及最后一次提交的commit，同时查看对应的远程分支。
#### 6. git branch \-\-merged
查看哪些分支已被并入当前分支。
#### 7. git branch \-\-no-merged
查看尚未合并到当前分支的分支。
#### 8. git branch -d feature
删除本地分支，如果分支有commit，则需要用`-D`来强制删除。
#### 9. git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 \<(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
批量删除那些远程已经删除，而没有尚未删除的分支。
#### 10. git branch -m oldFeature newFeature
重命名分支名称。oldFeature不填则默认为当前分支。


## git pull
拉取远程代码，并合并当前分支的代码。
#### 1. git pull
拉取远程代码，并合并当前分支的代码。如果本地有commit，则会合并远程commit与本地commit，形成新的commit。
#### 2. git pull \-\-rebase
与上述命令不同的是，此命令采用rebase的方式合并代码，故不会产生新的commit。同时也保持git分支简洁性。具体参考`git rebase`。
## git fetch
同步到远程代码到本地，不会自动合并当前分支。
## git push
推送本地commit到服务器。
#### 1. git push
推送本地commit到服务器。
#### 2. git push origin feature
本地新建分支后，远程还未有该分支，通过此命令推送本地分支到服务器。
#### 3. git push origin \-\-delete feature
删除远程分支。此功能与以下命令相同：
```
$ git push origin 本地分支:远程分支
```

## git stash
管理需要暂存的信息。
#### 1. git stash
暂存修改的信息。
#### 2. git stash list
查看暂存列表中的暂存信息。
#### 3. git stash pop
 获取最后一个暂存的信息然后应用到当前分支。
## git remote
查看并维护远程仓库相关信息。
#### 1. git remote show origin
查看远程仓库信息，以及本地信息。
#### 2. git remote add “http://abc.com/abc.git”
添加新的远程仓库。
#### 3. git remote prune origin
删除本地库存在，而远程仓库已经不存在的分支。
#### 4. git remote add upstream “http://abc.com/abc.git”
添加remote 远程地址

## git merge
 合并分支。
#### 1. git merge feature
合并feature分支到当前分支，如果本地有commit，则会合并远程commit与本地commit，形成新的commit。
合并前：
![](/images/git/beforeMerge.png)
合并后:
![](/images/git/afterMerge.png)
## git rebase
合并分支。
#### 1. git rebase feature
与`git merge` 不同是:`git rebase` 把你的当前分支里的每个提交(commit)取消掉，并且把它们临时 保存为补丁(patch)(这些补丁放到".git/rebase"目录中),然后当前分支分支更新到最新的"origin"分支，最后把保存的这些补丁应用到当前分支分支上。
合并前：
![](/images/git/beforeMerge.png)
合并后:
![](/images/git/gitRebase1.png)
与`git merge`比较：
![](/images/git/gitRebase2.png)

## git diff
可以用此命令来比较版本之间的差异。
#### 1. git diff 
比较工作区与最后一次提交的差异，其中`新增`文件不参与展示。
#### 2. git diff \-\-cached
比较暂存区与最后一次提交的差异。
#### 3. git diff HEAD
比较工作区，暂存区与最后一次提交的差异。
#### 4. git diff feature
比较当前工作区、暂存区与feature分支的差异
#### 5. git diff feature1..feature2
比较feature1分支与feature2分支的差异。
#### 6. git diff feature1..feature2
找出`feature1`,`feature2`的共有父分支和`feature2`分支之间的差异，你用3个‘.'来取代前面的两个'.' 。

- `git diff HEAD -- lib/` 只比较某个分支目录下的文件差异。 

## git log
查询所提交的commit信息。

- -p      按补丁格式显示每个更新之间的差异。
- \-\-word-diff     按 word diff 格式显示差异。
- \-\-stat  显示每次更新的文件修改统计信息。
- \-\-shortstat     只显示 --stat 中最后的行数修改添加移除统计。
- \-\-name-only     仅在提交信息后显示已修改的文件清单。
- \-\-name-status   显示新增、修改、删除的文件清单。
- \-\-abbrev-commit 仅显示 SHA-1 的前几个字符，而非所有的 40 个字符。
- \-\-relative-date 使用较短的相对时间显示（比如，“2 weeks ago”）。
- \-\-graph 显示 ASCII 图形表示的分支合并历史。
- \-\-pretty        使用其他格式显示历史提交信息。可用的选项包括 oneline，short，full，fuller 和 format（后跟指定格式）。
- \-\-oneline       \-\-pretty=oneline \-\-abbrev-commit 的简化用法。

- -(n)    仅显示最近的 n 条提交
- \-\-since, \-\-after        仅显示指定时间之后的提交。
- \-\-until, \-\-before       仅显示指定时间之前的提交。
- \-\-author        仅显示指定作者相关的提交。
- \-\-committer     仅显示指定提交者相关的提交。

#### 1. git log -p -2
我们常用 `-p` 选项展开显示每次提交的内容差异，用 `-2` 则仅显示最近的两次更新

#### 2. git  log  \-\-name-status \-\-abbrev-commit
显示新增、修改、删除的文件清单,并且以commit短地址的形式显示。
#### 3. git log --pretty=oneline
每个提交都列出了修改过的文件，以及其中添加和移除的行数，并在最后列出所有增减行数小计。 还有个常用的 --pretty 选项，可以指定使用完全不同于默认格式的方式展示提交历史。比如用 oneline 将每个提交放在一行显示，这在提交数很大时非常有用。另外还有 short，full 和 fuller。
#### 4. git log \-\-graph
用图形化显示分支合并历史。
#### 5. git log \-\-pretty=format:"%h - %an, %ar : %s"
自定义分支显示格式。
#### 6. git log origin/feature
本地仓库feature分支log。
#### 7. git log file
HEAD指针中某个文件commit历史。
#### 8. git log master..feature
其中的master..feature范围包含了在feature分支而不在master分支中所有的提交。换句话说，这个命令可以看出从master分支fork到feature分支后发生了哪些变化。
#### 9. git log feature..
查看有哪些commit当前分支存在，而feature没有。
#### 10. git log --grep="xxx"
查看包含“xxx”的commit 历史

选项         说明
%H      提交对象（commit）的完整哈希字串
%h      提交对象的简短哈希字串
%T      树对象（tree）的完整哈希字串
%t      树对象的简短哈希字串
%P      父对象（parent）的完整哈希字串
%p      父对象的简短哈希字串
%an     作者（author）的名字
%ae     作者的电子邮件地址
%ad     作者修订日期（可以用 -date= 选项定制格式）
%ar     作者修订日期，按多久以前的方式显示
%cn     提交者(committer)的名字
%ce     提交者的电子邮件地址
%cd     提交日期
%cr     提交日期，按多久以前的方式显示
%s      提交说明

## git submodule
管理项目子模块。
#### 1. git submodule add https://abc.com/abc.git
通过此命令来新增子模块。
#### 2.git submodule init，git submodule update
克隆含有子模块的项目后，运行上面两个命令来初始化子模块信息。
#### 3. git submodule update \-\-remote 
gi 默认会尝试更新所有子模块，所以如果有很多子模块的话，你可以传递想要更新的子模块的名字。
#### 4. git submodule update \-\-remote \-\-merge
尝试用 `merge` 选项。 为了手动指定它，我们只需给 update 添加 \-\-merge 选项即可。 这时我们将会看到服务器上的这个子模块有一个改动并且它被合并了进来。
#### 5. git submodule update --remote --rebase
采用`rebase`的方式进行改动合并。

#### 6. git push \-\-recurse-submodules=on-demand
`push`时也会把相关的子模块提交一并推送到服务器。
#### 6. git push \-\-recurse-submodules=check
检查推送到主项目前检查所有子模块是否已推送。

