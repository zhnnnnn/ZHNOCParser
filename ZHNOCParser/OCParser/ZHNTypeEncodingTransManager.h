//
//  ZHNTypeOCTransToLibffiManager.h
//  ZHNOCParser
//
//  Created by zhn on 2019/10/15.
//  Copyright © 2019 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ffi.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHNTypeEncodingTransManager : NSObject
// oc参数签名转lbiffi签名
+ (ffi_type *)ffiTypeWithType:(NSString *)type;
// c值转oc对象
+ (id)transCValueToOCObject:(void *)src typeString:(const char *)typeString;
@end

NS_ASSUME_NONNULL_END
