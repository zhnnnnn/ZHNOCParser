//
//  ZHNOCStructNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/29.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCStructNode.h"
#import <UIKit/UIKit.h>

@implementation ZHNOCStructNode
// TODO 代码优化
- (id)nodePerform {
    if ([self.cFuncName isEqualToString:@"CGRectMake"]) {
        if (self.values.count == 4) {
            id value = [NSValue valueWithCGRect:CGRectMake([self.values[0] floatValue], [self.values[1] floatValue], [self.values[2] floatValue], [self.values[3] floatValue])];
            return [ZHNOCStruct instanceWithValue:value type:ZHNOCStructType_CGRect];
        }
        else {
            NSAssert(self.values.count == 4, @"CGRectMake 需要传入四个值");
        }
    }

    if ([self.cFuncName isEqualToString:@"CGSizeMake"]) {
        if (self.values.count == 2) {
            id value = [NSValue valueWithCGSize:CGSizeMake([self.values[0] floatValue], [self.values[1] floatValue])];
            return [ZHNOCStruct instanceWithValue:value type:ZHNOCStructType_CGSize];
        }
        else {
            NSAssert(self.values.count == 2, @"CGSizeMake 需要传入2个值");
        }
    }
    
    if ([self.cFuncName isEqualToString:@"CGPointMake"]) {
        if (self.values.count == 2) {
            id value = [NSValue valueWithCGPoint:CGPointMake([self.values[0] floatValue], [self.values[1] floatValue])];
            return [ZHNOCStruct instanceWithValue:value type:ZHNOCStructType_CGPoint];
        }
        else {
            NSAssert(self.values.count == 2, @"CGPointMake 需要传入2个值");
        }
    }
    
    if ([self.cFuncName isEqualToString:@"CGAffineTransformMake"]) {
        if (self.values.count == 6) {
            id value = [NSValue valueWithCGAffineTransform:CGAffineTransformMake([self.values[0] floatValue], [self.values[1] floatValue], [self.values[2] floatValue], [self.values[3] floatValue], [self.values[4] floatValue], [self.values[5] floatValue])];
            return [ZHNOCStruct instanceWithValue:value type:ZHNOCStructType_CGAffineTransform];
        }
        else {
            NSAssert(self.values.count == 6, @"CGAffineTransformMake 需要传入2个值");
        }
    }
    
    if ([self.cFuncName isEqualToString:@"UIEdgeInsetsMake"]) {
        if (self.values.count == 4) {
            id value = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake([self.values[0] floatValue], [self.values[1] floatValue], [self.values[2] floatValue], [self.values[3] floatValue])];
            return [ZHNOCStruct instanceWithValue:value type:ZHNOCStructType_UIEdgeInsets];
        }
        else {
            NSAssert(self.values.count == 6, @"UIEdgeInsetsMake 需要传入2个值");
        }
    }

    if ([self.cFuncName isEqualToString:@"UIOffsetMake"]) {
        if (self.values.count == 2) {
            id value = [NSValue valueWithUIOffset:UIOffsetMake([self.values[0] floatValue], [self.values[1] floatValue])];
            return [ZHNOCStruct instanceWithValue:value type:ZHNOCStructType_UIOffset];
        }
        else {
            NSAssert(self.values.count == 2, @"UIOffsetMake 需要传入2个值");
        }
    }
    
    return nil;
}

@end

///////////////////////////
@implementation ZHNOCStruct
+ (instancetype)instanceWithValue:(id)value type:(ZHNOCStructType)type {
    ZHNOCStruct *obj = [[ZHNOCStruct alloc] init];
    obj.value = value;
    obj.type = type;
    return obj;
}

- (void)toCValue:(void *)obj {
    switch (self.type) {
        case ZHNOCStructType_CGRect:
        {
            *(CGRect *)obj = [self.value CGRectValue];
        }
            break;
        case ZHNOCStructType_CGPoint:
        {
            *(CGPoint *)obj = [self.value CGPointValue];
        }
            break;
        case ZHNOCStructType_CGSize:
        {
            *(CGSize *)obj = [self.value CGSizeValue];
        }
            break;
        case ZHNOCStructType_CGAffineTransform:
        {
            *(CGAffineTransform *)obj = [self.value CGAffineTransformValue];
        }
            break;
        case ZHNOCStructType_UIEdgeInsets: {
            *(UIEdgeInsets *)obj = [self.value UIEdgeInsetsValue];
        }
            break;
        case ZHNOCStructType_UIOffset: {
            *(UIOffset *)obj = [self.value UIOffsetValue];
        }
            break;
    }
}

+ (instancetype)instanceWithTypeString:(NSString *)typeStr value:(void *)value {
#define ZHNOCStructToTransModel(_type, _typeStr, func , _enum)\
    if ([typeStr isEqualToString:_typeStr]) {\
        _type cV = *(_type *)value;\
        NSValue *v = [NSValue func:cV];\
        ZHNOCStruct *obj = [ZHNOCStruct instanceWithValue:v type:_enum];\
        return obj;\
    }

    ZHNOCStructToTransModel(CGRect, @"CGRect", valueWithCGRect, ZHNOCStructType_CGRect)
    ZHNOCStructToTransModel(CGPoint, @"CGPoint", valueWithCGPoint, ZHNOCStructType_CGPoint)
    ZHNOCStructToTransModel(CGSize, @"CGSize", valueWithCGSize, ZHNOCStructType_CGSize)
    ZHNOCStructToTransModel(UIOffset, @"UIOffset", valueWithUIOffset, ZHNOCStructType_UIOffset)
    ZHNOCStructToTransModel(UIEdgeInsets, @"UIEdgeInsets", valueWithUIEdgeInsets, ZHNOCStructType_UIEdgeInsets)
    ZHNOCStructToTransModel(CGAffineTransform, @"CGAffineTransform", valueWithCGAffineTransform, ZHNOCStructType_CGAffineTransform)

    return nil;
}
@end
