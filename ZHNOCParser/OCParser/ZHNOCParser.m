//
//  ZHNOCParser.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/4.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCParser.h"
#import "ZHNOCParseredNodeManager.h"
#import "ZHNOCASTContextManager.h"

#ifndef FLEXINT_H
typedef struct yy_buffer_state *YY_BUFFER_STATE;
void yy_delete_buffer(YY_BUFFER_STATE buf);
YY_BUFFER_STATE  yy_scan_string(const char *s);
int yyparse(void);
#endif

@implementation ZHNOCParser
+ (id)parseText:(NSString *)text {
    ZHNOCParserLock
    YY_BUFFER_STATE buf;
    buf = yy_scan_string([text cStringUsingEncoding:NSUTF8StringEncoding]);
    yyparse();
    yy_delete_buffer(buf);
    
    ZHNOCParseredNodeManager *manager = [ZHNOCParseredNodeManager sharedManager];
    id obj = [manager.rootNode nodePerform];
    manager.rootNode = nil;
    ZHNOCParserUnlock
    return obj;
}

+ (id)parseText:(NSString *)text withContext:(NSDictionary *)context {
    [ZHNASTContext pushLatestContext];
    for (NSString *key in context) {
        id value = [context valueForKey:key];
        [ZHNASTContext assignmentObj:value forKey:key];
    }
    id obj = [self parseText:text];
    [ZHNASTContext popLatestContext];
    return obj;
}

+ (id)performRootNode:(ZHNOCNode *)node {
    [ZHNASTContext pushLatestContext];
    node.isRoot = YES;
    id obj = [node nodePerform];
    [ZHNASTContext popLatestContext];
    return obj;
}
@end
