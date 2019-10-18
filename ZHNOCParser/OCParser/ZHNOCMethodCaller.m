//
//  ZHNOCMethodCaller.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/6.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCMethodCaller.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "ffi.h"
#import <UIKit/UIKit.h>
#import "ZHNOCStructNode.h"
#import "ZHNTypeEncodingTransManager.h"

#if CGFLOAT_IS_DOUBLE
#define CGFloatValue doubleValue
#define numberWithCGFloat numberWithDouble
#else
#define CGFloatValue floatValue
#define numberWithCGFloat numberWithFloat
#endif

NS_INLINE void configParam(id object, const char *typeString, void *arg) {
#define JP_CALL_ARG_CASE(_typeString, _type, _selector)\
case _typeString:{\
*(_type *)arg = [(NSNumber *)object _selector];\
break;\
}
    switch (typeString[0]) {
            JP_CALL_ARG_CASE('c', char, charValue)
            JP_CALL_ARG_CASE('C', unsigned char, unsignedCharValue)
            JP_CALL_ARG_CASE('s', short, shortValue)
            JP_CALL_ARG_CASE('S', unsigned short, unsignedShortValue)
            JP_CALL_ARG_CASE('i', int, intValue)
            JP_CALL_ARG_CASE('I', unsigned int, unsignedIntValue)
            JP_CALL_ARG_CASE('l', long, longValue)
            JP_CALL_ARG_CASE('L', unsigned long, unsignedLongValue)
            JP_CALL_ARG_CASE('q', long long, longLongValue)
            JP_CALL_ARG_CASE('Q', unsigned long long, unsignedLongLongValue)
            JP_CALL_ARG_CASE('f', float, floatValue)
            JP_CALL_ARG_CASE('F', CGFloat, CGFloatValue)
            JP_CALL_ARG_CASE('d', double, doubleValue)
            JP_CALL_ARG_CASE('B', BOOL, boolValue)
        case '^': {
            *(void **)arg = (__bridge void *)(object);
            break;
        }
        case '#':
        case '@': {
            *(void **)arg = (__bridge void *)(object);
            break;
        }
        case '{': {
            if ([object isKindOfClass:ZHNOCStruct.class]) {
                [(ZHNOCStruct *)object toCValue:arg];
            }
            break;
        }
        default:
            break;
    }
}

@implementation ZHNOCMethodCaller
+ (id)zhn_callMethodWithObj:(id)obj isClass:(BOOL)isClass selector:(SEL)selector params:(NSArray *)params {
      
    Class cls = object_getClass(obj);
    Method method;
    if (isClass) {
        method = class_getClassMethod(cls, selector);
    }
    else {
        method = class_getInstanceMethod(cls, selector);
    }
    IMP imp = method_getImplementation(method);
    
    if (!imp) {
        NSString *noticeStr = [NSString stringWithFormat:@"🔥🔥🔥 类%@对应的%@方法不存在，请仔细检查",NSStringFromClass(cls),NSStringFromSelector(selector)];
        NSAssert(imp,noticeStr);
        return nil;
    }
    
    NSMutableArray *typeStrings = [NSMutableArray array];
    NSMethodSignature *signature;
    if (isClass) {
        signature = [cls instanceMethodSignatureForSelector:selector];
    }
    else {
        signature = [obj methodSignatureForSelector:selector];
    }
    NSInteger argTypeCount = signature.numberOfArguments;
    for (int index = 0; index < argTypeCount; index++) {
        const char *t = [signature getArgumentTypeAtIndex:index];
        NSString *OCt = [NSString stringWithUTF8String:t];
        [typeStrings addObject:OCt];
    }
    
    // 入参类型
    ffi_type **types;
    types = alloca(sizeof(ffi_type *) *typeStrings.count);
    for (int index = 0; index < typeStrings.count; index++) {
        NSString *t = typeStrings[index];
        types[index] = [ZHNTypeEncodingTransManager ffiTypeWithType:t];
    }
    // 返回值类型
    NSString *ocRet = [NSString stringWithUTF8String:[signature methodReturnType]];
    ffi_type *retType = [ZHNTypeEncodingTransManager ffiTypeWithType:ocRet];
    
    // 参数值
    void **args;
    args = alloca(sizeof(void *) * typeStrings.count);
    args[0] = &obj;
    args[1] = &selector;
    for (int index = 0; index < params.count; index++) {
        id param = params[index];
        NSString *t = typeStrings[index + 2];
        ffi_type *type = types[index + 2];
        void *ffiArgPtr = alloca(type->size);
        configParam(param, [t UTF8String],ffiArgPtr);
        args[index + 2] = ffiArgPtr;
    }

    // 返回值
    id ret = nil;
    void *returnPtr = NULL;
    if (retType->size) {
        returnPtr = alloca(retType->size);
    }

    ffi_cif cif;
    ffi_status status = ffi_prep_cif(&cif, FFI_DEFAULT_ABI, (int)typeStrings.count, retType, types);
    if (status == FFI_OK) {
        ffi_call(&cif, imp, returnPtr, args);
        ret = [ZHNTypeEncodingTransManager transCValueToOCObject:returnPtr typeString:ocRet.UTF8String];
    }
    
    return ret;
}

@end


