//
//  ZHNOCBlockNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/10/8.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCNode.h"
#import "ZHNOCAssembleNode.h"

// tip 参数只支持指针和数字 struct union等都不支持
typedef NS_ENUM(NSInteger,ZHNOCBlockParamType) {
    ZHNOCBlockParamType_pointer,
    ZHNOCBlockParamType_num
};

@class ZHNOCBlockParam;
@interface ZHNOCBlockNode : ZHNOCNode
- (void)addBlockParams:(NSArray *)params;
@property (nonatomic, strong) ZHNOCAssembleNode *assembleNode;
@property (nonatomic, copy) NSString *returnType;// char int ...
@end


/////////////////////
@interface ZHNOCBlockParam : NSObject
@property (nonatomic, assign) ZHNOCBlockParamType paramType;
@property (nonatomic, copy) NSString *name;
@end

