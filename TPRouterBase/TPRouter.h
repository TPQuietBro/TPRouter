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

/**
 *  用户可以自定义根的UINavigationController
 */
@property (nonatomic, strong) UINavigationController *rootNavigationController;

+ (instancetype)tp_routerManager;


/**
 默认根控制器

 @param URL 跳转协议
 @param param 参数
 @param Yes 是否动画
 */
+ (void)pushViewControllerWithURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes;

/**
 用户指定的跳转根控制器

 @param URL 跳转协议
 @param param 参数
 @param Yes 是否动画
 */
- (void)pushViewControllerWithURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes;

@end
