//
//  UIViewController+RouterParams.h
//  TPRouter
//
//  Created by allentang on 2017/8/24.
//  Copyright © 2017年 com.allen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^reverseBlock)(id reverseValue);

@interface UIViewController (RouterParams)
@property (nonatomic,strong) NSDictionary *routerParams;
@property (nonatomic,strong) reverseBlock callBackBlock;
@property (nonatomic,strong) NSURL *tp_remoteURL;
@end
