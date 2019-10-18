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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] init];
    [self.view addSubview:btn];
    [btn setTitle:@"刷新页面" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 50, 100, 30);
    btn.layer.cornerRadius = 10;
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *patchBtn = [[UIButton alloc] init];
    [self.view addSubview:patchBtn];
    [patchBtn setTitle:@"hotPatch" forState:UIControlStateNormal];
    patchBtn.frame = CGRectMake(0, 100, 100, 30);
    patchBtn.layer.cornerRadius = 10;
    patchBtn.backgroundColor = [UIColor lightGrayColor];
    [patchBtn addTarget:self action:@selector(hotPatch) forControlEvents:UIControlEventTouchUpInside];
}

- (void)reload {
    [self.showView removeFromSuperview];
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8080/loadView.text"];
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (str) {
        id ret = [ZHNOCParser parseText:str withContext:@{@"self" : self.view}];
        if ([ret isKindOfClass:UIView.class]) {
            self.showView = ret;
            [self.view addSubview:ret];
        }
    }
}

- (void)hotPatch {
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8080/hotPatch.text"];
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (str) {
        [ZHNOCParser parseText:str];
        
        [self originalToPatch:@"hotPatch" num:10];
    }
}

- (void)originalToPatch:(NSString *)value num:(int)num {
    NSLog(@"original -- %@",value);
}

@end
