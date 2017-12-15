//
//  ViewController.m
//  TPRouter
//
//  Created by 魏信洋 on 2017/8/23.
//  Copyright © 2017年 com.allen. All rights reserved.
//

#import "ViewController.h"
#import "TPRouter.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [TPRouter pushViewControllerWithNativeURL:@"tprouter://home?name=allen" withParams:@{@"age" : @"27"} animated:YES];
    
//    [TPRouter pushViewControllerWithRemoteURL:@"https://www.baidu.com" animated:YES];
    
//    //指定根的控制器
//    UINavigationController *root = (UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
//    [TPRouterConfig tp_routerConfigManager].rootNavigationController = root;
//    //指定根的控制器必须使用对象方法
//    [[TPRouter tp_routerManager] pushViewControllerWithNativeURL:@"tprouter://home?name=allen&password=123" withParams:nil animated:YES];
//    
//    [TPRouter pushViewControllerWithNativeURL:@"tprouter://home" withParams:@{@"name":@"唐鹏"} animated:YES withBlock:^(id reverseValue) {
//        NSLog(@"回调的值%@",reverseValue);
//    }];
    
}



@end
