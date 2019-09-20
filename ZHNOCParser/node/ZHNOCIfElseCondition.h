//
//  ZHNOCIfElseCondition.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/17.
//  Copyright © 2019 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNOCIfElseCondition : NSObject
+ (instancetype)instance;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) id value;
@end

NS_ASSUME_NONNULL_END
