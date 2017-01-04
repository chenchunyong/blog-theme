---
title: webpack 常用plugin
date: 2017-01-04 11:31:06
tags: [webpack]
categories: 前端
---

# webpack 常用plugin
记录webpack常用plugin使用

## DefinePlugin
用来定义全局变量，在webpack打包的时候会对这些变量做替换。
demo:
```js
var webpack = require('webpack');

module.exports = {
    plugins: [
        new webpack.DefinePlugin({
            'process.env': JSON.stringify('DEV')
        })
    ]
};

console.log(process.env);
```
编译完成后，`process.env`会被编译成DEV。 

## ExtractTextPlugin
把文件中的css样式剥离出来，单独为一个css文件。
demo:
```js
var webpack = require('webpack');

module.exports = {
    plugins: [
        new ExtractTextPlugin('module.css'),
    ]
    loaders: [{
        test: /\.css$/,
        loader: ExtractTextPlugin.extract('style-loader', 'css-loader!postcss-loader'),
  }],
};

```
把文件中的css剥离出来成单独的module.css文件。

**NOTE**:
一个entry生成一个文件，当多个entry的时候，可以用`[name]/[id]/[contenthash]`来生成多个文件。
`id`: 插件实例的唯一标识，自动生成
`filename`: 输出的filename，可以通过[name]/[id]/[contenthash]自定义filename
`options.allChunks` 提取所有的chunk（默认只提取initial chunk）
`options.disable` disable该插件

文／齐修_qixiuss（简书作者）
原文链接：http://www.jianshu.com/p/1eefaeaf6874
著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。

## NoErrorsPlugin 
跳过编译时出错的代码并记录，使编译后运行时的包不会发生错误。

## CommonsChunkPlugin
提取代码中的公共模块，然后将公共模块打包到一个独立的文件中，以便在其他的入口和模块中使用。
demo:
```js
var webpack = require('webpack');
module.exports = {
  entry:['index1.js','index2.js'],
  plugins: [
   new CommonsChunkPlugin({
      name:"entry",
      filename:"common.js",//忽略则以name为输出文件的名字，否则以此为输出文件名字
      minChunks:2,// 最小引用2次
   })
  ]
};

```
把index1.js，index2.js公用的js抽取出来，打包成单独文件common.js。
**NOTE**: CommonsChunkPlugin此插件存在的问题：
1. 如果entry只有一个,生成的common.js内容为空。
2. 编译时，每次都会重新编译，编译时间长，无法缓存编译的内容
3. common.js是由webpack控制
**参考**：http://www.jianshu.com/p/ee372e344d6d

## DedupePlugin
有些JS库有自己的依赖树，并且这些库可能有交叉的依赖，DedupePlugin可以找出他们并删除重复的依赖。
## UglifyJsPlugin
压缩js文件。
```js
var webpack = require('webpack');
module.exports = {
  entry:['index1.js'],
  plugins: [
   new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: VERBOSE,
      },
    })
  ]
};

```
对index1.js进行压缩。

## OccurenceOrderPlugin
为组件分配ID，通过这个插件webpack可以分析和优先考虑使用最多的模块，并为它们分配最小的ID。（老实说，不知道分配最小ID有什么作用）。
## HotModuleReplacementPlugin 
热更新插件，代码发生变化，自动替换到页面。
```js
var webpack = require('webpack');
module.exports = {
  entry:['webpack/hot/dev-server', 'webpack-hot-middleware/client?reload=true','index1.js'],
  plugins: [
   new webpack.HotModuleReplacementPlugin(),
  ],
  loaders: [{
    test: /\.jsx?$/,
    loaders: ['react-hot'],
    exclude: '/node_modules/',
  }]
};

```

express 服务配置
```js
var WebpackDevMiddleware = require('webpack-dev-middleware')
var WebpackHotMiddleware = require('webpack-hot-middleware')
var config = require('./config/webpack.dev.config')
var compiler = webpack(config)
app = express()
app.use(WebpackDevMiddleware(compiler, {
  publicPath: config.output.publicPath,
  stats: { colors: true }
}))
app.use(WebpackHotMiddleware(compiler))
```

如果前端框架采用外部引用react的方式，那么需要在入口index1.js增加hot replace 配置
```
if (module.hot) {
  require('react-hot-loader/Injection').RootInstanceProvider.injectProvider({
    getRootInstances: () => [rootInstance],
  });
}
```

## HtmlWebpackPlugin

这个插件用来简化创建服务于 webpack bundle 的 HTML 文件，尤其是对于在文件名中包含了 hash 值，而这个值在每次编译的时候都发生变化的情况。你既可以让这个插件来帮助你自动生成 HTML 文件，也可以使用 lodash 模板加载生成的 bundles，或者自己加载这些 bundles。
demo:
```js
var webpack = require('webpack');
module.exports = {
  entry:['index1.js'],
  plugins: [
   new HtmlWebpackPlugin({
      title: 'My App',
      filename: 'index.html',

    }),
  ],
};
```
把index1.js打包后，放到index.html中。

### Configuration
- title: 用来生成页面的 title 元素
- filename: 输出的 HTML 文件名，默认是 index.html, 也可以直接配置带有子目录。
- template: 模板文件路径，支持加载器，比如 html!./index.html
- inject: true | 'head' | 'body' | false  ,注入所有的资源到特定的 template 或者 templateContent 中，如果设置为 true 或者 body，所有的 javascript 资源将被放置到 body 元素的底部，'head' 将放置到 head 元素中。
- favicon: 添加特定的 favicon 路径到输出的 HTML 文件中。
- minify: {} | false , 传递 html-minifier 选项给 minify 输出
- hash: true | false, 如果为 true, 将添加一个唯一的 webpack 编译 hash 到所有包含的脚本和 CSS 文件，对于解除 cache 很有用。
- cache: true | false，如果为 true, 这是默认值，仅仅在文件修改之后才会发布文件。
- showErrors: true | false, 如果为 true, 这是默认值，错误信息会写入到 HTML 页面中
- chunks: 允许只添加某些块 (比如，仅仅 unit test 块)
- chunksSortMode: 允许控制块在添加到页面之前的排序方式，支持的值：'none' | 'default' | {function}-default:'auto'
- excludeChunks: 允许跳过某些块，(比如，跳过单元测试的块) 
