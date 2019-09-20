//
//  ZHNOCNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/12.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCNode.h"

@implementation ZHNOCNode
+ (instancetype)ocnode {
    return [[self alloc] init];
}

- (id)nodePerform {
    return nil;
}

- (void)assignmentObj:(id)obj forKey:(NSString *)key {
    NSMutableDictionary *context = [self.contexts lastObject];
    if (key.length > 0 && obj) {
        [context setObject:obj forKey:key];
    }
}

- (void)updateObj:(id)obj inContextForKey:(NSString *)key {
    if (!obj || key.length == 0) {return;}
    NSInteger count = self.contexts.count;
    for (NSInteger index = 0; index <count; index++) {
        NSInteger fi = (count - 1) - index;
        fi = fi >= 0 ? : 0;
        NSMutableDictionary *currentCtx = self.contexts[fi];
        if ([currentCtx.allKeys containsObject:key]) {
            [currentCtx setObject:obj forKey:key];
            return;
        }
    }
    [self.contexts.lastObject setObject:obj forKey:key];
}

- (id)getObjInContextForKey:(NSString *)key {
    if (key.length == 0) {return nil;}
    NSInteger count = self.contexts.count;
    for (NSInteger index = 0; index <count; index++) {
        NSInteger fi = (count - 1) - index;
        if (fi < 0) {
            fi = 0;
        }
        NSMutableDictionary *currentCtx = self.contexts[fi];
        if ([currentCtx.allKeys containsObject:key]) {
            return [currentCtx objectForKey:key];
        }
    }
    return [self.contexts.lastObject objectForKey:key];
}
@end
