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
        id nodeValue = [paramNode nodePerform];
        if (nodeValue) {
          [values addObject:nodeValue];
        }
    }
    if (self.noParamSelectorName.length > 0) {
        selectorName = self.noParamSelectorName;
    }
    SEL sel = NSSelectorFromString(selectorName);
    id obj = [self.targetNode nodePerform];
    object_getClassName(obj);
    return [ZHNOCMethodCaller zhn_callMethodWithObj:obj isClass:self.targetNode.isClass selector:sel params:values];
    return nil;
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
- (id)nodePerform {
    if ([self.value isKindOfClass:ZHNOCNode.class]) {
        return [(ZHNOCNode *)self.value nodePerform];
    }
    else {
        return self.value;
    }
}
@end

////////////////////////////
@implementation ZHNOCMethodTargetNode
- (id)nodePerform {
    if (self.node) {
        return [self.node nodePerform];
    }
    else if (self.targetName) {
        id obj = [self getObjInContextForKey:self.targetName];
        if (obj) {
            return obj;
        }
        else {
            _isClass = YES;
            Class cls = NSClassFromString(self.targetName);
            if (!cls) {
                NSLog(@"类 -- %@，不存在，请仔细检查",self.targetName);
            }
            return cls;
        }
    }
    return nil;
    
}
@end
