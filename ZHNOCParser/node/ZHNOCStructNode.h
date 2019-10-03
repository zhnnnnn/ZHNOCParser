//
//  ZHNOCStructNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/29.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCNode.h"

@interface ZHNOCStructNode : ZHNOCNode
@property (nonatomic, copy) NSString *cFuncName;
@property (nonatomic, strong) NSMutableArray *values;
@end

/////////////////////////////
typedef NS_ENUM(NSInteger,ZHNOCStructType) {
    ZHNOCStructType_CGRect,
    ZHNOCStructType_CGSize,
    ZHNOCStructType_CGPoint,
    ZHNOCStructType_CGAffineTransform,
    ZHNOCStructType_UIEdgeInsets,
    ZHNOCStructType_UIOffset
};

@interface ZHNOCStruct : NSObject
@property (nonatomic, strong) id value;
@property (nonatomic, assign) ZHNOCStructType type;
+ (instancetype)instanceWithTypeString:(NSString *)typeStr value:(void *)value;
+ (instancetype)instanceWithValue:(id)value type:(ZHNOCStructType)type;
- (void)toCValue:(void *)obj;
@end


