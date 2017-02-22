//
//  XMNWebController+Console.m
//  Pods
//
//  Created by XMFraker on 17/2/20.
//
//

#import "XMNWebController+Console.h"
#import <objc/runtime.h>

@implementation XMNWebController (Console)

- (void)xmn_configConsole:(XMNWebViewConsole *)console {
    
    if (self.console != console) {
        objc_setAssociatedObject(self, @selector(console), console, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (XMNWebViewConsole *)console {
    
    return objc_getAssociatedObject(self, @selector(console));
}

@end
