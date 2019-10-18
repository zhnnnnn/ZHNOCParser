//
//  ZHNTypeOCTransToLibffiManager.m
//  ZHNOCParser
//
//  Created by zhn on 2019/10/15.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNTypeEncodingTransManager.h"
#import <UIKit/UIKit.h>
#import "ZHNOCStructNode.h"

#if CGFLOAT_IS_DOUBLE
#define CGFloatValue doubleValue
#define numberWithCGFloat numberWithDouble
#else
#define CGFloatValue floatValue
#define numberWithCGFloat numberWithFloat
#endif

@implementation ZHNTypeEncodingTransManager
+ (ffi_type *)ffiTypeWithType:(NSString *)type {
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
            case '{':
        {
            // 解析struct
            // {CGSize=dd}
            // {CGAffineTransform=dddddd}
            // {CGRect={CGPoint=dd}{CGSize=dd}}
            NSString *typeStr = [NSString stringWithCString:c encoding:NSASCIIStringEncoding];
            NSInteger location = [typeStr rangeOfString:@"="].location;
            NSMutableArray *subTypeStrs = [NSMutableArray array];
            if (location != NSNotFound) {
                NSString *structName = [typeStr substringWithRange:NSMakeRange(location + 1, typeStr.length - 2 - location)];
                NSInteger start = 0;
                NSInteger end = 0;
                BOOL isStruct = NO;
                for (int index = 0; index < structName.length; index++) {
                    NSString *type;
                    NSString *i = [structName substringWithRange:NSMakeRange(index, 1)];
                    if ([i isEqualToString:@"{"]) {
                        isStruct = YES;
                        start = index;
                    }
                    if ([i isEqualToString:@"}"]) {
                        end = index;
                        type = [structName substringWithRange:NSMakeRange(start, end - start + 1)];
                        [subTypeStrs addObject:type];
                    }
                    if (!isStruct) {
                        type = i;
                        [subTypeStrs addObject:type];
                    }
                }
            }
            
            ffi_type *type = malloc(sizeof(ffi_type));
            type->alignment = 0;
            type->size = 0;
            type->type = FFI_TYPE_STRUCT;
            
            NSInteger subTypeCount = subTypeStrs.count;
            // http://yulingtianxia.com/blog/2019/04/27/BlockHook-with-Struct/
            // BlockHook里截取，修正了嵌套struct存在的野指针问题
            NSMutableData *data = [NSMutableData dataWithLength:(subTypeCount + 1) * sizeof(ffi_type *)];
            ffi_type **sub_types = data.mutableBytes;
            // 注释部分的代码是jspatch上截取的，嵌套的struct存在提前释放导致的野指针问题
            // ffi_type **sub_types = malloc(sizeof(ffi_type *) * (subTypeCount + 1));
            for (NSUInteger i=0; i<subTypeCount; i++) {
                NSString *typeStr = subTypeStrs[i];
                sub_types[i] = [ZHNTypeEncodingTransManager ffiTypeWithType:typeStr];
                type->size += sub_types[i]->size;
            }
            sub_types[subTypeCount] = NULL;
            type->elements = sub_types;
            return type;
        }
    }
    
    NSCAssert(NO, @"can't match a ffi_type of %@", type);
    return NULL;
}


+ (id)transCValueToOCObject:(void *)src typeString:(const char *)typeString {
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
            case '^':
            case '@':
            case '#': {
                return (__bridge id)(*(void**)src);
            }
            case '{': {
                NSString *typeStr = [NSString stringWithCString:typeString encoding:NSASCIIStringEncoding];
                NSInteger location = [typeStr rangeOfString:@"="].location;
                NSString *type = [typeStr substringWithRange:NSMakeRange(1, location-1)];
                return [ZHNOCStruct instanceWithTypeString:type value:src];
            }
        default:
            return nil;
    }
}
@end
