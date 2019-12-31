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
#import "ZHNOCPatcher.h"
#import <ALView+PureLayout.h>
#import <UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <BlocksKit/UIView+BlocksKit.h>

@interface ViewController ()
@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) NSArray *titleStrs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleStrs = @[@"title -- 0",@"title -- 1",@"title -- 2"];
    
    UIButton *btn = [[UIButton alloc] init];
    [self.view addSubview:btn];
    [btn setTitle:@"加载/刷新下发的OC代码" forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, 50, 250, 30);
    btn.layer.cornerRadius = 10;
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *problemBtn = [[UIButton alloc] init];
    [self.view addSubview:problemBtn];
    [problemBtn setTitle:@"有问题的代码" forState:UIControlStateNormal];
    problemBtn.frame = CGRectMake(10, 100, 250, 30);
    problemBtn.layer.cornerRadius = 10;
    problemBtn.backgroundColor = [UIColor lightGrayColor];
    [problemBtn addTarget:self action:@selector(logAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *patchBtn = [[UIButton alloc] init];
    [self.view addSubview:patchBtn];
    [patchBtn setTitle:@"加载/刷新热修代码" forState:UIControlStateNormal];
    patchBtn.frame = CGRectMake(10, 150, 250, 30);
    patchBtn.layer.cornerRadius = 10;
    patchBtn.backgroundColor = [UIColor lightGrayColor];
    [patchBtn addTarget:self action:@selector(hotPatch) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)reload {
    [self.showView removeFromSuperview];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loadView" ofType:@"text"];
    NSString *ocStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (ocStr) {
        id ret = [ZHNOCParser parseText:ocStr withContext:@{@"self" : self.view}];
        if ([ret isKindOfClass:UIView.class]) {
            [self.showView removeFromSuperview];
            self.showView = ret;
            [self.view addSubview:ret];
        }
    }
    
//    // 起个本地服务器可以动态调试
//    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8080/loadView.text"];
//    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    if (str) {
//        id ret = [ZHNOCParser parseText:str withContext:@{@"self" : self.view}];
//        if ([ret isKindOfClass:UIView.class]) {
//            self.showView = ret;
//            [self.view addSubview:ret];
//        }
//    }
}

- (void)hotPatch {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hotPatch" ofType:@"text"];
    NSString *ocStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (ocStr) {
        [ZHNOCParser parseText:ocStr];
    }
    
//    // 起个本地服务器可以动态d调试
//    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8080/hotPatch.text"];
//    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    if (str) {
//        [ZHNOCParser parseText:str];
//    }
}

- (void)logAction {
    [self logTitleWithIndex:4];
}

- (void)logTitleWithIndex:(NSInteger)index {
    NSString *str = [self.titleStrs objectAtIndex:index];
    [SVProgressHUD showSuccessWithStatus:str];
}

@end
