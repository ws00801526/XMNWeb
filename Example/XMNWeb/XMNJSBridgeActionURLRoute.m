//
//  XMNJSBridgeActionURLRoute.m
//  XMNWeb
//
//  Created by XMFraker on 17/2/21.
//  Copyright © 2017年 ws00801526. All rights reserved.
//

#import "XMNJSBridgeActionURLRoute.h"

#import <objc/message.h>

#import <XMNWeb/XMNTypeCastUtil.h>
#import <XMNWeb/XMNWebController+XMNWebOptions.h>


typedef NS_ENUM(NSUInteger, XMNURLRouteMode) {
    
    XMNURLRouteModeNewWeb = 0,
    XMNURLRouteModeBack,
    XMNURLRouteModeHistory,
};

@implementation XMNJSBridgeActionURLRoute

- (void)startAction {
    
    XMNURLRouteMode mode = [self.message.parameters xmn_integerForKey:@"mode"];
    
    NSDictionary *param = [self.message.parameters xmn_dictForKey:@"param"];

    switch (mode) {
        case XMNURLRouteModeNewWeb:
        {
            NSString *urlString = [self.message.parameters xmn_stringForKey:@"url"];
            if (!urlString || !urlString.length) {
                [self actionFailed];
                return;
            }
            [self openNewWebWithURLString:urlString
                                    param:param];
        }
            break;
        case XMNURLRouteModeBack:
            [self goBackWithParam:param];
            break;
            
        case XMNURLRouteModeHistory:
            [self goHistoryWithPage:[self.message.parameters xmn_stringForKey:@"page"]
                              param:param];
            break;
        default:
            [self actionFailed];
            break;
    }
}


- (void)openNewWebWithURLString:(NSString *)URLString
                          param:(NSDictionary *)param {
    
    XMNWebController *webC = [[XMNWebController alloc] initWithURL:[NSURL URLWithString:URLString]];
    [self.JSBridge.webController.navigationController pushViewController:webC animated:YES];
    [self actionSuccessedWithResult:@{}];
}

- (void)goBackWithParam:(NSDictionary *)param {
    
    [self.JSBridge.webController.navigationController popViewControllerAnimated:YES];
    [self actionSuccessedWithResult:@{}];
}

- (void)goHistoryWithPage:(NSString *)page
                    param:(NSDictionary *)param {
    
    if (!page || !page.length) {
        /** 没有page参数 执行普通的跳转方法 */
        [self goBackWithParam:param];
        return;
    }
    
    [self actionSuccessedWithResult:@{}];
}


- (NSURL *)transURLString:(NSString *)URLString {
    
    if (!URLString || !URLString.length) {
        return nil;
    }

    if ([URLString rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location != NSNotFound) {
        /** url字符串中 存在空格 */
        
        return nil;
    }
    
    NSURL *tmpURL = [NSURL URLWithString:URLString];

    if ([[XMNWebController applicatonURLSchemes] containsObject:[tmpURL scheme]]) {
        
        /** url 可以被app打开 */
        return tmpURL;
    }
    
    if (![tmpURL scheme]) {
        NSString *retURLString;
        if ([URLString hasPrefix:@"/"]) {
            retURLString = [NSString stringWithFormat:@"%@",URLString];
        }else {
            retURLString = [NSString stringWithFormat:@"%@/",URLString];
        }
        return [NSURL URLWithString:retURLString];
    }else {
        
        return tmpURL;
    }
}

@end
