//
//  ZHNOCReturnNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/26.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCReturnNode.h"
#import "ZHNOCStructNode.h"

@implementation ZHNOCReturnNode
- (id)nodePerform {
    id ret = self.value;
    if ([self.value isKindOfClass:ZHNOCNode.class]) {
        ret = [(ZHNOCNode *)self.value nodePerform];
    }
    if ([ret isKindOfClass:ZHNOCStruct.class]) {
        return [(ZHNOCStruct *)ret value];
    }
    return ret;
}
@end
