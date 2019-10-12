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
@property (nonatomic, strong) UIView *showView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] init];
    [self.view addSubview:btn];
    [btn setTitle:@"刷新页面" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 20, 100, 30);
    btn.layer.cornerRadius = 10;
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
}

- (void)reload {
    [self.showView removeFromSuperview];
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8080/1.text"];
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (str) {
        id ret = [ZHNOCParser parseText:str];
        if ([ret isKindOfClass:UIView.class]) {
            self.showView = ret;
            [self.view addSubview:ret];
        }
    }
}

@end
