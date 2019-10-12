//
//  ZHNOCPPMMNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/10/10.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCNode.h"

typedef NS_ENUM(NSInteger,ZHNOCPPMMType) {
    ZHNOCPPMMType_plusplus,
    ZHNOCPPMMType_minusminus
};

NS_ASSUME_NONNULL_BEGIN

@interface ZHNOCPPMMNode : ZHNOCNode
@property (nonatomic, assign) ZHNOCPPMMType type;
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
