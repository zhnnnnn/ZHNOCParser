#0x0 前言
15年的时候滴滴写了一系列的文章介绍了他们的热修框架DynamicCocoa，其中动态下发OC代码来执行热修这个点给当时还是菜鸡的我留下很深很深的印象。时过境迁这个框架的开源计划也因为JSPatch被禁而难产了。但是现在随着知识水平的提升，对于实现这个效果也慢慢有了一些想法。19年尝试实现了下，路完全是走通了，基础的功能也都加上了。但是实在没有精力再往下完善了，开源出来供大家参考学习。
# 0x1 效果
## 0x11 动态化
<div align=center><img width="500" height="370" src="https://raw.githubusercontent.com/zhnnnnn/ZHNCosmos_GIFs/master/parser_01.png"/></div>

动态执行下发的oc代码。可以用OC做页面的动态化，大家都在往大前端走的情况下这样做太非主流。但是针对平台特定的功能还是很适用的，比如某些下发的开关、埋点等等可以加上动态的逻辑了。
## 0x12 热修
通过这个解释器添加了一种没有任何学习成本的编写方案。并且底层的hook方案也是和JSPatch之类的走消息转发完全不同。没试过审核能不能过，感觉问题不大，如果真要用这个方案务必低调。
```
PATCH(ViewController,{
- (void)logTitleWithIndex:(NSInteger)index {
    if (index > self.titleStrs.count) {
        [SVProgressHUD showErrorWithStatus:@"index太大啦"];
        return;
    } else {
        NSString *str = [self.titleStrs objectAtIndex:index];
        [SVProgressHUD showSuccessWithStatus:str];
    }
}
})
```

# 0x2 解析原理

## 0x21 AST

比较核心的是需要解析代码得到AST(抽象语法树)

<div align=center><img width="400" height="500" src="https://raw.githubusercontent.com/zhnnnnn/ZHNCosmos_GIFs/master/parser_02.png"/></div>

## 0x22 yacc / lex
通过Xcode自带的 lex(词法分线器) / yacc(词法分析器) 解析出AST。这里用`[[UIView alloc] init]`举例最后得到的节点结构如下所示。其它的for循环/赋值/运算 等等都是殊途同归。

<div align=center><img width="500" height="220" src="https://raw.githubusercontent.com/zhnnnnn/ZHNCosmos_GIFs/master/parser_03.png"/></div>

## 0x23 libffi

比较关键的一个点，方法调用这边用libffi来做。libffi还有一个用处是来处理动态block。因为block是也是一个动态对象，但是block需要一个函数与之对应，所以一定程度上动态block的创建也可以认为是动态加一个函数。libffi支持这个功能，JSPatch也是这么处理block的。

# 0x3 热修原理
区别于JSPatch等等走runtime消息转发的方案，我这边尝试用libffi添加一个函数然后replace 要hook方法对应的函数指针来处理，这个方案由于省略掉了消息转发流程，理论上性能要好很多。而且重复hook也更加的安全。通过这个hook方案你甚至都是可以hook block，并且前段实在我确实发现有人已经这么做了。
