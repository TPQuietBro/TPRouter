//
//  TPRouter.m
//  TPRouter
//
//  Created by 魏信洋 on 2017/8/23.
//  Copyright © 2017年 com.allen. All rights reserved.
//

#import "TPRouter.h"

#define RootViewController [[TPRouterConfig tp_routerConfigManager] rootViewController]

@implementation TPRouter

+ (instancetype)tp_routerManager{
    static TPRouter *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)pushViewControllerWithURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes{
    UIViewController *controller = (UIViewController *)[[TPRouterConfig tp_routerConfigManager] controllerWithURL:URL];
    
    [RootViewController pushViewController:controller animated:Yes];
}

- (void)setRootNavigationController:(UINavigationController *)rootNavigationController{
    if (![rootNavigationController isKindOfClass:[UINavigationController class]]) {
        NSException *exception = [NSException exceptionWithName:@"no such UINavigationController" reason:@"the type is not UINavigationController" userInfo:nil];
        @throw exception;
    }
    _rootNavigationController = rootNavigationController;
}

- (void)pushViewControllerWithURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes{
    UIViewController *controller = (UIViewController *)[[TPRouterConfig tp_routerConfigManager] controllerWithURL:URL];
    
    [RootViewController pushViewController:controller animated:Yes];
}

- (UINavigationController *)rootViewController{
    if (_rootNavigationController) {
        return _rootNavigationController;
    }
    return RootViewController;
}

@end
