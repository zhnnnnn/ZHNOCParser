//
//  ZHNOCParser.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/4.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNOCParser.h"
#import "ZHNOCParseredNodeManager.h"

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
@end
