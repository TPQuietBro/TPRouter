//
//  TPRouter.m
//  TPRouter
//
//  Created by 魏信洋 on 2017/8/23.
//  Copyright © 2017年 com.allen. All rights reserved.
//

#import "TPRouter.h"

#define RootViewController [[TPRouterConfig tp_routerConfigManager] rootViewController]

#define tprouterConfig [TPRouterConfig tp_routerConfigManager]

@implementation TPRouter
#pragma mark - class methods

+ (instancetype)tp_routerManager{
    static TPRouter *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)pushViewControllerWithNativeURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes{
    [self pushViewControllerWithURL:URL andParam:param andBlock:nil andAnimated:YES];
}

+ (void)pushViewControllerWithRemoteURL:(NSString *)URL animated:(BOOL)Yes{
    [self pushViewControllerWithURL:URL andParam:nil andBlock:nil andAnimated:YES];
}

+ (void)pushViewControllerWithNativeURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes withBlock:(reverseBlock)block{
    [self pushViewControllerWithURL:URL andParam:param andBlock:block andAnimated:Yes];
}

+ (void)pushViewControllerWithURL:(NSString *)URL andParam:(NSDictionary *)param andBlock:(reverseBlock)block andAnimated:(BOOL)Yes{
    //去除空格
    NSString *url = [URL stringByReplacingOccurrencesOfString:@" " withString:@""];
    //编码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //控制器对应的key
    NSString *controllerKey = nil;
    
    if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"]) {
        controllerKey = [self scheme:url];
    }else {
        BOOL hasScheme = [tprouterConfig hasScheme] && [[tprouterConfig hasScheme] isEqualToString:[self scheme:url]];
        
        if (!hasScheme) {
            NSException *exception = [NSException exceptionWithName:@"no such scheme" reason:@"please set right scheme" userInfo:nil];
            @throw exception;
        }
        controllerKey = [self hostUrl:url];
    }
    
    UIViewController *controller = (UIViewController *)[tprouterConfig controllerWithURL:controllerKey];
    //判断是native还是remote
    if ([url hasPrefix:[tprouterConfig hasScheme]]) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
        controller.routerParams = params;
        //如果是本地的url中包含了参数
        if ([self paramsFromRemoteURL:url]){
            [params addEntriesFromDictionary:[self paramsFromRemoteURL:url]];
            controller.routerParams = params;
        }
    }else if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"]){
        controller.routerParams = [self paramsFromRemoteURL:url];
        //传入远端的url
        controller.tp_remoteURL = [NSURL URLWithString:url];
    }
    //是否有block
    if (block) {
        controller.callBackBlock = block;
    }
    
    
    [RootViewController pushViewController:controller animated:Yes];
}

+ (NSDictionary *)paramsFromRemoteURL:(NSString *)URL{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *paramString = [[NSURL URLWithString:URL] query];
    NSArray *paramArray = [paramString componentsSeparatedByString:@"&"];
    for (NSString *param in paramArray) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    return params;
}

+ (NSString *)hostUrl:(NSString *)url{
    return [NSString stringWithFormat:@"%@://%@",[self scheme:url],[self host:url]];
}

+ (NSString *)scheme:(NSString *)url{
    return [NSURL URLWithString:url].scheme;
}

+ (NSString *)host:(NSString *)url{
    return [NSURL URLWithString:url].host;
}

#pragma mark - instance methods

- (void)pushViewControllerWithNativeURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes{
    [self pushViewControllerWithURL:URL andParam:param andBlock:nil andAnimated:YES];
}

- (void)pushViewControllerWithRemoteURL:(NSString *)URL animated:(BOOL)Yes{
    [self pushViewControllerWithURL:URL andParam:nil andBlock:nil andAnimated:YES];
}

- (void)pushViewControllerWithNativeURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes withBlock:(reverseBlock)block{
    [self pushViewControllerWithURL:URL andParam:param andBlock:block andAnimated:Yes];
}

- (void)pushViewControllerWithURL:(NSString *)URL andParam:(NSDictionary *)param andBlock:(reverseBlock)block andAnimated:(BOOL)Yes{
    
    NSString *url = [URL stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *controllerKey = nil;
    
    if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"]) {
        controllerKey = [self scheme:url];
    }else {
        BOOL hasScheme = [tprouterConfig hasScheme] && [[tprouterConfig hasScheme] isEqualToString:[self scheme:url]];
        
        if (!hasScheme) {
            NSException *exception = [NSException exceptionWithName:@"no such scheme" reason:@"please set right scheme" userInfo:nil];
            @throw exception;
        }
        controllerKey = [self hostUrl:url];
    }
    
    UIViewController *controller = (UIViewController *)[tprouterConfig controllerWithURL:controllerKey];
    
    if ([url hasPrefix:[tprouterConfig hasScheme]]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
        controller.routerParams = params;
        //如果是本地的url中包含了参数
        if ([self paramsFromRemoteURL:url]){
            [params addEntriesFromDictionary:[self paramsFromRemoteURL:url]];
            controller.routerParams = params;
        }
    }else if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"]){
        controller.routerParams = [self paramsFromRemoteURL:url];
        //传入远端的url
        controller.tp_remoteURL = [NSURL URLWithString:url];
    }
    //是否有block
    if (block) {
        controller.callBackBlock = block;
    }
    
    [RootViewController pushViewController:controller animated:Yes];
}

- (NSDictionary *)paramsFromRemoteURL:(NSString *)URL{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *paramString = [[NSURL URLWithString:URL] query];
    NSArray *paramArray = [paramString componentsSeparatedByString:@"&"];
    for (NSString *param in paramArray) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    return params;
}

- (NSString *)hostUrl:(NSString *)url{
    return [NSString stringWithFormat:@"%@://%@",[self scheme:url],[self host:url]];
}

- (NSString *)scheme:(NSString *)url{
    
    return [NSURL URLWithString:url].scheme;
}

- (NSString *)host:(NSString *)url{
    
    return [NSURL URLWithString:url].host;
}

@end
