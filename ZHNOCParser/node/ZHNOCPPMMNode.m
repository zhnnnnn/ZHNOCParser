//
//  ZHNOCPPMMNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/10/10.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCPPMMNode.h"
#import "ZHNOCASTContextManager.h"

@implementation ZHNOCPPMMNode
- (id)nodePerform {
    id value = [ZHNASTContext getObjInLatestContextForKey:self.name];
    if ([value isKindOfClass:NSNumber.class]) {
        NSInteger iValue = [value integerValue];
        switch (self.type) {
            case ZHNOCPPMMType_plusplus:
                iValue = iValue + 1;
                [ZHNASTContext updateObj:[NSNumber numberWithInteger:iValue] inLatestContextForKey:self.name];
                break;
            case ZHNOCPPMMType_minusminus:
                iValue = iValue - 1;
                [ZHNASTContext updateObj:[NSNumber numberWithInteger:iValue] inLatestContextForKey:self.name];
                break;
        }
    }
    return nil;
}
@end
