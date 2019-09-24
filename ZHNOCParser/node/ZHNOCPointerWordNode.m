//
//  ZHNOCPointerWordNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/24.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCPointerWordNode.h"
#import "ZHNOCASTContextManager.h"

@implementation ZHNOCPointerWordNode
- (id)nodePerform {
    return [ZHNASTContext getObjInLatestContextForKey:self.name];
}
@end
