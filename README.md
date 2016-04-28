# blog-theme
  blog-theme builds on `hexo`
  
  demo: [http://chenchunyong.github.io](http://chenchunyong.github.io)
  
## Requirements

* Node (version>=5.0.0)

## Setup

### 1. Install global environment `hexo`

```
$ npm install hexo-cli -g
```
### 2. Clone the repo

```
$ git clone  https://github.com/chenchunyong/blog-theme.git
$ cd blog-theme
```
### 3. Install dependencies

```
$ npm install
```
### 4. Install module `hexo-theme-next` theme

```
$ git submodule init
$ git submodule update
$ cd themes/next && npm install
```

### 5. Blog start 
```
$ cd blog-theme
$ hexo server
```


