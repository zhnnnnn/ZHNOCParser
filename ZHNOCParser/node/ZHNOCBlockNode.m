//
//  ZHNOCBlockNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/10/8.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCBlockNode.h"
#import <UIKit/UIKit.h>
#import "ffi.h"
#import "ZHNOCASTContextManager.h"
#import "ZHNOCReturnNode.h"

enum {
    BLOCK_DEALLOCATING =      (0x0001),
    BLOCK_REFCOUNT_MASK =     (0xfffe),
    BLOCK_NEEDS_FREE =        (1 << 24),
    BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
    BLOCK_HAS_CTOR =          (1 << 26),
    BLOCK_IS_GC =             (1 << 27),
    BLOCK_IS_GLOBAL =         (1 << 28),
    BLOCK_USE_STRET =         (1 << 29),
    BLOCK_HAS_SIGNATURE  =    (1 << 30)
};

struct JPSimulateBlock {
    void *isa;
    int flags;
    int reserved;
    void *invoke;
    struct JPSimulateBlockDescriptor *descriptor;
    void *wrapper;
};

struct JPSimulateBlockDescriptor {
    //Block_descriptor_1
    struct {
        unsigned long int reserved;
        unsigned long int size;
    };
    
    //Block_descriptor_2
    struct {
        // requires BLOCK_HAS_COPY_DISPOSE
        void (*copy)(void *dst, const void *src);
        void (*dispose)(const void *);
    };
    
    //Block_descriptor_3
    struct {
        // requires BLOCK_HAS_SIGNATURE
        const char *signature;
    };
};

void copy_helper(struct JPSimulateBlock *dst, struct JPSimulateBlock *src)
{
    // do not copy anything is this funcion! just retain if need.
    CFRetain(dst->wrapper);
}

void dispose_helper(struct JPSimulateBlock *src)
{
    CFRelease(src->wrapper);
}

@interface ZHNOCBlockNode()
{
    ffi_cif *_cifPtr;
    ffi_type **_args;
    ffi_closure *_closure;
    BOOL _generatedPtr;
    void *_blockPtr;
    struct JPSimulateBlockDescriptor *_descriptor;
}
@property (nonatomic, strong) NSMutableArray *params;
@end

void JPBlockInterpreter(ffi_cif *cif, void *ret, void **args, void *userdata) {
    ZHNOCBlockNode *block = (__bridge ZHNOCBlockNode *)userdata;
    [ZHNASTContext pushLatestContext];
    for (int index = 0; index < block.params.count; index++) {
        ZHNOCBlockParam *param = block.params[index];
        // 0是block自己参数获取从1开始
        void *argumentPtr = args[index + 1];
        id value = nil;
        if (param.paramType == ZHNOCBlockParamType_num) {
            double dvalue = *(double *)argumentPtr;
            value = [NSNumber numberWithDouble:dvalue];
        }
        else {
            value = (__bridge id)(*(void**)argumentPtr);
        }
        // 数据写入到context
        [ZHNASTContext assignmentObj:value forKey:param.name];
    }
    
    if (block.returnType.length == 0) {
        [block.assembleNode nodePerform];
    }
    else {
        block.assembleNode.isRoot = YES;
        id returnObj = [block.assembleNode nodePerform];
        if ([block.returnType isEqualToString:@"*"]) {
            void **retPtrPtr = ret;
            *retPtrPtr = (__bridge void *)returnObj;
        }
        else {
#define ZHN_BLOCK_RET_TRANS(typeStr,type,sel)\
            if ([block.returnType isEqualToString:typeStr]) {\
                type *retPtr = ret;\
                *retPtr = [(NSNumber *)returnObj sel];\
            }\

            ZHN_BLOCK_RET_TRANS(@"char", char, charValue)
            ZHN_BLOCK_RET_TRANS(@"float", float, floatValue)
            ZHN_BLOCK_RET_TRANS(@"double", double, doubleValue)
            ZHN_BLOCK_RET_TRANS(@"int", int, intValue)
            ZHN_BLOCK_RET_TRANS(@"short", short, shortValue)
            ZHN_BLOCK_RET_TRANS(@"NSInteger", int, intValue)
            ZHN_BLOCK_RET_TRANS(@"CGFloat", double, doubleValue)
        }
    }
    
    [ZHNASTContext popLatestContext];
}

