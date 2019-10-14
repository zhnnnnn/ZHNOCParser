//
//  ZHNOCASTContextManager.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/24.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCASTContextManager.h"

@implementation ZHNOCASTContextManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ZHNOCASTContextManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[ZHNOCASTContextManager alloc] init];
    });
    return manager;
}

- (void)pushLatestContext {
    [self.contexts addObject:[NSMutableDictionary dictionary]];
}

- (void)popLatestContext {
    [self.contexts removeLastObject];
}

- (void)assignmentObj:(id)obj forKey:(NSString *)key {
    NSMutableDictionary *context = [self.contexts lastObject];
    if (key.length > 0 && obj) {
        [context setObject:obj forKey:key];
    }
}

- (void)updateObj:(id)obj inLatestContextForKey:(NSString *)key {
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

- (id)getObjInLatestContextForKey:(NSString *)key {
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

- (NSMutableArray *)contexts {
    if (_contexts == nil) {
        _contexts = [NSMutableArray array];
    }
    return _contexts;
}
@end
