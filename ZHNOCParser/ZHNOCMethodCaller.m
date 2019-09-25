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
            // todo struct
            break;
        }
        default:
            break;
    }
}

NS_INLINE ffi_type * ffiTypeWithType (NSString *type) {
    if ([type isEqualToString:@"@?"]) {
        return &ffi_type_pointer;
    }
    const char *c = [type UTF8String];
    switch (c[0]) {
        case 'v':
            return &ffi_type_void;
        case 'c':
            return &ffi_type_schar;
        case 'C':
            return &ffi_type_uchar;
        case 's':
            return &ffi_type_sshort;
        case 'S':
            return &ffi_type_ushort;
        case 'i':
            return &ffi_type_sint;
        case 'I':
            return &ffi_type_uint;
        case 'l':
            return &ffi_type_slong;
        case 'L':
            return &ffi_type_ulong;
        case 'q':
            return &ffi_type_sint64;
        case 'Q':
            return &ffi_type_uint64;
        case 'f':
            return &ffi_type_float;
        case 'd':
            return &ffi_type_double;
        case 'F':
#if CGFLOAT_IS_DOUBLE
            return &ffi_type_double;
#else
            return &ffi_type_float;
#endif
        case 'B':
            return &ffi_type_uint8;
        case '^':
            return &ffi_type_pointer;
        case '@':
            return &ffi_type_pointer;
        case '#':
            return &ffi_type_pointer;
        case ':':
            return &ffi_type_schar;
            
        // TODO struct
    }
    
    NSCAssert(NO, @"can't match a ffi_type of %@", type);
    return NULL;
}

NS_INLINE id CValueToOCObject(void *src,const char *typeString) {
    switch (typeString[0]) {
#define JP_FFI_RETURN_CASE(_typeString, _type, _selector)\
case _typeString:{\
_type v = *(_type *)src;\
return [NSNumber _selector:v];\
}
            JP_FFI_RETURN_CASE('c', char, numberWithChar)
            JP_FFI_RETURN_CASE('C', unsigned char, numberWithUnsignedChar)
            JP_FFI_RETURN_CASE('s', short, numberWithShort)
            JP_FFI_RETURN_CASE('S', unsigned short, numberWithUnsignedShort)
            JP_FFI_RETURN_CASE('i', int, numberWithInt)
            JP_FFI_RETURN_CASE('I', unsigned int, numberWithUnsignedInt)
            JP_FFI_RETURN_CASE('l', long, numberWithLong)
            JP_FFI_RETURN_CASE('L', unsigned long, numberWithUnsignedLong)
            JP_FFI_RETURN_CASE('q', long long, numberWithLongLong)
            JP_FFI_RETURN_CASE('Q', unsigned long long, numberWithUnsignedLongLong)
            JP_FFI_RETURN_CASE('f', float, numberWithFloat)
            JP_FFI_RETURN_CASE('F', CGFloat, numberWithCGFloat)
            JP_FFI_RETURN_CASE('d', double, numberWithDouble)
            JP_FFI_RETURN_CASE('B', BOOL, numberWithBool)
        case '^': {
            // TODO block
        }
        case '@':
        case '#': {
            return (__bridge id)(*(void**)src);
        }
        case '{': {
            // TODO struct
        }
        default:
            return nil;
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
    NSMethodSignature *signature = [cls instanceMethodSignatureForSelector:selector];
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
        types[index] = ffiTypeWithType(t);
    }
    // 返回值类型
    NSString *ocRet = [NSString stringWithUTF8String:[signature methodReturnType]];
    ffi_type *retType = ffiTypeWithType(ocRet);
    
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
    ffi_prep_cif(&cif, FFI_DEFAULT_ABI, (int)typeStrings.count, retType, types);
    // 动态调用fun1
    ffi_call(&cif, imp, returnPtr, args);
    
    ret = CValueToOCObject(returnPtr, ocRet.UTF8String);
    
    return ret;
}

@end


