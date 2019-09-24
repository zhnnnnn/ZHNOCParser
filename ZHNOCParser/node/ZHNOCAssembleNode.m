//
//  ZHNOCAssembleNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/16.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCAssembleNode.h"
#import "ZHNOCASTContextManager.h"

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
    [ZHNASTContext pushLatestContext];
    for (ZHNOCNode *node in self.nodes) {
        [node nodePerform];
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
