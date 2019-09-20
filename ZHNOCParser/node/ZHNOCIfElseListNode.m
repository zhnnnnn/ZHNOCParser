//
//  ZHNOCIfElseListNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/16.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCIfElseListNode.h"
#import "ZHNOCIfElseNode.h"
#import "ZHNConditionNode.h"

@interface ZHNOCIfElseListNode()
@property (nonatomic, strong) NSMutableArray *nodes;
@end

@implementation ZHNOCIfElseListNode
- (void)addNodesFromArray:(NSArray *)ary {
    if (ary) {
        [self.nodes addObjectsFromArray:ary];
    }
}

- (void)addNode:(ZHNOCNode *)node {
    if (node) {
        [self.nodes addObject:node];
    }
}

- (id)nodePerform {
    id value = nil;
    for (int index = 0; index < self.nodes.count; index++) {
        ZHNOCIfElseNode *node = self.nodes[index];
        if (node.type == ZHNOCIfElseNodeType_if ||
            node.type == ZHNOCIfElseNodeType_elseif) {
            if (node.condition) {
                BOOL success = YES;
                if ([node.condition isKindOfClass:ZHNOCIfElseCondition.class]) {
                    ZHNOCIfElseCondition *condition = (ZHNOCIfElseCondition *)node.condition;
                    success = condition.success;
                }
                if ([node.condition isKindOfClass:ZHNConditionNode.class]) {
                    ZHNConditionNode *coditionNode = (ZHNConditionNode *)node.condition;
                    id res = [coditionNode nodePerform];
                    if ([res isKindOfClass:ZHNOCIfElseCondition.class]) {
                        success = [(ZHNOCIfElseCondition *)res success];
                    }
                }
                if (success) {
                    value = [node.AssembleNode nodePerform];
                    break;
                }                
            }
        }
        if (node.type == ZHNOCIfElseNodeType_else) {
            value = [node.AssembleNode nodePerform];
            break;
        }
    }
    
    return value;
}

- (NSMutableArray *)nodes {
    if (_nodes == nil) {
        _nodes = [NSMutableArray array];
    }
    return _nodes;
}
@end
