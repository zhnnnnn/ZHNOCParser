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

#import "ZHNOCMethodCaller.h"
#import "ZHNOCBlockNode.h"

@interface ViewController ()
@property (nonatomic, copy) NSString *testName;
@property (nonatomic, assign) int testNum;

@property (nonatomic, strong) ZHNOCBlockNode *blockNode;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [ZHNOCParser parseText:@"if ((1==1 || 2 == 1) && 1==1) {[ViewController test:@\"1\"];}"];
//    [ZHNOCPararseText:@"[[ViewController vc] instanceMethod];"];
    
//    ViewController *vc = [ZHNOCParser parseText:@"ViewController *vc = [[ViewController alloc] init]; vc.testName = @\"123\"; vc.testNum = 10; if (vc.testNum <= 10) {return vc;}"];
//    NSLog(@"🔥🔥%@",vc.testName);
    
//    [ZHNOCParser parseText:@"a123456781.aoiioooopppppppppppppppp;"];
    
//    UIView *view = [ZHNOCParser parseText:@"UIView *view = [[UIView alloc] init];view.backgroundColor = [UIColor redColor];view.frame = host.frame;view.layer.cornerRadius = 100;return view;" withContext:@{@"host":self.view}];
//    [self.view addSubview:view];
    
    
//    [ZHNOCParser parseText:@"[ViewController testPoint:CGPointMake(1, 1)];"];
    
//    [ZHNOCParser parseText:@"[ViewController testRect:CGRectMake(2, 10, 1, 1)];"];
    
    
//    ZHNOCBlockNode *node = [[ZHNOCBlockNode alloc] init];
//    self.blockNode = node;
//    [ZHNOCMethodCaller zhn_callMethodWithObj:ViewController.class isClass:YES selector:@selector(blockTest:) params:@[[node blockPtr]]];
//
//    [ViewController blockTest2:^NSString *(NSString *str) {
//        return @"1";
//    }];
    
    
    [ZHNOCParser parseText:@"[ViewController blockTest2:^CGFloat(NSString *name) {NSString *temp = [name stringByAppendingString:@\"end\"];return 100.12;}];"];
}

+ (void)haveNiceTime {
    NSLog(@"haveNiceTime");
}

+ (void)blockTest2:(CGFloat(^)(NSString *))block {
    CGFloat value = block(@"lol222");
    NSLog(@"end");
}

+ (void)blockTest:(void(^)(NSString *))block {
    block(@"lol222");
    NSLog(@"end");
}

+ (void)test:(NSString *)str {
    NSLog(@"test ---- ");
}

+ (void)testPoint:(CGPoint)point {
    NSLog(@"a -- %f",point.x);
}

+ (void)testRect:(CGRect)rect {
    NSLog(@"rect -- %f",rect.origin.y);
}

@end
