//
//  ZHNOCForCycleNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/10/10.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCNode.h"
#import "ZHNOCAssembleNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHNOCForCycleNode : ZHNOCNode
@property (nonatomic, strong) ZHNOCAssembleNode *assembleNode;
@property (nonatomic, strong) ZHNOCNode *defineNode;
@property (nonatomic, strong) ZHNOCNode *conditionNode;
@property (nonatomic, strong) ZHNOCNode *operationNode;
@end

NS_ASSUME_NONNULL_END
