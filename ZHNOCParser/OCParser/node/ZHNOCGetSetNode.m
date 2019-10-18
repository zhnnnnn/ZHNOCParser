//
//  ZHNOCGetSetNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/25.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCGetSetNode.h"
#import "ZHNOCASTContextManager.h"
#import "ZHNOCMethodCaller.h"
#import "ZHNOCIfElseCondition.h"

@implementation ZHNOCGetSetNode
- (id)nodePerform {
    __block id obj = nil;
    [self.names enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            obj = [ZHNASTContext getObjInLatestContextForKey:name];
        }else if (idx == self.names.count - 1 && self.names.count > 1) {
            if (self.type == ZHNOCGetSetNodeType_get) {
                SEL sel = NSSelectorFromString([self getSelectorNameForPropertyName:name]);
                if (!obj) {
                    obj = NSClassFromString(self.names.firstObject);
                }
                obj = [ZHNOCMethodCaller zhn_callMethodWithObj:obj isClass:NO selector:sel params:nil];
            }
            else {
                id param = self.value;
                if ([self.value isKindOfClass:ZHNOCNode.class]) {
                    param = [(ZHNOCNode *)self.value nodePerform];
                }
                if ([self.value isKindOfClass:ZHNOCIfElseCondition.class]) {
                    param = [(ZHNOCIfElseCondition *)self.value value];
                }
                NSMutableArray *params = [NSMutableArray array];
                if (param) {
                    [params addObject:param];
                }
                SEL sel = NSSelectorFromString([self setSelectorNameForPropertyName:name]);
                [ZHNOCMethodCaller zhn_callMethodWithObj:obj isClass:NO selector:sel params:params];
            }
        }
        else {
            SEL sel = NSSelectorFromString([self getSelectorNameForPropertyName:name]);
            obj = [ZHNOCMethodCaller zhn_callMethodWithObj:obj isClass:NO selector:sel params:nil];
        }
    }];
    return obj;
}

- (NSString *)getSelectorNameForPropertyName:(NSString *)name {
    return name;
}

- (NSString *)setSelectorNameForPropertyName:(NSString *)name {
    NSString *newName = [self firstCharUppercase:name];
    return [NSString stringWithFormat:@"set%@:",newName];
}

- (NSString *)firstCharUppercase:(NSString *)str {
    NSString *fStr = [str substringToIndex:1];
    NSString *lStr = [str substringFromIndex:1];
    NSString *upFStr = [fStr uppercaseString];
    return [NSString stringWithFormat:@"%@%@",upFStr,lStr];
}

#pragma mark - getters
- (NSMutableArray *)names {
    if (_names == nil) {
        _names = [NSMutableArray array];
    }
    return _names;
}
@end
