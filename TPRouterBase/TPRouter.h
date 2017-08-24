//
//  TPRouter.h
//  TPRouter
//
//  Created by 魏信洋 on 2017/8/23.
//  Copyright © 2017年 com.allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPRouterConfig.h"

@interface TPRouter : NSObject



+ (instancetype)tp_routerManager;


/**
 默认根控制器,跳转本地URL

 @param URL 跳转协议
 @param param 参数
 @param Yes 是否动画
 */
+ (void)pushViewControllerWithNativeURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes;

/**
 跳转外部URL

 @param URL 跳转协议
 @param Yes 是否动画
 */
+ (void)pushViewControllerWithRemoteURL:(NSString *)URL animated:(BOOL)Yes;

/**
 用户指定的跳转根控制器,本地URL

 @param URL 跳转协议
 @param param 参数
 @param Yes 是否动画
 */
- (void)pushViewControllerWithNativeURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes;
/**
 跳转外部URL
 
 @param URL 跳转协议
 @param Yes 是否动画
 */
- (void)pushViewControllerWithRemoteURL:(NSString *)URL animated:(BOOL)Yes;

@end
