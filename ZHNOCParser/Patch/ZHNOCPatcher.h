//
//  ZHNOCPatcher.h
//  ZHNOCParser
//
//  Created by zhn on 2019/10/15.
//  Copyright © 2019 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNOCNode.h"

@class ZHNOCPatchItem;
@interface ZHNOCPatcher : NSObject
+ (instancetype)sharedInstance;
- (ZHNOCPatchItem *)zhn_patchClass:(Class)cls selector:(SEL)sel isClassMethod:(BOOL)isClassMethod blockString:(NSString *)blockString;
- (ZHNOCPatchItem *)zhn_patchClass:(Class)cls selector:(SEL)sel isClassMethod:(BOOL)isClassMethod node:(ZHNOCNode *)node;

// TODO remove patch
@end

////////////////////
@interface ZHNOCPatchItem : NSObject
@property (nonatomic) Class cls;
@property (nonatomic) SEL sel;
@property (nonatomic, assign) BOOL isClassMethod;
@property (nonatomic, copy) NSString *blockString;
@property (nonatomic, strong) ZHNOCNode *node;
@property (nonatomic, strong) NSArray *typeStrings;
@property (nonatomic, strong) NSArray *paramNames;

+ (instancetype)instancePatchItemWithClass:(Class)cls selector:(SEL)sel isClassMethod:(BOOL)isClassMethod blockString:(NSString *)blockString;
+ (instancetype)instancePatchItemWithClass:(Class)cls selector:(SEL)sel isClassMethod:(BOOL)isClassMethod node:(ZHNOCNode *)node;
- (void)patch;
@end
