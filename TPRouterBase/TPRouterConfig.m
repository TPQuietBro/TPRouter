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

    NSString *controllerName = [self controllerNameWithURL:URL];
    UIViewController *controller = (UIViewController *)[[NSClassFromString(controllerName) alloc] init];
    if (!controller) {
#ifdef debug
        NSException *exception = [NSException exceptionWithName:@"no such UIViewController" reason:@"UIViewController not exist" userInfo:nil];
        @throw exception;
#else
        NSLog(@"no such UIViewController");
        return [UIViewController new];
#endif
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
#ifdef debug
        NSException *exception = [NSException exceptionWithName:@"null controller name" reason:@"the controller name is not right" userInfo:nil];
        @throw exception;
#else
        NSLog(@"null controller name");
#endif
    }
    return controllerName;
}

- (NSString *)configPath{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    return path;
}

- (void)setRootNavigationController:(UINavigationController *)rootNavigationController{
    if (![rootNavigationController isKindOfClass:[UINavigationController class]]) {
#ifdef debug
        NSException *exception = [NSException exceptionWithName:@"no such UINavigationController" reason:@"the type is not UINavigationController" userInfo:nil];
        @throw exception;
#else
        NSLog(@"no such UINavigationController");
        _rootNavigationController = [UINavigationController new];
        return;
#endif
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
        UINavigationController *nav = nil;
        if (rootVc.childViewControllers.count > 0) {
            nav = rootVc.childViewControllers.firstObject;
        }
        return nav ? nav : [[UINavigationController alloc] init];
    }else{
        //如果根控制器是个UIViewController
        UIViewController *rootVc = root;
        
        UITabBarController *subTabVc = [[UITabBarController alloc] init];
        UINavigationController *rootNav = nil;
        for (id subVc in rootVc.childViewControllers) {
            //如果有一个子控制器是tabbarvc
            if ([subVc isKindOfClass:[UITabBarController class]]) {
                subTabVc = subVc;
                //并且里面有UINavigationController为子控制器
                if (subTabVc.childViewControllers.count > 0) {
                    rootNav = subTabVc.childViewControllers[subTabVc.selectedIndex];
                }
                break;
            }
        }
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
