//
//  XMNJSBridgeActionURLRoute.m
//  XMNWeb
//
//  Created by XMFraker on 17/2/21.
//  Copyright © 2017年 ws00801526. All rights reserved.
//

#import "XMNJSBridgeActionURLRoute.h"

#import <objc/message.h>

#import "WMWebController.h"

#import <XMNWeb/XMNTypeCastUtil.h>
#import <XMNWeb/XMNWebController+XMNWebOptions.h>


typedef NS_ENUM(NSUInteger, XMNURLRouteMode) {
    
    XMNURLRouteModeNewWeb = 0,
    XMNURLRouteModeBack,
    XMNURLRouteModeHistory,
    XMNURLRouteModeLogin,
};

@implementation XMNJSBridgeActionURLRoute

- (void)startAction {
    
    XMNURLRouteMode mode = [self.message.parameters xmn_integerForKey:@"mode"];
    NSDictionary *param = [self.message.parameters xmn_dictForKey:@"param"];

    switch (mode) {
        case XMNURLRouteModeNewWeb:
            [self openNewWebWithURLString:[self.message.parameters xmn_stringForKey:@"url"]
                                    param:param];
            break;
        case XMNURLRouteModeBack:
            [self goBackWithParam:param];
            break;
            
        case XMNURLRouteModeHistory:
            [self goHistoryWithPage:[self.message.parameters xmn_stringForKey:@"url"]
                              param:param];
            break;
        case XMNURLRouteModeLogin:
            
            [self goLoginWithParam:param];
            break;
        default:
            [self actionFailed];
            break;
    }
}

- (void)openNewWebWithURLString:(NSString *)URLString
                          param:(NSDictionary *)param {
    
    if (!URLString || !URLString.length) {
        [self actionFailed];
        return;
    }

    WMWebController *webC = [[WMWebController alloc] initWithURL:[NSURL URLWithString:URLString]];
    [self.JSBridge.webController.navigationController pushViewController:webC animated:YES];
    [self actionSuccessedWithResult:@{}];
}

- (void)goBackWithParam:(NSDictionary *)param {
    
    BOOL inWeb = [param xmn_integerForKey:@"inWeb"];
    BOOL needRefresh = [param xmn_integerForKey:@"needRefresh"];

    if (inWeb && self.JSBridge.webController.webView.canGoBack) {
        
        [self.JSBridge.webController.webView goBack];
    }else {
        
        NSArray <UIViewController *> *viewCs = self.JSBridge.webController.navigationController.viewControllers;
        if (viewCs.count >= 2) {
            if (needRefresh) {
                UIViewController *nextViewC = viewCs[viewCs.count - 2];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wmissing-declarations"
                if ([nextViewC isKindOfClass:[XMNWebController class]] || [nextViewC respondsToSelector:@selector(reloadController)]) {
                    [nextViewC performSelector:@selector(reloadController)];
                }
#pragma clang diagnostic pop
            }
            [self.JSBridge.webController.navigationController popViewControllerAnimated:YES];
        }
    }
    [self actionSuccessedWithResult:@{}];
}


- (void)goHistoryWithPage:(NSString *)page
                    param:(NSDictionary *)param {
    
    if (!page || !page.length) {
        /** 没有page参数 执行普通的跳转方法 */
        [self goBackWithParam:param];
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:page];
    
    if (!URL) {
        [self goBackWithParam:param];
        return;
    }
    
    BOOL inWeb = [param xmn_integerForKey:@"inWeb"];
    BOOL needRefresh = [param xmn_integerForKey:@"needRefresh"];
    
    if (inWeb) {
        
        /** 只在当前webView 中进行跳转 */
        __weak __block WKBackForwardListItem *backItem;
        [self.JSBridge.webController.webView.backForwardList.backList enumerateObjectsUsingBlock:^(WKBackForwardListItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([[obj.URL path] isEqualToString:[URL path]]) {
                
                backItem = obj;
                *stop = YES;
            }
        }];
        
        if (backItem) {
            [self.JSBridge.webController.webView goToBackForwardListItem:backItem];
            [self actionSuccessedWithResult:@{}];
        }
    }else {
        
        __weak __block UIViewController *backC;
        [self.JSBridge.webController.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[XMNWebController class]]) {
                
                if ([[URL path] isEqualToString:[[(XMNWebController *)obj currentURL] path]]) {
                    
                    backC = obj;
                    *stop = YES;
                }
            }
        }];
        
        if (backC) {
            
            if (needRefresh) {
                /** 刷新webContent */
                [(XMNWebController *)backC reloadController];
            }
            
            [self.JSBridge.webController.navigationController popToViewController:backC animated:YES];
            [self actionSuccessedWithResult:@{}];
        }
    }
    [self goBackWithParam:param];
}

- (void)goLoginWithParam:(NSDictionary *)param {
    
    [self actionSuccessedWithResult:@{}];
}

//- (NSURL *)transURLString:(NSString *)URLString {
//    
//    if (!URLString || !URLString.length) {
//        return nil;
//    }
//
//    if ([URLString rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location != NSNotFound) {
//        /** url字符串中 存在空格 */
//        
//        return nil;
//    }
//    
//    NSURL *tmpURL = [NSURL URLWithString:URLString];
//
//    if ([[XMNWebController applicatonURLSchemes] containsObject:[tmpURL scheme]]) {
//        
//        /** url 可以被app打开 */
//        return tmpURL;
//    }
//    
//    if (![tmpURL scheme]) {
//        NSString *retURLString;
//        if ([URLString hasPrefix:@"/"]) {
//            retURLString = [NSString stringWithFormat:@"%@",URLString];
//        }else {
//            retURLString = [NSString stringWithFormat:@"%@/",URLString];
//        }
//        return [NSURL URLWithString:retURLString];
//    }else {
//        
//        return tmpURL;
//    }
//}

@end
