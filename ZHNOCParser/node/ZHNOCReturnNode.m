//
//  ZHNOCReturnNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/26.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCReturnNode.h"

@implementation ZHNOCReturnNode
- (id)nodePerform {
    id ret = self.value;
    if ([self.value isKindOfClass:ZHNOCNode.class]) {
        ret = [(ZHNOCNode *)self.value nodePerform];
    }
    return ret;
}
@end
