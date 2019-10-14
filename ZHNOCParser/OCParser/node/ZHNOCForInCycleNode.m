//
//  ZHNOCForInCycleNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/10/11.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCForInCycleNode.h"
#import "ZHNOCASTContextManager.h"
#import "ZHNOCReturnNode.h"

@implementation ZHNOCForInCycleNode
- (id)nodePerform {
    [ZHNASTContext pushLatestContext];
    id value = [self.valuesNode nodePerform];
    if ([value isKindOfClass:NSArray.class]) {
        for (id obj in (NSArray *)value) {
            [ZHNASTContext updateObj:obj inLatestContextForKey:self.name];
            id ret = [self.assembleNode nodePerform];
            if ([ret isKindOfClass:ZHNOCReturnNode.class]) {
                [ZHNASTContext popLatestContext];
                return ret;
            }
        }
    }
    return nil;
}
@end
