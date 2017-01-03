---
title: babel polyfill 使用
date: 2017-01-03 13:57:59
tags: [babel]
categories: [前端]
---

# babel polyfill 使用
Babel默认只转换新的JavaScript句法（syntax），而不转换新的API，比如Iterator、Generator、Set、Maps、Proxy、Reflect、Symbol、Promise等全局对象，以及一些定义在全局对象上的方法（比如Object.assign）都不会转码。
举例来说，ES6在Array对象上新增了Array.from方法。Babel就不会转码这个方法。如果想让这个方法运行，必须使用babel-polyfill，为当前环境提供一个垫片。

```shell
$ npm install --save babel-polyfill
```
然后，在脚本头部，加入如下一行代码。

```js
import 'babel-polyfill';
// 或者
require('babel-polyfill');
```

## babel polyfill 问题
babel polyfill提供了全局访问API，如Promise，Set 以及Map，但是polyfill所提供的api可能会污染到全局作用域，特别在你把代码打包为第三方库给其他人使用时，或者你无法控制你代码的运行环境时，都会存在问题。

那么如何避免上述问题呢？babel提供了`transform-runtime插件`来避免此问题，`transform-runtime`插件提供了一个沙箱机制来避免全局变量的污染。

需要注意的是`transform-runtime`依赖于`babel-runtime`。

## transform-runtime 使用

### 安装

1. development dependencies
```shell
$ npm install --save-dev babel-plugin-transform-runtime
```
2. production dependencies
```shell
$ npm install --save babel-runtime
```

通常来说，`transform-runtime`插件只用在开发环境中，不需要打包到生产包，而`transform-runtime`所依赖的`babel-runtime`则需要打包到生产包中。

### 使用
1. .babelrc 配置方式
```js
// without options
{
  "plugins": ["transform-runtime"]
}

// with options
{
  "plugins": [
    ["transform-runtime", {
      "helpers": false, // defaults to true
      "polyfill": false, // defaults to true
      "regenerator": true, // defaults to true
      "moduleName": "babel-runtime" // defaults to "babel-runtime"
    }]
  ]
}
```
2. babel CLI 
```shell
babel --plugins transform-runtime script.js
```
3. NODE 环境
```js
require("babel-core").transform("code", {
  plugins: ["transform-runtime"]
});
```