@implementation ZHNOCBlockNode

- (id)nodePerform {
    return [self blockPtr];
}

- (void)addBlockParams:(NSArray *)params {
    for (ZHNOCBlockParam *param in params) {
        [self.params addObject:param];
    }
}

- (id)blockPtr
{
    if (_generatedPtr) {
        return (__bridge id _Nonnull)(_blockPtr);
    }
    _generatedPtr = YES;
    
    ffi_type *returnType = [self ffiTypeForTypeString:self.returnType];
    
    NSUInteger argumentCount = self.params.count + 1;
    
    _cifPtr = malloc(sizeof(ffi_cif));
    
    void *blockImp = NULL;
    
    _args = malloc(sizeof(ffi_type *) *argumentCount) ;
    
    _args[0] = &ffi_type_pointer;
    for (int index = 0; index < self.params.count; index++) {
        // 都赋值ffi_type_pointer没啥问题，解析的时候按照对象来解析
        _args[index + 1] = &ffi_type_pointer;
    }
    
    _closure = ffi_closure_alloc(sizeof(ffi_closure), (void **)&blockImp);
    
    if(ffi_prep_cif(_cifPtr, FFI_DEFAULT_ABI, 2, returnType, _args) == FFI_OK) {
        if (ffi_prep_closure_loc(_closure, _cifPtr, JPBlockInterpreter, (__bridge void *)self, blockImp) != FFI_OK) {
            NSAssert(NO, @"generate block error");
        }
    }
    
    NSString *sig = @"@?";
    for (int index = 0; index < self.params.count; index++) {
        sig = [NSString stringWithFormat:@"%@@",sig];
    }
    struct JPSimulateBlockDescriptor descriptor = {
        0,
        sizeof(struct JPSimulateBlock),
        (void (*)(void *dst, const void *src))copy_helper,
        (void (*)(const void *src))dispose_helper,
        [sig cStringUsingEncoding:NSASCIIStringEncoding]
    };
    
    _descriptor = malloc(sizeof(struct JPSimulateBlockDescriptor));
    memcpy(_descriptor, &descriptor, sizeof(struct JPSimulateBlockDescriptor));
    
    struct JPSimulateBlock simulateBlock = {
        &_NSConcreteStackBlock,
        (BLOCK_HAS_COPY_DISPOSE | BLOCK_HAS_SIGNATURE),
        0,
        blockImp,
        _descriptor,
        (__bridge void*)self
    };
    
    _blockPtr = Block_copy(&simulateBlock);
    return (__bridge id _Nonnull)(_blockPtr);
}

- (ffi_type *)ffiTypeForTypeString:(NSString *)typeStr {
#define ZHN_BLOCK_RET_TYPE(type,ffitype)\
    if ([typeStr isEqualToString:type]) {\
        return &ffitype;\
    }\

    ZHN_BLOCK_RET_TYPE(@"void", ffi_type_void)
    ZHN_BLOCK_RET_TYPE(@"char", ffi_type_schar)
    ZHN_BLOCK_RET_TYPE(@"short", ffi_type_sshort)
    ZHN_BLOCK_RET_TYPE(@"int", ffi_type_sint)
    ZHN_BLOCK_RET_TYPE(@"float", ffi_type_float)
    ZHN_BLOCK_RET_TYPE(@"double", ffi_type_double)
    ZHN_BLOCK_RET_TYPE(@"NSInteger", ffi_type_sint)
    ZHN_BLOCK_RET_TYPE(@"CGFloat", ffi_type_double)
    ZHN_BLOCK_RET_TYPE(@"*", ffi_type_pointer)
    
    return &ffi_type_void;
}

- (void)dealloc
{
    ffi_closure_free(_closure);
    free(_args);
    free(_cifPtr);
    free(_descriptor);
    return;
}

- (NSMutableArray *)params {
    if (_params == nil) {
        _params = [NSMutableArray array];
    }
    return _params;
}

@end


////////////////////////////////
@implementation ZHNOCBlockParam
@end
