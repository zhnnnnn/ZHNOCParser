//
//  ZHNOCBlockNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/10/8.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCNode.h"
#import "ZHNOCAssembleNode.h"

@class ZHNOCBlockParam;
@interface ZHNOCBlockNode : ZHNOCNode
- (void)addBlockParams:(NSArray *)params;
@property (nonatomic, strong) ZHNOCAssembleNode *assembleNode;
@property (nonatomic, copy) NSString *returnType;// char int ...
@end


/////////////////////
@interface ZHNOCBlockParam : NSObject
@property (nonatomic, copy) NSString *typeName;// char int ...
@property (nonatomic, copy) NSString *name;
@end

