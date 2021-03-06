---
title: Linux 文件系统
date: 2016-11-26 10:55:14
tags: [linux]
categories: linux
---

# Linux 文件系统

## 磁盘格式化
每种操作系统所配置的文件属性/权限并不相同，为了存放所需数据，因此需要将分隔槽进行格式化，以成为操作系统能够使利用的文件系统格式。

## 文件系统
linux文件除了实际数据外，还有很多额外的属性，例如Linux文件权限（rwx）与文件属性(拥有者，群组，时间参数等)。文件操作系统通常将这两部分数据分别放在不同的区块。权限与属性放在inode中，数据则放在data block中。另外还有一个super block会记录整个文件系统信息，包括inode与block的总量、使用量、剩余量。

- **superblock**：记录此 filesystem 的整体信息，包括inode/block的总量、使用量、剩余量， 以及文件系统的格式与相关信息等
- **inode**：记录文件的属性，一个文件占用一个inode，同时记录此文件的数据所在的 block 号码
- **block**：实际记录文件的内容，若文件太大时，会占用多个 block 

## inode与block的关系
inode与block中都有编号，每个文件都会占用一个inode，inode则有文件数据放置的block号码。因此我们知道一个文件的inode,那么自然知道文件数据放置的block号码，当然也能够读出文件的数据。（文件索引系统）

| inode number  | block     |
| ------------- |:----------:|
| 4        | 4,7,8    |

如下图所示，文件系统先格式化出 inode 与 block 的区块，假设某一个文件的属性与权限数据是放置到 inode 4 号(下图较小方格内)，而这个 inode 记录了文件数据的实际放置点为 2, 7, 13, 15 这四个 block 号码，此时我们的操作系统就能够据此来排列磁盘的阅读顺序，可以一口气将四个 block 内容读出来！ 那么数据的读取就如同下图中的箭头所指定的模样了。

![image](/images/inode/inode.jpg)

## inode table
inode 的内容在记录文件的属性以及该文件实际数据是放置在哪几号 block 内！ 基本上，inode 记录的文件数据至少有底下这些

* 该文件的存取模式(read/write/excute)
* 该文件的拥有者与群组(owner/group)
* 该文件的容量
* 该文件创建或状态改变的时间(ctime)
* 最近一次的读取时间(atime)
* 最近修改的时间(mtime)
* 定义文件特性的旗标(flag)
* 该文件真正内容的指向 (pointer)

inode 的数量与大小也是在格式化时就已经固定了，除此之外 inode 还有些什么特色呢？

* 每个 inode 大小均固定为 128 bytes
* 每个文件都仅会占用一个 inode 而已

## 文件系统与目录关系
每个文件(不管是一般文件还是目录文件)都会占用一个 inode ， 且可依据文件内容的大小来分配多个 block 给该文件使用。而文件夹内容在记录文件名， 一般文件才是实际记录数据内容的地方。

当文件系统新建一个文件夹时，会给文件夹分配一个inode与若干个block，其中inode记录文件夹的权限与属性，并记录存储文件的block；而block则记录文件夹下的文件名以及该文件所占有的inode号码。
 
| inode number  | 文件名     |
| ------------- |:----------:|
| 456754        | text.sh    |
| 856321        | text1.sh   |
| 7837265       | text2      |

## 文件读取
因此当我们要读取某个文件时，就务必会经过目录的 inode 与 block ，然后才能够找到那个待读取文件的 inode 号码， 最终才会读到正确的文件的 block 内的数据。

## 文件写入
当新建一个文件或目录时，我们的文件系统是如何处理的？

1. 先确定用户对于欲新增文件的目录是否具有 w 与 x2. 3. 4. 
2. 的权限，若有的话才能新增
3. 根据 inode bitmap 找到没有使用的 inode号码，并将新文件的权限/属性写入
4. 根据 block bitmap 找到没有使用中的 block 号码，并将实际的数据写入 block 中，且升级 inode 的 block 指向数据
5. 将刚刚写入的 inode 与 block 数据同步升级 inode bitmap 与 block bitmap，并升级 superblock 的内容。

### 数据不一致情况
在一般正常的情况下，上述的新增动作当然可以顺利的完成。但是如果有个万一怎么办？ 例如你的文件在写入文件系统时，因为不知名原因导致系统中断(例如突然的停电啊、 系统核心发生错误啊～等等的怪事发生时)，所以写入的数据仅有 inode table 及 data block 而已， 最后一个同步升级中介数据的步骤并没有做完，此时就会发生 metadata 的内容与实际数据存放区产生不一致 (Inconsistent) 的情况了

### 日志式文件系统
为了避免上述提到的文件系统不一致的情况发生，因此我们的前辈们想到一个方式， 如果在我们的 filesystem 当中规划出一个区块，该区块专门在记录写入或修订文件时的步骤， 那不就可以简化一致性检查的步骤了？也就是说：

1. **预备**：当系统要写入一个文件时，会先在日志记录区块中纪录某个文件准备要写入的信息
2. **实际写入**：开始写入文件的权限与数据；开始升级 metadata 的数据
3. **结束**：完成数据与 metadata 的升级后，在日志记录区块当中完成该文件的纪录

在这样的程序当中，万一数据的纪录过程当中发生了问题，那么我们的系统只要去检查日志记录区块， 就可以知道哪个文件发生了问题，针对该问题来做一致性的检查即可，而不必针对整块 filesystem 去检查， 这样就可以达到快速修复 filesystem 的能力了！这就是日志式文件最基础的功能啰～

### VFS
文件系统上还有一层VFS（Visual File System）抽象层。文件系统拥有各种各样的函数，而VFS统一管理这些接口。此外，VFS拥有页面缓存机制。不论使用什么文件系统，无论从哪个磁盘中读取，必定会通过同样的机制进行缓存。

![image](/images/inode/inode5.png)