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
NSString *const tprouterScheme = @"tprouterScheme";

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
    id root = [[UIApplication sharedApplication].delegate window].rootViewController;
    //如果是navigationController
    if ([root isKindOfClass:[UINavigationController class]]) {
        return root;
    }else if ([root isKindOfClass:[UITabBarController class]]){
        //如果是tabbarVc
        UITabBarController *rootVc = root;
        UINavigationController *nav = [[UINavigationController alloc] init];
        if (rootVc.childViewControllers.count > 0) {
            nav = rootVc.childViewControllers.firstObject;
        }
        return nav;
    }else{
        //如果根控制器是个UIViewController
        UIViewController *rootVc = root;
        UITabBarController *subTabVc = [[UITabBarController alloc] init];
        UINavigationController *rootNav = nil;
        for (id subVc in rootVc.childViewControllers) {
            if ([subVc isKindOfClass:[UITabBarController class]]) {
                subTabVc = subVc;
                if (subTabVc.childViewControllers.count > 0) {
                    rootNav = subTabVc.childViewControllers.firstObject;
                }
                break;
            }
        }
        rootNav ? NSLog(@"找到根控制器") : NSLog(@"没有找到根控制器");
        return rootNav ? rootNav : [[UINavigationController alloc] init];
    }
}

- (void)configSchemeWithScheme:(NSString *)scheme{
    [[NSUserDefaults standardUserDefaults] setObject:scheme forKey:tprouterScheme];
}

- (NSString *)hasScheme{
    return [[NSUserDefaults standardUserDefaults] objectForKey:tprouterScheme];
}


@end
