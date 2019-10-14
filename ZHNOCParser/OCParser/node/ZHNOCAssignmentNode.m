//
//  ZHNOCAssignmentNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/16.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCAssignmentNode.h"
#import "ZHNOCASTContextManager.h"

@implementation ZHNOCAssignmentNode
- (id)nodePerform {
    if (self.value && self.name.length > 0) {
        id obj = self.value;        
        if ([self.value isKindOfClass:ZHNOCNode.class]) {
            obj = [self.value nodePerform];
        }
        [ZHNASTContext assignmentObj:obj forKey:self.name];
    }
    return nil;
}
@end
