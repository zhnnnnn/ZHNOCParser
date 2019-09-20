//
//  ZHNOCIfElseNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/16.
//  Copyright © 2019 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNOCAssembleNode.h"
#import "ZHNOCIfElseCondition.h"

typedef NS_ENUM(NSInteger,ZHNOCIfElseNodeType) {
    ZHNOCIfElseNodeType_if,
    ZHNOCIfElseNodeType_elseif,
    ZHNOCIfElseNodeType_else,
};

@interface ZHNOCIfElseNode : ZHNOCNode
@property (nonatomic, strong) id condition;
@property (nonatomic, assign) ZHNOCIfElseNodeType type;
@property (nonatomic, strong) ZHNOCAssembleNode *AssembleNode;

+ (instancetype)nodeWithCondition:(id)condition type:(ZHNOCIfElseNodeType)type assemble:(ZHNOCAssembleNode *)node;
@end
