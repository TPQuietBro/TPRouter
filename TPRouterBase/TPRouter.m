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
#pragma mark - class methods

+ (instancetype)tp_routerManager{
    static TPRouter *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)pushViewControllerWithNativeURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes{
    [self pushViewControllerWithURL:URL andParam:param andAnimated:YES];
}

+ (void)pushViewControllerWithRemoteURL:(NSString *)URL animated:(BOOL)Yes{
    [self pushViewControllerWithURL:URL andParam:nil andAnimated:YES];
}

+ (void)pushViewControllerWithURL:(NSString *)URL andParam:(NSDictionary *)param andAnimated:(BOOL)Yes{
    UIViewController *controller = (UIViewController *)[[TPRouterConfig tp_routerConfigManager] controllerWithURL:URL];
    [RootViewController pushViewController:controller animated:Yes];
}

#pragma mark - instance methods

- (void)pushViewControllerWithNativeURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes{
    [self pushViewControllerWithURL:URL andParam:param andAnimated:YES];
}

- (void)pushViewControllerWithRemoteURL:(NSString *)URL animated:(BOOL)Yes{
    [self pushViewControllerWithURL:URL andParam:nil andAnimated:YES];
}

- (void)pushViewControllerWithURL:(NSString *)URL andParam:(NSDictionary *)param andAnimated:(BOOL)Yes{
    UIViewController *controller = (UIViewController *)[[TPRouterConfig tp_routerConfigManager] controllerWithURL:URL];
    
    [RootViewController pushViewController:controller animated:Yes];
}

@end
