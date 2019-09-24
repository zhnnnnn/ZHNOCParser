//
//  ZHNConditionNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/19.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCAssembleNode.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ZHNConditionNodeType) {
    ZHNConditionNodeType_equal,
    ZHNConditionNodeType_notEqual,
    ZHNConditionNodeType_greaterOrEqual,
    ZHNConditionNodeType_lessOrEqual,
    ZHNConditionNodeType_greater,
    ZHNConditionNodeType_less,
    
    ZHNConditionNodeType_and, // &&
    ZHNConditionNodeType_or, // || 
};

@interface ZHNConditionNode : ZHNOCNode
@property (nonatomic, strong) id value1;
@property (nonatomic, strong) id value2;
@property (nonatomic, assign) ZHNConditionNodeType conditionType;
@end

NS_ASSUME_NONNULL_END
