//
//  ZHNOCMethodNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/12.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCMethodNode.h"
#import "ZHNOCMethodCaller.h"

@interface ZHNOCMethodNode()
@property (nonatomic, strong) NSMutableArray *paramsNodes;
@end

@implementation ZHNOCMethodNode
- (void)addParamNode:(id)node {
    if (node) {
        [self.paramsNodes addObject:node];
    }
}

- (id)nodePerform {
    NSMutableArray *values = [NSMutableArray array];
    NSString *selectorName = @"";
    for (ZHNOCMethodParamNode *paramNode in self.paramsNodes) {
        selectorName = [NSString stringWithFormat:@"%@%@:",selectorName,paramNode.name];
        [values addObject:paramNode.value];
    }
    if (self.noParamSelectorName.length > 0) {
        selectorName = self.noParamSelectorName;
    }
    SEL sel = NSSelectorFromString(selectorName);
    id obj = [self getObjInContextForKey:self.targetName];
    if (obj) {// 实例方法
        return [ZHNOCMethodCaller zhn_callMethodWithObj:obj isClass:NO selector:sel params:values];
    }
    else {// 类方法
        Class cls = NSClassFromString(self.targetName);
        if (!cls) {
            NSLog(@"%@ : 类或者对象不存在",self.targetName);
            return nil;
        }
        return [ZHNOCMethodCaller zhn_callMethodWithObj:cls isClass:YES selector:sel params:values];
    }
}

#pragma mark - getters
- (NSMutableArray *)paramsNodes {
    if (_paramsNodes == nil) {
        _paramsNodes = [NSMutableArray array];
    }
    return _paramsNodes;
}
@end


////////////////////////////
@implementation ZHNOCMethodParamNode

@end
