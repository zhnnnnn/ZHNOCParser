//
//  ZHNOCAssignmentNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/16.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCAssignmentNode.h"
#import "ZHNOCPointerWord.h"

@implementation ZHNOCAssignmentNode
- (id)nodePerform {
    if (self.value && self.name.length > 0) {
        id value = self.value;
        if ([self.value isKindOfClass:ZHNOCPointerWord.class]) {
            NSString *name = [(ZHNOCPointerWord *)self.value name];
            value = [self getObjInContextForKey:name];
        }
        [self assignmentObj:value forKey:self.name];
    }
    return nil;
}
@end
