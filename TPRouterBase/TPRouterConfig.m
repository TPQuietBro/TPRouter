//
//  TPRouterConfig.m
//  TPRouter
//
//  Created by 魏信洋 on 2017/8/23.
//  Copyright © 2017年 com.allen. All rights reserved.
//

#import "TPRouterConfig.h"

NSString *const plistName = @"TPRouterConfig";
NSString *const WebViewControllerName = @"WebViewControllerName";
NSString *const NormalViewControllerName = @"NormalViewControllerName";


@implementation TPRouterConfig
+ (instancetype)tp_routerConfigManager{
    static TPRouterConfig *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (UIViewController *)controllerWithURL:(NSString *)URL{
    UIViewController *controller = (UIViewController *)[[NSClassFromString([self controllerNameWithURL:URL]) alloc] init];
    if (!controller) {
        NSException *exception = [NSException exceptionWithName:@"no such UIViewController" reason:@"UIViewController not exist" userInfo:nil];
        @throw exception;
    }
    return controller;
}

- (NSString *)controllerNameWithURL:(NSString *)URL{
    NSDictionary *nameDict = [NSDictionary dictionaryWithContentsOfFile:[self configPath]];
    NSString *controllerName = nil;
    if ([URL hasPrefix:@"https"] || [URL hasPrefix:@"http"]) {
        controllerName = nameDict[WebViewControllerName][URL];
    }else {
        controllerName = nameDict[NormalViewControllerName][URL];
    }
    if (!controllerName) {
        NSException *exception = [NSException exceptionWithName:@"null controller name" reason:@"the controller name is not right" userInfo:nil];
        @throw exception;
    }
    return controllerName;
}

- (NSString *)configPath{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    return path;
}

- (void)setRootNavigationController:(UINavigationController *)rootNavigationController{
    if (![rootNavigationController isKindOfClass:[UINavigationController class]]) {
        NSException *exception = [NSException exceptionWithName:@"no such UINavigationController" reason:@"the type is not UINavigationController" userInfo:nil];
        @throw exception;
    }
    _rootNavigationController = rootNavigationController;
}

- (UINavigationController *)rootViewController{
    if (_rootNavigationController) {
        return _rootNavigationController;
    }
    UINavigationController *root = (UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    return root;
}



@end
