//
//  TPRouterConfig.h
//  TPRouter
//
//  Created by 魏信洋 on 2017/8/23.
//  Copyright © 2017年 com.allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPRouterConfig : NSObject

/**
 *  用户可以自定义根的UINavigationController
 */
@property (nonatomic, strong) UINavigationController *rootNavigationController;

+ (instancetype)tp_routerConfigManager;

- (UIViewController *)controllerWithURL:(NSString *)URL;

- (UINavigationController *)rootViewController;

@end
