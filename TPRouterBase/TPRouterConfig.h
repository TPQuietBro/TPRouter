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
/**
 配置协议头
 
 @param scheme 协议头
 */
- (void)configSchemeWithScheme:(NSString *)scheme;

/**
 返回映射的控制器

 @param URL 传入的url
 @return 控制器
 */
- (UIViewController *)controllerWithURL:(NSString *)URL;

/**
 跳转的根控制器

 @return 根控制器
 */
- (UINavigationController *)rootViewController;

/**
 协议头

 @return 协议头
 */
- (NSString *)hasScheme;
@end
