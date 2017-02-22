//
//  WMWebController.m
//  XMNWeb
//
//  Created by XMFraker on 17/2/22.
//  Copyright © 2017年 ws00801526. All rights reserved.
//

#import "WMWebController.h"

#import <XMNWeb/NSObject+XMNJSONKit.h>

@interface WMWebController ()

@end

@implementation WMWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configWebView:(WKWebView *)webView {
        
    NSString *js = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iHealthBridge" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *config = @{@"version" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                             @"name" : @"ifuli",
                             @"platform" : @"ios"};
    
    js = [js stringByAppendingFormat:@"(%@);",config.xmn_JSONString];

    [self xmn_addUserScript:[XMNWebViewUserScript scriptWithSource:js
                                                     injectionTime:XMNUserScriptInjectionTimeAtDocumentStart
                                                     mainFrameOnly:YES]];

//    NSString *erudaJS = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eruda" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
//    [self xmn_addUserScript:[XMNWebViewUserScript scriptWithSource:erudaJS injectionTime:XMNUserScriptInjectionTimeAtDocumentEnd mainFrameOnly:YES]];
    
    [super configWebView:webView];
}

@end
