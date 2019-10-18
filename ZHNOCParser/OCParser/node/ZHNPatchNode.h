//
//  ZHNPatchNode.h
//  ZHNOCParser
//
//  Created by zhn on 2019/10/17.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCNode.h"

@class ZHNPatchMethod;

@interface ZHNPatchNode : ZHNOCNode
@property (nonatomic, strong) ZHNPatchMethod *method;
@property (nonatomic, copy) NSString *className;
@end

////////////////
@interface ZHNPatchMethod : NSObject
@property (nonatomic, assign) BOOL isClassMethod;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) ZHNOCNode *assembleNode;
@end

////////////////
@interface ZHNPatchMethodItem : NSObject
@property (nonatomic, copy) NSString *methodName;
@property (nonatomic, copy) NSString *paramName;
@end
