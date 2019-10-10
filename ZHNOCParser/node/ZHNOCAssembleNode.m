//
//  ZHNOCAssembleNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/16.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCAssembleNode.h"
#import "ZHNOCASTContextManager.h"
#import "ZHNOCReturnNode.h"

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
    // 递归结构，如果不是跟节点需要return一个标志来让外面判断是否是return操作
    [ZHNASTContext pushLatestContext];
    for (ZHNOCNode *node in self.nodes) {
        if (self.isRoot) {
            if ([node isKindOfClass:ZHNOCReturnNode.class]) {
                id ret = [node nodePerform];
                [ZHNASTContext popLatestContext];
                return ret;
            }
            else {
                id obj = [node nodePerform];
                if ([obj isKindOfClass:ZHNOCReturnNode.class]) {
                    id ret = [(ZHNOCReturnNode *)obj nodePerform];
                    [ZHNASTContext popLatestContext];
                    return ret;
                }
            }
        }
        else {
            if ([node isKindOfClass:ZHNOCReturnNode.class]) {
                [ZHNASTContext popLatestContext];
                return node;
            }
            else {
                id obj = [node nodePerform];
                if ([obj isKindOfClass:ZHNOCReturnNode.class]) {
                    [ZHNASTContext popLatestContext];
                    return obj;
                }
            }
        }
    }
    [ZHNASTContext popLatestContext];
    return nil;
}

- (NSMutableArray *)nodes {
    if (_nodes == nil) {
        _nodes = [NSMutableArray array];
    }
    return _nodes;
}
@end
