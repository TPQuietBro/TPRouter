//
//  WebViewControllerHttps.m
//  TPRouter
//
//  Created by allentang on 2017/8/24.
//  Copyright © 2017年 com.allen. All rights reserved.
//

#import "WebViewControllerHttps.h"
#import "UIViewController+RouterParams.h"
#import <WebKit/WebKit.h>
@interface WebViewControllerHttps ()

@end

@implementation WebViewControllerHttps

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webview = [[WKWebView alloc] init];
    
    webview.frame = self.view.bounds;
    
    [self.view addSubview:webview];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:self.tp_remoteURL];
    
    [webview loadRequest:req];
}


@end
