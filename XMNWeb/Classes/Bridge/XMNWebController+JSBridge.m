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
    }
}

- (XMNWebViewJSBridge *)JSBridge {
    
    return objc_getAssociatedObject(self, @selector(JSBridge));
}
@end
