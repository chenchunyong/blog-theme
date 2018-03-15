---
title: 谈谈我对event loop的理解
date: 2018-03-15 17:17:34
tags:
categories: 前端
---

在前端学习过程中，对event loop的理解是一个难点，也是一个比较有趣的点，下面谈谈我对event loop的理解。

## event loop 理解

根据W3C 对[event loop](https://www.w3.org/TR/html5/webappapis.html#event-loop)规范我总结了下:

 1. 一个event loop有**一个或者多个**任务队列；
 2. 一个任务队列是一系列**有序** task集合；
 3. 每一个task都有添加到队列时，必须添加到event loop对应的某个队列中；
 4. 每一个task在定义时都会有指定的task source（一共有4种，DOM manipulation task source，user interaction task source，networking task source，history traversal task source）。所有来自一个特定的task source的task都必须被添加到一个特定的相同的event loop，但是**不同来自不同task source的task也许会被添加到不同的任务队列**；
 5. 每个(task source对应的)task queue都保证自己队列的先进先出的执行顺序，是由浏览器决定从哪个task source挑选task。这允许浏览器为不同的task source设置不同的优先级，比如为用户交互设置更高优先级来使用户感觉流畅。**task执行的优先级具体由游览器自行决定。**
 
## microtask 队列理解
根据W3C 对[microtask](https://www.w3.org/TR/html51/webappapis.html#microtask)我的理解如下:

1. 每一个event loop都有一个microtask队列，处于microtask队列而不是普通的task队列中的task就叫做microtask；
2. **microtask队列的执行顺序优先于普通的task队列**。

当前属于microtask的有：**process.nextTick, Promises, Object.observe(废弃), MutationObserver**。

## 浏览器中event loop 运行机制
根据W3C [event loop processing model](https://www.w3.org/TR/html51/webappapis.html#event-loops-processing-model)来描述浏览器的事件循环的进程模型：

1. 取出某一个任务队列队列头的任务（如果存在的话），如果没有task可以取的话，跳到第6步；
2. 将event loop的当前运行任务设置为上一步选择到的task；
3. 运行这个task；
4. 将event loop的当前运行任务设置为null；
5. 将第3步中运行的task从它的任务队列中移除；
6. 执行一个microtask checkpoint操作;
7. 更新渲染。

简单可以总结为：先执行microtask，然后执行普通task。

## 验证event loop 运行机制

下面我们用一个比较复杂的demo来验证event loop 运行机制，此demo 涉及的类型有：DOM event、settimeout、Promise、XMLHttpRequest。

代码如下 [demo](/images/eventloop/testpage.html)：

```javascript
console.log('start test...');
// 添加
setTimeout(() => {
    console.log("settimeout 1");
}, 0);
// request 请求
var xhr = new XMLHttpRequest();
//请求某个页面，如果出现跨域，则需自己调整
xhr.open('GET', '/images/avatar.png', true);
xhr.onload = function (e) {
    if (this.status == 200 || this.status == 304) {
        console.log("request response...");
    }
};
xhr.send();
// 注册页面中的点击事件，主要在主进程阻塞3s内单击
document.getElementById('btn').addEventListener('click', () => {
    console.log('click');
});
//promise 
new Promise((resolve, reject) => {
    console.log("promise 1");
    for (let i = 0; i < 1000; i++) {
        i=9999 &&resolve();
    }
    console.log("promise 2");
}).then(()=>{
    console.log("promise 3");
})
let now = new Date().getTime();
while ((new Date()).getTime() - now < 3000) {}
console.log("last test...");
```
运行的结果如下：

![](/images/eventloop/结果.png)

那么是如何得到这个结果呢，分析如下：

1. 先打印：start test...（没什么好说的)；
2. 添加“打印 settimeout 1”回调 到 task队列中（改天跟大家分享settimeout运行原理，参考：[settimeout 原理](http://www.alloyteam.com/2015/10/turning-to-javascript-series-from-settimeout-said-the-event-loop-model/)）；
3. 发起页面请求，等待页面请求完成后，把“onload 回调“push到task队列中;
4. 执行Promise构造函数 打印出：promise 1，promise 2；
5. 构造函数中循环1000次，运行then的方法，添加 “打印 promise 3 回调” push到microtask 队列中；
6. 在3秒期间，单击页面的click事件，把”打印 click 回调“push到队列中；
7. 主进程等待3s后，打印出 last test...；
8. 由于microtask的task会比较早执行，优先从microtask 队列拿出task，打印出 promise 3；
9. Chrome为了用户体验，提升交互，把click 产生的task > 大于发起请求的task > settimeout 产生的task，所以依次打印出：click，request response...，settimeout 1。

**PS：** 
1. 由于第9点是我在Chrome下运行的结果，可能其他游览器返回结果不一定一致；
2. 上述所说的push到task队列中，不是指一个队列，而是某个类型的task队列，不同类型的task 队列 执行的优先级不一致，目前我没有找到相关task任务优先级的文章。

## 总结
1. event loop涉及到一般的task队列与macrotask队列；
2. macrotask队列中的task 执行的优先级高于task队列的task；
3. 即使是不同的task队列，都有执行的优先级，执行的优先级主要以用户交互、体验为考虑依据。

以上的理解纯属我个人对event loop 的理解，有问题还请大家多多指正。



## 说明