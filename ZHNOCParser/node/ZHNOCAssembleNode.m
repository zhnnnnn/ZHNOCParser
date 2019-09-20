//
//  ZHNOCAssembleNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/16.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCAssembleNode.h"

@interface ZHNOCAssembleNode()
@property (nonatomic, strong) NSMutableArray *nodes;
@end

@implementation ZHNOCAssembleNode
- (void)addNode:(ZHNOCNode *)node {
    if (node) {
        [self.nodes addObject:node];
    }
}

- (id)nodePerform {
    // 上下文处理
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    NSMutableArray *tContexts;
    if (self.contexts) {
        tContexts = [self.contexts mutableCopy];
    }
    else {
        tContexts = [NSMutableArray array];
    }
    [tContexts addObject:context];
    
    for (ZHNOCNode *node in self.nodes) {
        node.contexts = tContexts;
        [node nodePerform];
    }
    return nil;
}

- (NSMutableArray *)nodes {
    if (_nodes == nil) {
        _nodes = [NSMutableArray array];
    }
    return _nodes;
}
@end
