//
//  ViewController.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/4.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ViewController.h"
#import "ZHNOCParser.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (nonatomic, copy) NSString *testName;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [ZHNOCParser parseText:@"if ((1==1 || 2 == 1) && 1==1) {[ViewController test:@\"1\"];}"];
//    [ZHNOCPararseText:@"[[ViewController vc] instanceMethod];"];
    
    [ZHNOCParser parseText:@"ViewController *vc = [[ViewController alloc] init]; vc.testName = @\"123\"; [vc log:vc.testName];"];
    
//    [ZHNOCParser parseText:@"self.wtf.lalala;"];
}

- (instancetype)initTemp {
    if (self = [super init]) {
        NSLog(@"wtfff");
    }
    return self;
}

+ (ViewController *)instance {
    return [[ViewController alloc] init];
}

- (void)log:(NSString *)str {
    NSLog(@"log ----- %@",str);
}

//+ (id)temp {
//    return nil;
//}
//
+ (void)test:(int)i {
    NSLog(@"test");
}

@end
