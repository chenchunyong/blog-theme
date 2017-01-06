---
title: git refspecs 详解
date: 2017-01-06 13:47:44
tags:
categories:
---

# git refspecs 详解
每个 refspec 都会创建一个本地仓库分支到远程仓库分支的映射。这让通过本地Git命令操作远程分支成为可能，并且配置一些高级的`git push`与`git fetch`行为。

假设你像这样添加了一项远程仓库：
```
$ git remote add origin git@github.com:schacon/simplegit-progit.git
```

git会在`.git/config`新增一节点，指定远程的名称（`origin`），远程仓库URL地址，以及用于操作的refspecs:
```
[remote "origin"]
       url = git@github.com:schacon/simplegit-progit.git
       fetch = +refs/heads/*:refs/remotes/origin/*
```

refspecs格式是一个可选`+`接着是`<src>:<dst>`，其中`<src>`是远端上的引用格式，`<dst>`是将要记录在本地的引用格式。可选`+`号告诉git即使在不能快速演进的情况下，也去强制更新它。

缺省情况下refspec会被`git remote add` 命令自动生成，git会获取远程上`refs/heads/`下面的所有引用，并将它写入到本地的`refs/remotes/origin`。所以，如果远程有一个`master`分支，在本地可以通过下面的这种方式来访问他的记录：
```
$ git log origin/master
$ git log remotes/origin/master
$ git log refs/remotes/origin/master
```
它们全是等价的，因为git会把它们都扩展成`resf/remotes/origin/master`。
如果你想让git每次拉取只拉取远程的`master`，而不是远程所有分支，你可以把fetch这一行修改成这样：
```
fetch = +refs/heads/master:refs/remotes/origin/master
```
`git fetch`操作默认fech远端名称为`origin`。
这是`git fetch`操作对这个远端缺省refspec值。而如果你只想做一次该操作，也可以在命令行指定这个refspecs，如可以这样拉取远程的`master`分支到本地的`origin/mymaster`分支：
```
$ git fetch origin master:refs/remotes/origin/mymaster
```
你也可以在命令行上指定多个 refspec. 像这样可以一次获取远程的多个分支：
```
$ git fetch origin master:refs/remotes/origin/mymaster \
   topic:refs/remotes/origin/topic
From git@github.com:schacon/simplegit
 ! [rejected]        master     -> origin/mymaster  (non fast forward)
 * [new branch]      topic      -> origin/topic
```
在这个例子中， `master`分支因为不是一个可以快速演进的引用而拉取操作被拒绝。你可以在 refspec 之前使用一个 + 号来重载这种行为。

你也可以在配置文件中指定多个 refspec. 如你想在每次获取时都获取`master`和`experiment` 分支，就添加两行：
```
[remote "origin"]
       url = git@github.com:schacon/simplegit-progit.git
       fetch = +refs/heads/master:refs/remotes/origin/master
       fetch = +refs/heads/experiment:refs/remotes/origin/experiment
```
但是这里不能使用部分通配符，像这样就是不合法的：
```
fetch = +refs/heads/qa*:refs/remotes/origin/qa*
```

## 推送refspecs
采用命名空间的方式确实很棒，但QA组成员第1次是如何将他们的分支推送到 qa/ 空间里面的呢？答案是你可以使用 refspec 来推送。
如果QA组成员想把他们的`master`分支推送到远程的`qa/master`分支上，可以这样运行：
```
$ git push origin master:refs/heads/qa/master
```
如果他们想让 git 每次运行 git push origin 时都这样自动推送，他们可以在配置文件中添加 push 值：
```
[remote "origin"]
       url = git@github.com:schacon/simplegit-progit.git
       fetch = +refs/heads/*:refs/remotes/origin/*
       push = refs/heads/master:refs/heads/qa/master
```
这样，就会让`git push origin`缺省就把本地的`master`分支推送到远程的`qa/master`分支上。

## 删除引用
你也可以使用 refspec 来删除远程的引用，是通过运行这样的命令：
```
$ git push origin :topic
```
因为refspec的格式是`<src>:<dst>`, 通过把`<src>`部分留空的方式，这个意思是是把远程的 topic 分支变成空，也就是删除它。