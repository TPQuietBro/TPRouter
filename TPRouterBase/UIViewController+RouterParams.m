//
//  UIViewController+RouterParams.m
//  TPRouter
//
//  Created by allentang on 2017/8/24.
//  Copyright © 2017年 com.allen. All rights reserved.
//

#import "UIViewController+RouterParams.h"
#import <objc/message.h>

static char *routerParamsKey = "routerParamsKey";
static char *reverseBlockKey = "reverseBlockKey";
static char *tp_remoteURLKey = "tp_remoteURL";



@implementation UIViewController (RouterParams)

- (NSDictionary *)routerParams{
    return objc_getAssociatedObject(self, routerParamsKey);
}

- (void)setRouterParams:(NSDictionary *)routerParams{
    objc_setAssociatedObject(self, routerParamsKey, routerParams, OBJC_ASSOCIATION_RETAIN);
}

- (reverseBlock)callBackBlock{
    return objc_getAssociatedObject(self, reverseBlockKey);
}

- (void)setCallBackBlock:(reverseBlock)callBackBlock{
    objc_setAssociatedObject(self, reverseBlockKey, callBackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

- (NSURL *)tp_remoteURL{
    return objc_getAssociatedObject(self, tp_remoteURLKey);
}

- (void)setTp_remoteURL:(NSURL *)tp_remoteURL{
    objc_setAssociatedObject(self, tp_remoteURLKey, tp_remoteURL, OBJC_ASSOCIATION_RETAIN);
}

@end
