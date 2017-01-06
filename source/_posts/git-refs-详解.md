---
title: git refs 详解
date: 2017-01-06 10:26:57
tags: [git]
categories: git
---

# git refs 详解

## refs描述
在 git 中，我们称之为“引用”（references 或者 refs，译者注）。你可以在 .git/refs 目录下面找到这些包含 SHA-1 值的文件。
如下：
```
.git/refs/
    heads/
        master
        test
    remotes/
        origin/
            master
    tags/
        v0.9
```

**heads：**描述当前仓库所有本地分支，每一个文件名对应相应的分支，文件内部存储了当前分支最新的commit hash值。为了证实这点，你可以在git仓库中执行以下两段代码：
```
$ cat .git/refs/heads/master

$ git log -1 master
```
由`cat` 得到的commit hash 与 `git log`得到的hash值是一致的。

因此新建分支，只要往`.git/refs/heads/分支名`写入commit hash值就是这么简单。

**tags：**描述当前仓库的tag信息，其工作原理与heads一致。

**remotes：**remotes文件夹将所有由`git remote` 命令创建的所有远程分支存储为单独的子目录。在每个子目录中，可以发现被fetch进仓库的对应的远程分支。

## 特殊的引用（Refs）
除了引用目录外，还有一些特别的引用存在与.git路径顶部。
```
.git
    HEAD
    FETCH_HEAD
    ORIG_HEAD
    MERGE_HEAD
```

**HEAD：**当前检出的commit/branch。`HEAD`文件存储的是refs/heads/分支的引用。
可以看到`HEAD` 文件格式为：`ref: refs/heads/分支名称（当前分支）`。
当需要时这些 引用 会被创建或更新。例如，当执行`git pull`命令时，首先会执行 `git fetch`命令，此时会更新 `FETCH_HEAD` 引用，其后执行 `git merge FETCH_HEAD` 命令将获取的分支导入仓库。当然上述这些引用可以像普通引用一样使用，我想你一定使用过HEAD作为参数吧。
由于你仓库的类型与状态的差异，这些文件会包含不同的内容。HEAD引用有可能是一个指向其他引用的象征性的引用，也可能是一个commit哈希。当你在主分支下，查看你的HEAD文件内容：
```
$ git checkout master
$ cat .git/HEAD
```
你将看到`ref: refs/heads/master`，这意味着HEAD指向`refs/heads/master`的引用。这就是为什么git能获悉当前主分支被检出了的原因。如果切换到其他分支，HEAD的内容将被更新为指向那个分支。但是如果你在commit的层面使用`check out`而非分支层面，HEAD的内容将会是一个commit哈希而非引用。这就是为什么Git能获悉它处在独立的状态的原因。
**FETCH_HEAD：**最新从远程分支获取的分支。`FETCH_HEAD` 文件存储的是远程分支的最新的commit信息。

**ORIG_HEAD：**作为备份指向危险操作前的HEAD
**MERGE_HEAD：**使用`git merge`命令合并进当前分支的提交

