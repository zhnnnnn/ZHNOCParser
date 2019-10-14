//
//  ZHNOCParseredNodeManager.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/26.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCParseredNodeManager.h"

@implementation ZHNOCParseredNodeManager
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static ZHNOCParseredNodeManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[ZHNOCParseredNodeManager alloc] init];
        manager.lock = [[NSLock alloc] init];
    });
    return manager;
}
@end
