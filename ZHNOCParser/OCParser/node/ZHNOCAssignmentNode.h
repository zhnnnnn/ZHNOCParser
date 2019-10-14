//
//  ZHNOCAssignmentNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/16.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHNOCAssignmentNode : ZHNOCNode
@property (nonatomic, strong) id value;
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
