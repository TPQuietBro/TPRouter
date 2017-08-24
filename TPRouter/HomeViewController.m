//
//  HomeViewController.m
//  TPRouter
//
//  Created by 魏信洋 on 2017/8/23.
//  Copyright © 2017年 com.allen. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+RouterParams.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"主页";
    NSLog(@"传入的参数是%@,传入的url是:%@",self.routerParams,self.tp_remoteURL);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.callBackBlock) {
        self.callBackBlock(@"回调成功");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
