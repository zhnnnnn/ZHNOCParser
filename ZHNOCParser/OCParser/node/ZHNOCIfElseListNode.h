//
//  ZHNOCIfElseListNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/16.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCAssembleNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHNOCIfElseListNode : ZHNOCNode
- (void)addNodesFromArray:(NSArray *)ary;
- (void)addNode:(ZHNOCNode *)node;
@end

NS_ASSUME_NONNULL_END
