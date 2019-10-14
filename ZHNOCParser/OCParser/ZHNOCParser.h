//
//  ZHNOCParser.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/4.
//  Copyright © 2019 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNOCParser : NSObject
+ (id)parseText:(NSString *)text;
+ (id)parseText:(NSString *)text withContext:(NSDictionary *)context;
@end

NS_ASSUME_NONNULL_END
