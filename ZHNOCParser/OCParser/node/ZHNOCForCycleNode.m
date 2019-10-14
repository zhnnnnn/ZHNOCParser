//
//  ZHNOCForCycleNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/10/10.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCForCycleNode.h"
#import "ZHNOCASTContextManager.h"
#import "ZHNOCIfElseCondition.h"
#import "ZHNOCReturnNode.h"

@implementation ZHNOCForCycleNode
- (id)nodePerform {
    [ZHNASTContext pushLatestContext];
    [self.defineNode nodePerform];
    while (1) {
        ZHNOCIfElseCondition *success = [self.conditionNode nodePerform];
        if (success.success) {
            id result = [self.assembleNode nodePerform];
            if ([result isKindOfClass:ZHNOCReturnNode.class]) {
                [ZHNASTContext popLatestContext];
                return result;
            }
            [self.operationNode nodePerform];
        }
        else {
            break;
        }
    }
    
    [ZHNASTContext popLatestContext];
    return nil;
}
@end
