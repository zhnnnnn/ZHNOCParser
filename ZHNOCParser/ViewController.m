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
    
//    [ZHNOCParser parseText:@"if (!NO) {[ViewController test:@\"1\"];}"];
//    [ZHNOCPararseText:@"[[ViewController vc] instanceMethod];"];
    
    [ZHNOCParser parseText:@"NSString *temp = @\"123\"; ViewController *vc = [[ViewController alloc] init]; [vc log:temp];"];
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
//+ (void)test:(int)i {
//    NSLog(@"test");
//}

@end
