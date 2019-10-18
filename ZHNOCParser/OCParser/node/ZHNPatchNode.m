//
//  ZHNPatchNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/10/17.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNPatchNode.h"
#import "ZHNOCPatcher.h"

@implementation ZHNPatchNode
- (id)nodePerform {
    Class hookedCls = NSClassFromString(self.className);
    NSMutableArray *paramNames = [NSMutableArray array];
    NSString *methodName = @"";
    
    ZHNPatchMethodItem *item = [self.method.items firstObject];
    if (self.method.items.count == 1 && !item.paramName) {
        // 不带参数的情况
        methodName = item.methodName;
    }
    else {
        for (ZHNPatchMethodItem *item in self.method.items) {
            [paramNames addObject:item.paramName];
            if (item.paramName) {
                methodName = [NSString stringWithFormat:@"%@%@:",methodName,item.methodName];
            }
        }
    }
    SEL sel = NSSelectorFromString(methodName);
    
    ZHNOCPatchItem *patchItem = [[ZHNOCPatcher sharedInstance] zhn_patchClass:hookedCls selector:sel isClassMethod:self.method.isClassMethod node:self.method.assembleNode];
    patchItem.paramNames = paramNames;
    
    return nil;
}
@end

////////////////
@implementation ZHNPatchMethod
@end

////////////////
@implementation ZHNPatchMethodItem
@end
