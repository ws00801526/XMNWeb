//
//  XMNJSBridgeActionGoWebView.m
//  XMNWeb
//
//  Created by XMFraker on 17/2/21.
//  Copyright © 2017年 ws00801526. All rights reserved.
//

#import "XMNJSBridgeActionGoWebView.h"

@implementation XMNJSBridgeActionGoWebView

- (void)startAction {

    XMNWebController *webC = [[XMNWebController alloc] initWithURL:[NSURL URLWithString:self.message.parameters[@"url"]]];
    [self.JSBridge.webController.navigationController pushViewController:webC animated:YES];
    [self actionSuccessedWithResult:@{}];
}

@end
