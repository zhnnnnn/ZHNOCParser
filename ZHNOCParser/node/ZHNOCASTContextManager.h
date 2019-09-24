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

// 初始化一个对象
- (void)assignmentObj:(id)obj forKey:(NSString *)key;
// 更新对象值
- (void)updateObj:(id)obj inLatestContextForKey:(NSString *)key;
// 获取上下文里的对象值
- (id)getObjInLatestContextForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
