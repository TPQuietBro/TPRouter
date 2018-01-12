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

+ (void)presentViewControllerWithRemoteURL:(NSString *)URL animated:(BOOL)Yes{
    [self presentViewControllerWithURL:URL andParam:nil andBlock:nil andAnimated:Yes];
}

+ (void)presentViewControllerWithURL:(NSString *)URL andParam:(NSDictionary *)param andBlock:(reverseBlock)block andAnimated:(BOOL)Yes{
    if (!URL) {
        NSLog(@"url为空");
        return;
    }
    //去除空格
    NSString *url = [URL stringByReplacingOccurrencesOfString:@" " withString:@""];
    //编码
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //控制器对应的key
    NSString *controllerKey = [self controllerKey:url];
    
    UIViewController *controller = [self targetControllerPropertyWithControllerKey:controllerKey url:url withParam:param withBlock:block];
    
    [RootViewController presentViewController:controller animated:Yes completion:nil];
}

+ (void)pushViewControllerWithURL:(NSString *)URL andParam:(NSDictionary *)param andBlock:(reverseBlock)block andAnimated:(BOOL)Yes{
    if (!URL) {
        NSLog(@"url为空");
        return;
    }
    //去除空格
    NSString *url = [URL stringByReplacingOccurrencesOfString:@" " withString:@""];
    //编码
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //控制器对应的key
    NSString *controllerKey = [self controllerKey:url];
    
    UIViewController *controller = [self targetControllerPropertyWithControllerKey:controllerKey url:url withParam:param withBlock:block];
    
    [RootViewController pushViewController:controller animated:Yes];
}


+ (NSString *)controllerKey:(NSString *)url{
    NSString *controllerKey = nil;
    
    if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"]) {
        controllerKey = [self scheme:url];
    }else {
        BOOL hasScheme = [tprouterConfig hasScheme] && [[tprouterConfig hasScheme] isEqualToString:[self scheme:url]];
        if (!hasScheme) {
#ifdef debug
            NSException *exception = [NSException exceptionWithName:@"no such scheme" reason:@"please set right scheme" userInfo:nil];
            @throw exception;
#else
            NSLog(@"no such scheme");
#endif
        }
        controllerKey = [self hostUrl:url];
    }
    return controllerKey;
}

+ (UIViewController *)targetControllerPropertyWithControllerKey:(NSString *)controllerKey  url:(NSString *)url withParam:(NSDictionary *)param withBlock:(reverseBlock)block{
    
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
    return controller;
}

+ (NSDictionary *)paramsFromRemoteURL:(NSString *)URL{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *paramString = [[NSURL URLWithString:URL] query];
    NSArray *paramArray = [paramString componentsSeparatedByString:@"&"];
    for (NSString *param in paramArray) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        NSString *key = elts.firstObject;
        NSString *value = elts.lastObject;
        //url会将中文转成带%的乱码,这里需要将中文乱码再转成中文
        if ([key containsString:@"%"]) {
            key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        if ([value containsString:@"%"]) {
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        [params setObject:value forKey:key];
    }
    return params;
}

+ (NSString *)hostUrl:(NSString *)url{
    return [NSString stringWithFormat:@"%@://%@%@%@",[self scheme:url],[self host:url],[self port:url],[self path:url]];
}

+ (NSString *)scheme:(NSString *)url{
    return [NSURL URLWithString:url].scheme;
}

+ (NSString *)host:(NSString *)url{
    return [NSURL URLWithString:url].host;
}

+ (NSString *)port:(NSString *)url{
    if ([url containsString:@":"]) {
        return [NSString stringWithFormat:@":%@",[NSURL URLWithString:url].port];
    }
    return [NSString stringWithFormat:@"%@",[NSURL URLWithString:url].port];
}
+ (NSString *)path:(NSString *)url{
    return [NSURL URLWithString:url].path;
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
    
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //控制器对应的key
    NSString *controllerKey = [self controllerKey:url];
    
    UIViewController *controller = [self targetControllerPropertyWithControllerKey:controllerKey url:url withParam:param withBlock:block];
    
    [RootViewController pushViewController:controller animated:Yes];
}

- (NSString *)controllerKey:(NSString *)url{
    NSString *controllerKey = nil;
    
    if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"]) {
        controllerKey = [self scheme:url];
    }else {
        BOOL hasScheme = [tprouterConfig hasScheme] && [[tprouterConfig hasScheme] isEqualToString:[self scheme:url]];
        
        if (!hasScheme) {
#ifdef debug
            NSException *exception = [NSException exceptionWithName:@"no such scheme" reason:@"please set right scheme" userInfo:nil];
            @throw exception;
#else
            NSLog(@"no such scheme");
#endif
        }
        controllerKey = [self hostUrl:url];
    }
    return controllerKey;
}

- (UIViewController *)targetControllerPropertyWithControllerKey:(NSString *)controllerKey  url:(NSString *)url withParam:(NSDictionary *)param withBlock:(reverseBlock)block{
    
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
    return controller;
}

- (NSDictionary *)paramsFromRemoteURL:(NSString *)URL{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *paramString = [[NSURL URLWithString:URL] query];
    NSArray *paramArray = [paramString componentsSeparatedByString:@"&"];
    for (NSString *param in paramArray) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        NSString *key = elts.firstObject;
        NSString *value = elts.lastObject;
        //url会将中文转成带%的乱码,这里需要将中文乱码再转成中文
        if ([key containsString:@"%"]) {
            key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        if ([value containsString:@"%"]) {
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        [params setObject:value forKey:key];
    }
    return params;
}

- (NSString *)hostUrl:(NSString *)url{

    return [NSString stringWithFormat:@"%@://%@%@%@",[self scheme:url],[self host:url],[self port:url],[self path:url]];
}

- (NSString *)scheme:(NSString *)url{
    
    return [NSURL URLWithString:url].scheme;
}

- (NSString *)host:(NSString *)url{
    
    return [NSURL URLWithString:url].host;
}

- (NSString *)port:(NSString *)url{
    if ([url containsString:@":"]) {
        return [NSString stringWithFormat:@":%@",[NSURL URLWithString:url].port];
    }
    return [NSString stringWithFormat:@"%@",[NSURL URLWithString:url].port];
}
- (NSString *)path:(NSString *)url{
    return [NSURL URLWithString:url].path;
}

@end
