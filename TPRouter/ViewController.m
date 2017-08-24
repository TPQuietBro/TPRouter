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
    
    NSURL *url = [NSURL URLWithString:@"ening://home?name=allen&password=123"];
    
    NSLog(@"%@ %@ %@",url.query,url.scheme,url.host);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [TPRouter pushViewControllerWithNativeURL:@"tprouter://home" withParams:nil animated:YES];
//    [TPRouter pushViewControllerWithRemoteURL:@"tprouter://home?name=allen&password=123" animated:YES];
    
//    //指定根的控制器
//    UINavigationController *root = (UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
//    [TPRouterConfig tp_routerConfigManager].rootNavigationController = root;
//    //指定根的控制器必须使用对象方法
//    [[TPRouter tp_routerManager] pushViewControllerWithNativeURL:@"tprouter://home?name=allen&password=123" withParams:nil animated:YES];
    
    [TPRouter pushViewControllerWithNativeURL:@"tprouter://home" withParams:nil animated:YES withBlock:^(id reverseValue) {
        NSLog(@"回调的值%@",reverseValue);
    }];
    
}



@end
