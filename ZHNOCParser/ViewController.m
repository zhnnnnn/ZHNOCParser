//
//  ViewController.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/4.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ViewController.h"
#import "ZHNOCParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [ViewController test:@"a\\n"];
//    [ZHNOCParser parseText:@"[ViewController wtf:[ViewController test:@\"hello\"]]"];
//    [ZHNOCParser parseText:@"[ViewController test:@\"hello\"]"];
//    [ZHNOCParser parseText:@"[ViewController wtf:YES];"];
//    [ZHNOCParser parseText:@"[ViewController floatValue:1.2];"];
//    [ZHNOCParser parseText:@"[ViewController wtf:YES value2:3];"];
//    [ZHNOCParser parseText:@"if (1>1) {[ViewController test:@\"1\"];} else if (1>1) {[ViewController test:@\"2\"];} else if (1>1) {[ViewController test:@\"3\"];} else {[ViewController test:@\"4\"];}"];
    
    [ZHNOCParser parseText:@"if (1 == YES && 1 == 1) {[ViewController test:@\"1\"];}"];
}

+ (void)test {
    NSLog(@"test");
}

+ (int)test:(NSString *)value {
    NSLog(@"value -- %@",value);
    return 10;
}

+ (void)wtf:(int)value value2:(int)value2 {
    NSLog(@"value1 -- %d value2 --- %d",value,value2);
}

+ (void)floatValue:(CGFloat)value {
    NSLog(@"value -- %f",value);
}


@end
