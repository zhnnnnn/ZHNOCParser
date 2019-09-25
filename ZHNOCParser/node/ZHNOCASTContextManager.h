//
//  ZHNOCASTContextManager.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/24.
//  Copyright © 2019 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ZHNASTContext [ZHNOCASTContextManager sharedInstance]

@interface ZHNOCASTContextManager : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSMutableArray *contexts;

- (void)pushLatestContext;
- (void)popLatestContext;

- (void)assignmentObj:(id)obj forKey:(NSString *)key;
- (void)updateObj:(id)obj inLatestContextForKey:(NSString *)key;
- (id)getObjInLatestContextForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
