//
//  AppDelegate.m
//  TPRouter
//
//  Created by 魏信洋 on 2017/8/23.
//  Copyright © 2017年 com.allen. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TPRouter.h"
#import "SubVc_1.h"
#import "SubVc_2.h"
#import "TestSuperVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UITabBarController *vc = [[UITabBarController alloc] init];
    
    SubVc_1 *vc1 = [[SubVc_1 alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    SubVc_2 *vc2 = [[SubVc_2 alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    [vc addChildViewController:nav1];
    [vc addChildViewController:nav2];
    
//    TestSuperVC *superVc = [[TestSuperVC alloc] init];
//    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:superVc];
//
//    [superVc addChildViewController:vc];
    
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    
    [[TPRouterConfig tp_routerConfigManager] configSchemeWithScheme:@"tprouter"];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
