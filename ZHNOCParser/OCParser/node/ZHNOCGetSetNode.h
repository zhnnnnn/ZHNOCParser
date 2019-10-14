//
//  ZHNOCGetSetNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/25.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCNode.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ZHNOCGetSetNodeType) {
    ZHNOCGetSetNodeType_get,
    ZHNOCGetSetNodeType_set,
};

@interface ZHNOCGetSetNode : ZHNOCNode
@property (nonatomic, assign) ZHNOCGetSetNodeType type;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) NSMutableArray *names;
@end


NS_ASSUME_NONNULL_END
