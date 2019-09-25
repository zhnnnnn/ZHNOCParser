//
//  ZHNOCMethodCaller.h
//  ZHNOCParser
//
//  Created by zhn on 2019/9/6.
//  Copyright © 2019 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNOCMethodCaller : NSObject
+ (id)zhn_callMethodWithObj:(id)obj isClass:(BOOL)isClass selector:(SEL)selector params:(NSArray *)params;
@end
