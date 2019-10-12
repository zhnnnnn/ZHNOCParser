//
//  ZHNOCForInCycleNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/10/11.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCNode.h"
#import "ZHNOCAssembleNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHNOCForInCycleNode : ZHNOCNode
@property (nonatomic, strong) ZHNOCAssembleNode *assembleNode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) ZHNOCNode *valuesNode;
@end

NS_ASSUME_NONNULL_END
