---
title: react 高阶组件
date: 2017-03-01 15:30:56
tags: [react]
categories: [前端]
---

# react 高阶组件

## 什么是高阶组件？

react高阶组件主要目的是让原有的组件扩展出其他功能，主要是通过闭包与函数的方式，改变原有组件的行为。我们可以通过编写高阶组件来达到不修改原组件的代码就能增强组件的目的。
高阶组件的定义如下：
```
HOC: ReactComponent -> ReactComponent
```

demo:
```
function HOC(WrappedComponent) {
  return class PP extends React.Component {
    const newProps = {
        user: myUser,
    };
    render() {
      return <WrappedComponent {...this.props} {...newProps}/>
    }
  }
}
```

往`WrappedComponent`组件中新增了属性`user`。

## 高阶组件的用途
- 代码复用，抽象程序内部逻辑（logic and bootstrap abstraction）
- 渲染劫持（Render Highjacking）
- 提取和操作 state
- 操作 props

## 高阶组件的实际应用

通过分析`react-redux`源码来看看高阶组件的实际定义。

```
export function createConnect({
  connectHOC = connectAdvanced,
  mapStateToPropsFactories = defaultMapStateToPropsFactories,
  mapDispatchToPropsFactories = defaultMapDispatchToPropsFactories,
  mergePropsFactories = defaultMergePropsFactories,
  selectorFactory = defaultSelectorFactory
} = {}) {
  return function connect(
    mapStateToProps,
    mapDispatchToProps,
    mergeProps,
    {
      pure = true,
      areStatesEqual = strictEqual,
      areOwnPropsEqual = shallowEqual,
      areStatePropsEqual = shallowEqual,
      areMergedPropsEqual = shallowEqual,
      ...extraOptions
    } = {}
  ) {
    const initMapStateToProps = match(mapStateToProps, mapStateToPropsFactories, 'mapStateToProps')
    const initMapDispatchToProps = match(mapDispatchToProps, mapDispatchToPropsFactories, 'mapDispatchToProps')
    const initMergeProps = match(mergeProps, mergePropsFactories, 'mergeProps')

    return connectHOC(selectorFactory, {
      // used in error messages
      methodName: 'connect',

       // used to compute Connect's displayName from the wrapped component's displayName.
      getDisplayName: name => `Connect(${name})`,

      // if mapStateToProps is falsy, the Connect component doesn't subscribe to store state changes
      shouldHandleStateChanges: Boolean(mapStateToProps),

      // passed through to selectorFactory
      initMapStateToProps,
      initMapDispatchToProps,
      initMergeProps,
      pure,
      areStatesEqual,
      areOwnPropsEqual,
      areStatePropsEqual,
      areMergedPropsEqual,

      // any extra options args can override defaults of connect or connectAdvanced
      ...extraOptions
    })
  }
}

export default createConnect()
```

## 参考
http://qianduan.guru/2017/01/11/react-higher-order-components-in-depth