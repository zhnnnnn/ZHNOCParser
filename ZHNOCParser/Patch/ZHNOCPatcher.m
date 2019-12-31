//
//  ZHNOCPatcher.m
//  ZHNOCParser
//
//  Created by zhn on 2019/10/15.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCPatcher.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "ffi.h"
#import "ZHNTypeEncodingTransManager.h"
#import "ZHNOCASTContextManager.h"
#import "ZHNOCParser.h"

void hookffi_function(ffi_cif *cif, void *ret, void **args, void *userdata) {
    ZHNOCPatchItem *patchItem = (__bridge ZHNOCPatchItem *)userdata;
    [ZHNASTContext pushLatestContext];
    // 0对应self
    void *selfPtr = args[0];
    id selfObj = (__bridge id)(*(void**)selfPtr);
    [ZHNASTContext assignmentObj:selfObj forKey:@"self"];
    // 后续参数
    for (int index = 2; index < patchItem.typeStrings.count; index++) {
        NSString *type = patchItem.typeStrings[index];
        void *argumentPtr = args[index];
        id obj = [ZHNTypeEncodingTransManager transCValueToOCObject:argumentPtr typeString:type.UTF8String];
        NSString *name = patchItem.paramNames[index - 2];
        [ZHNASTContext assignmentObj:obj forKey:name];
    }
    if (patchItem.blockString) {
       [ZHNOCParser parseText:patchItem.blockString];
    }
    if (patchItem.node) {
        [ZHNOCParser performRootNode:patchItem.node];
    }
    
    // TODO 返回值处理
    [ZHNASTContext popLatestContext];
}

@interface ZHNOCPatcher()
@property (nonatomic, strong) NSMutableArray *patchItems;
@end

@implementation ZHNOCPatcher
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ZHNOCPatcher *patcher = nil;
    dispatch_once(&onceToken, ^{
        patcher = [[ZHNOCPatcher alloc] init];
    });
    return patcher;
}

- (ZHNOCPatchItem *)zhn_patchClass:(Class)cls selector:(SEL)sel isClassMethod:(BOOL)isClassMethod blockString:(NSString *)blockString {
    ZHNOCPatchItem *item = [ZHNOCPatchItem instancePatchItemWithClass:cls selector:sel isClassMethod:isClassMethod blockString:blockString];
    [item patch];
    [self.patchItems addObject:item];
    return item;
}

- (ZHNOCPatchItem *)zhn_patchClass:(Class)cls selector:(SEL)sel isClassMethod:(BOOL)isClassMethod node:(ZHNOCNode *)node {
    ZHNOCPatchItem *item = [ZHNOCPatchItem instancePatchItemWithClass:cls selector:sel isClassMethod:isClassMethod node:node];
    [item patch];
    [self.patchItems addObject:item];
    return item;
}

- (NSMutableArray *)patchItems {
    if (_patchItems == nil) {
        _patchItems = [NSMutableArray array];
    }
    return _patchItems;
}
@end

//////////////////////
@interface ZHNOCPatchItem()
{
    ffi_cif *_cif;
    ffi_type **_types;
    ffi_closure *_closure;
}
@end
@implementation ZHNOCPatchItem
+ (instancetype)instancePatchItemWithClass:(Class)cls selector:(SEL)sel isClassMethod:(BOOL)isClassMethod blockString:(NSString *)blockString {
    ZHNOCPatchItem *patchItem = [[ZHNOCPatchItem alloc] init];
    patchItem.sel = sel;
    patchItem.cls = cls;
    patchItem.isClassMethod = isClassMethod;
    patchItem.blockString = blockString;
    return patchItem;
}

+ (instancetype)instancePatchItemWithClass:(Class)cls selector:(SEL)sel isClassMethod:(BOOL)isClassMethod node:(ZHNOCNode *)node {
    ZHNOCPatchItem *patchItem = [[ZHNOCPatchItem alloc] init];
    patchItem.sel = sel;
    patchItem.cls = cls;
    patchItem.node = node;
    patchItem.isClassMethod = isClassMethod;
    return patchItem;
}

- (void)patch {
    NSMethodSignature *signature;
    if (self.isClassMethod) {
        signature = [object_getClass(self.cls) instanceMethodSignatureForSelector:self.sel];
    }
    else {
        signature = [self.cls instanceMethodSignatureForSelector:self.sel];
    }
    
    if (!signature) {
        // TODO报警
        NSLog(@"⚠️⚠️⚠️⚠️ class:%@ -- 方法:%@ 不存在",NSStringFromClass(self.cls),NSStringFromSelector(self.sel));
        return;
    }
    
    NSMutableArray *typeStrings = [NSMutableArray array];
    NSInteger argTypeCount = signature.numberOfArguments;
    for (int index = 0; index < argTypeCount; index++) {
        const char *t = [signature getArgumentTypeAtIndex:index];
        NSString *OCt = [NSString stringWithUTF8String:t];
        [typeStrings addObject:OCt];
    }
    self.typeStrings = typeStrings;
    // 入参类型
    _types = malloc(sizeof(ffi_type *) *typeStrings.count);
    for (int index = 0; index < typeStrings.count; index++) {
        NSString *t = typeStrings[index];
        _types[index] = [ZHNTypeEncodingTransManager ffiTypeWithType:t];
    }
    // 返回值类型
    NSString *ocRet = [NSString stringWithUTF8String:[signature methodReturnType]];
    ffi_type *retType = [ZHNTypeEncodingTransManager ffiTypeWithType:ocRet];
    
    
    _cif = malloc(sizeof(ffi_cif));;
    ffi_prep_cif(_cif, FFI_DEFAULT_ABI, (int)argTypeCount, retType, _types);
    void *imp = NULL;
    _closure = ffi_closure_alloc(sizeof(ffi_closure), (void **)&imp);
    ffi_prep_closure_loc(_closure, _cif, hookffi_function, (__bridge void *)(self), imp);
    
    // 方法交换
    Method method;
    if (self.isClassMethod) {
        method = class_getClassMethod(self.cls, self.sel);
    }
    else {
        method = class_getInstanceMethod(self.cls, self.sel);
    }
    if (self.isClassMethod) {
        class_replaceMethod(object_getClass(self.cls), self.sel, imp, method_getTypeEncoding(method));
    }
    else {
        class_replaceMethod(self.cls, self.sel, imp, method_getTypeEncoding(method));
    }
}

- (void)dealloc {
    ffi_closure_free(_closure);
    free(_types);
    free(_cif);
}
@end
