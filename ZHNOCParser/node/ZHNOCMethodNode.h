//
//  ZHNOCMethodNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/12.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCNode.h"

@class ZHNOCMethodParamNode;
NS_ASSUME_NONNULL_BEGIN

@interface ZHNOCMethodNode : ZHNOCNode
@property (nonatomic, copy) NSString *targetName;
@property (nonatomic, copy) NSString *noParamSelectorName;
- (void)addParamNode:(ZHNOCMethodParamNode *)node;
@end

////////////////////////////
@interface ZHNOCMethodParamNode : ZHNOCNode
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) id value;
@end


NS_ASSUME_NONNULL_END
