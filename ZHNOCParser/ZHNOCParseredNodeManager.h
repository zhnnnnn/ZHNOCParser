//
//  ZHNOCParseredNodeManager.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/26.
//  Copyright © 2019 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNOCNode.h"

#define ZHNOCParserLock [[ZHNOCParseredNodeManager sharedManager].lock lock];
#define ZHNOCParserUnlock [[ZHNOCParseredNodeManager sharedManager].lock unlock];

@interface ZHNOCParseredNodeManager : NSObject
+ (instancetype)sharedManager;
@property (nonatomic, strong) ZHNOCNode *rootNode;
@property (nonatomic, strong) NSLock *lock;
@end

