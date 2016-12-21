---
title: 解决生产环境js无法调试问题
date: 2016-12-21 15:45:49
tags: [前端]
categories: [前端]
---

# 解决生产环境js无法调试问题

## 背景
前端开发中，开发环境与生产环境的代码往往不一致，生产环境的代码通过构建工具进行合并，混淆，压缩等操作。不过通过构建工具生成的js代码可读性差，不利于维护、排查问题。

## 解决方案
首先，通过构建工具生成两个生产js文件，如下:

- 所有用户可见js，比如bundle.js
- 特定用户js，排查问题用，此js文件会加入sourcemap引用，比如说bundle.debug.js

然后，根据用户输入的url是否包含sourcemap参数，来判断是否启动sourcemap调试功能。比如如果包含sourcemap参数，则引入bundle.debug.js，否则引入bundle.js。

## 使用

1. 安装
```
npm install
```

2. 打包js文件
```
npm run bundle
```
3. 启动
```
npm start
```

输入http://localhost:3000 或者http://localhost:3000?sourcemap=true 查看效果。

## 效果对比

1. 输入http://localhost:3000
![](/images/front/online.gif)

2. 输入http://localhost:3000?sourcemap=true
![](/images/front/debug.gif)
