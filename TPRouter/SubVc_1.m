//
//  SubVc_1.m
//  TPRouter
//
//  Created by allentang on 2017/12/15.
//  Copyright © 2017年 com.allen. All rights reserved.
//

#import "SubVc_1.h"
#import "TPRouter.h"
@implementation SubVc_1

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"控制器1";
    self.view.backgroundColor = [UIColor redColor];
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
