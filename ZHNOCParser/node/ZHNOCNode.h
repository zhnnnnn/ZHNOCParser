//
//  ZHNOCNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/12.
//  Copyright © 2019 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNOCNode : NSObject
+ (instancetype)ocnode;
- (id)nodePerform;

@property (nonatomic, strong) NSArray *contexts;
// 初始化一个对象
- (void)assignmentObj:(id)obj forKey:(NSString *)key;
// 更新对象值
- (void)updateObj:(id)obj inContextForKey:(NSString *)key;
// 获取上下文里的对象值
- (id)getObjInContextForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
