//
//  ZHNOCEnumInitManager.m
//  ZHNOCParser
//
//  Created by zhn on 2019/10/18.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCEnumInitManager.h"

@implementation ZHNOCEnumInitManager
+ (void)initOCEnumForContext:(NSDictionary *)context {
    [context setValue:@(1) forKey:@"ALEdgeLeft"];
    [context setValue:@(2) forKey:@"ALEdgeRight"];
    [context setValue:@(3) forKey:@"ALEdgeTop"];
    [context setValue:@(4) forKey:@"ALEdgeBottom"];
    [context setValue:@(5) forKey:@"ALEdgeLeading"];
    [context setValue:@(6) forKey:@"ALEdgeTrailing"];
    [context setValue:@(7) forKey:@"ALDimensionWidth"];
    [context setValue:@(8) forKey:@"ALDimensionHeight"];
    [context setValue:@(9) forKey:@"ALAxisVertical"];
    [context setValue:@(10) forKey:@"ALAxisHorizontal"];
    [context setValue:@(11) forKey:@"ALAxisBaseline"];
    [context setValue:@(12) forKey:@"ALAxisLastBaseline"];
    [context setValue:@(13) forKey:@"ALAxisFirstBaseline"];
    
    [context setValue:@(0) forKey:@"UIControlStateNormal"];
    [context setValue:@(1) forKey:@"UIControlStateHighlighted"];
    [context setValue:@(2) forKey:@"UIControlStateDisabled"];
    [context setValue:@(4) forKey:@"UIControlStateSelected"];
    
    // TODO 一些基础enum初始化
}
@end
