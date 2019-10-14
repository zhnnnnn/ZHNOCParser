//
//  ZHNOCIfElseNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/16.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCIfElseNode.h"

@implementation ZHNOCIfElseNode
+ (instancetype)nodeWithCondition:(id)condition type:(ZHNOCIfElseNodeType)type assemble:(ZHNOCAssembleNode *)node {
    ZHNOCIfElseNode *ifelseNode = [[ZHNOCIfElseNode alloc] init];
    ifelseNode.condition = condition;
    ifelseNode.type = type;
    ifelseNode.AssembleNode = node;
    return ifelseNode;
}

@end
