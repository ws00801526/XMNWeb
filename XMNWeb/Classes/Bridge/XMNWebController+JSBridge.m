//
//  XMNWebController+JSBridge.m
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import "XMNWebController+JSBridge.h"
#import "NSObject+XMNJSONKit.h"

#import <objc/runtime.h>

@implementation XMNWebController (JSBridge)

- (void)xmn_configJSBridge:(XMNWebViewJSBridge *)JSBridge {
    
    if (JSBridge && self.JSBridge != JSBridge) {
        objc_setAssociatedObject(self, @selector(JSBridge), JSBridge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        __weak typeof(*&self) wSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __strong typeof(*&wSelf) self = wSelf;
            [self xmn_addUserScript:[XMNWebViewUserScript scriptWithSource:JSBridge injectionTime:XMNUserScriptInjectionTimeAtDocumentStart mainFrameOnly:NO]];
        });
    }
}

- (void)xmn_evaluateJavaScript:(NSString *)javaScriptString
               completionBlock:(void(^)(NSString * result, NSError * error))completionBlock {
    
    [self.webView evaluateJavaScript:javaScriptString
                   completionHandler:^(id result, NSError * _Nullable error) {
                      
                       if (completionBlock) {
                           NSString * resultString = nil;
                           if ([result isKindOfClass:[NSString class]]) {
                               resultString = result;
                           } else if ([result respondsToSelector:@selector(stringValue)]) {
                               resultString = [result stringValue];
                           } else if ([result respondsToSelector:@selector(xmn_JSONString)]) {
                               resultString = [result xmn_JSONString];
                           }
                           completionBlock(resultString, error);
                       }
                   }];
}

- (void)xmn_addUserScript:(XMNWebViewUserScript *)userScript {
    
    [self.webView.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:userScript.source injectionTime:userScript.scriptInjectionTime forMainFrameOnly:userScript.isForMainFrameOnly]];
}

- (void)xmn_removeAllUserScripts {
    
    [self.webView.configuration.userContentController removeAllUserScripts];
}

- (NSArray<WKUserScript *> *)userScripts {
    
    return self.webView.configuration.userContentController.userScripts;
}

- (XMNWebViewJSBridge *)JSBridge {
    
    return objc_getAssociatedObject(self, @selector(JSBridge));
}

@end
