---
title: webpack dllPlugin 使用
date: 2017-01-10 10:59:59
tags: [webpack]
categories: 前端
---

# webpack dllPlugin 使用
## CommonsChunk
前端构建项目中，为了提高打包效率，往往将第三库与业务逻辑代码分开打包，因为第三方库往往不需要经常打包更新。webpack建议使用`CommonsChunk` 来单独打包第三方库：
```js
module.exports = {
    entry: {
        vendor: ['react','react-dom'],
        app: "./main",
    },
    output: {
        path: './build',
        filename: '[name].js',
        library: '[name]_library'
    },
    plugins: [
        new CommonsChunkPlugin({
            name: "vendor",
        }),
    ]
};
```

`CommonsChunk`虽然可以减少包的大小，但存在问题是：即使代码不更新，每次重新打包，vendor都会重新生成，不符合我们分离第三方包的初衷。
## Externals
相比于前者，webpack 提供`Externals`的方法，可以通过外部引用的方法，引入第三方库：
index.html
```html
<script src="https://code.jquery.com/jquery-3.1.0.js"></script>
```
webpack.config.js
```js
module.exports = {
   externals: {
     jquery: 'jQuery'
   }
};
```
业务逻辑，如index.js
```
import $ from 'jquery';
$('.my-element').animate(...);
```
webpack打包时，发现jquery定义在`externals`，则不会打包jquery代码。由于不需要打包jquery，所以也减少打包时间。
不过`externals`虽然解决了外部引用问题，但是无法解决以下问题：
```
import xxx from 'react/src/xx';
```
webpack遇到此问题时，会重新打包react代码。
参考：https://gold.xitu.io/entry/57996222128fe1005411c649
## DLL & DllReference
相比于前者，通过前置这些依赖包的构建，来提高真正的build和rebuild构建效率。也就是说只要第三方库没有变化，之后的每次build都只需要去打包自己的业务代码，解决`Externals`多次引用问题。
webpack通过`webpack.DllPlugin`与`webpack.DllReferencePlugin`两个内嵌插件实现此功能。
### 使用
1、新建webpack.dll.config.js
```
const webpack = require('webpack');

module.exports = {
    entry: {
        bundle: [
            'react',
            'react-dom',
            //其他库
            ],
    },
    output: {
        path: './build',
        filename: '[name].js',
        library: '[name]_library'
    },
    plugins: [
        new webpack.DllPlugin({
            path: './build/bundle.manifest.json',
            name: '[name]_library',
        })
    ]
};

```

`webpack.DllPlugin`选项：
- **path**：manifest.json文件的输出路径，这个文件会用于后续的业务代码打包；
- **name**：dll暴露的对象名，要跟output.library保持一致;
- **context**：解析包路径的上下文，这个要跟接下来配置的 webpack.config.js 一致。

运行：
```
webpack --config webpack.dll.config.js
```
生成两个文件，一个是打包好的`bundlejs`，另外一个是`bundle.mainifest.json`，大致内容如下：
```
{
  "name": "bundle_library",
  "content": {
    "./node_modules/react/react.js": 1,
    "./node_modules/react/lib/React.js": 2,
    "./node_modules/process/browser.js": 3,
    "./node_modules/object-assign/index.js": 4,
    "./node_modules/react/lib/ReactChildren.js": 5,
    "./node_modules/react/lib/PooledClass.js": 6,
    "./node_modules/react/lib/reactProdInvariant.js": 7,
    //其他引用
}
```
2、配置webpack.config.js
```
const webpack = require('webpack');
var path = require('path');
module.exports = {
  entry: {
    main: './main.js',
  },
  output: {
    path: path.join(__dirname, "build"),
    publicPath: './',
    filename: '[name].js'
  },
  module: {
    loaders:[
      { test: /\.(png|jpg)$/, loader: 'url-loader?limit=8192'},
      {
        test: /\.jsx?$/,
        loaders: ['babel-loader?presets[]=es2015&presets[]=react'],
        include: path.join(__dirname, '.')
      }
    ]
  },
  plugins: [
     new webpack.DllReferencePlugin({
      context: '.',
      manifest: require("./build/bundle.manifest.json"),
        }),
  ]
};
```

`webpack.DllReferencePlugin`的选项中：
- **context**：需要跟之前保持一致，这个用来指导webpack匹配`manifest.json`中库的路径；
- **manifest**：用来引入刚才输出的`manifest.json`文件。

### 打包效果对比
没有`webpack.DllReferencePlugin`插件，打包时间：*6525ms*，资源包：*main.js 757k*。
![](/images/front/withoutDll.png)
配置`webpack.DllReferencePlugin`插件，打包时间：*892ms*，资源包：*main.js 4.7k*。
![](/images/front/dll.png)
通过dllPlugin，打包时间快了5s，资源包少了700k。
### demo 地址
https://github.com/chenchunyong/webpack-dllPlugin