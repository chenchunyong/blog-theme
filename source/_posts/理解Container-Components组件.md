---
title: ' 理解Container Components组件'
date: 2016-05-22 15:01:46
tags: [react]
categories: 前端
---

# 理解Container component组件

在我用React编写代码过程中，对我影响最大的是*Container commponet* 模式。

在React开发者大会中，Jason Bonta 分享了在Facebook如何构建高性能的组件。[分享地址](https://www.youtube.com/watch?v=KYzlpRvWZ6c&t=1351)。

其中的核心观点其实很简单。
> 一个container组件功能是加载数据，然后将数据传递给相应子组件渲染。

## 为什么要有container component？
假设现在有这么一个场景，你需要设计一个组件用来展示用户的评论。而你此时此刻还不知道什么是container component，那么你可能会设计出一个包含所有内容的组件。

```javascript
// CommentList.js
class CommentList extends React.Component {
  constructor() {
    super();
    this.state = { comments: [] }
  }
  componentDidMount() {
    $.ajax({
      url: "/my-comments.json",
      dataType: 'json',
      success: function(comments) {
        this.setState({comments: comments});
      }.bind(this)
    });
  }
  render() {
    return <ul> {this.state.comments.map(renderComment)} </ul>;
  }
  renderComment({body, author}) {
    return <li>{body}—{author}</li>;
  }
}
```

`CommentList`组件负责加载数据和展示数据。虽然这没有什么错，但是并没有真的领略到React的魅力。

`CommentList`组件存在的问题:
 
- **可复用性低**
我们在`CommentList`组件做了两个不同事情，包含请求数据，展示数据。造成组件的可复用率低。
比如说想要获取一个来源不同的评论，此时组件是不可复用的。 
- **数据结构不稳定**
 `CommentList`组件中数据来源是依赖请求的数据。数据只要发生变化，组件也需要相应做出调整。

## 是时候谈论下什么是container component
针对上述提到的问题，我们稍微修改下代码。

首先把数据的请求放在container component中。
```javascript
// CommentListContainer.js
class CommentListContainer extends React.Component {
  constructor() {
    super();
    this.state = { comments: [] }
  }
  componentDidMount() {
    $.ajax({
      url: "/my-comments.json",
      dataType: 'json',
      success: function(comments) {
        this.setState({comments: comments});
      }.bind(this)
    });
  }
  render() {
    return <CommentList comments={this.state.comments} />;
  }
}
```
然后重写CommentList组件，让其带有`comments`属性。

```javascript
// CommentList.js
class CommentList extends React.Component {
  constructor(props) {
    super(props);
  }
  render() { 
    return <ul> {this.props.comments.map(renderComment)} </ul>;
  }
  renderComment({body, author}) {
    return <li>{body}—{author}</li>;
  }
}
```

相比原来的组件，重构后的组件有什么优势呢。

- **关注点分离**
`CommentListContainer`组件负责加载数据，`CommentList`组件负责展示数据。符合设计模式的单一原则。
- **组件的复用性**
`CommentList`组件可复用，不会随着请求数据结构的变化而变化。
- **健壮性**
`CommentList`组件的复用，提升了系统的健壮性，减少无谓的bug。

