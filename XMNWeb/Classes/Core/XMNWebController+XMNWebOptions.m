//
//  XMNWebController+XMNWebOptions.m
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import "XMNWebController+XMNWebOptions.h"

#import "XMNWebMarco.h"

static NSArray<NSString *> *kXMNWebViewControllerApplicationSchemes;
static NSArray<NSString *> *kXMNWebViewControllerIgnoredSchemes;
static NSArray<NSString *> *kXMNWebViewControllerIgnoredHosts;
static NSDictionary *kXMNWebViewControllerOptions;

@implementation XMNWebController (XMNWebOptions)

+ (nonnull NSDictionary *)webViewOptions {
    
    @synchronized (kXMNWebViewControllerOptions) {
        return kXMNWebViewControllerOptions ? : @{XMNWebViewTimeoutKey : @(20)};
    }
}

+ (void)setWebViewOptions:(nonnull NSDictionary *)options{

    @synchronized (kXMNWebViewControllerOptions) {
        kXMNWebViewControllerOptions = [options  copy];
    }
}

+ (NSArray <NSString *> *)applicatonURLSchemes {
    
    @synchronized (kXMNWebViewControllerApplicationSchemes) {
        return kXMNWebViewControllerApplicationSchemes ? : @[@"alipay",@"alipays",@"weixin",@"wechat",@"tel",@"mailto",@"itms-appss"];
    }
}

+ (void)setApplicationURLSchemes:(NSArray *)schemes {
    
    @synchronized (kXMNWebViewControllerApplicationSchemes) {
        kXMNWebViewControllerApplicationSchemes = schemes;
    }
}

+ (NSArray <NSString *> * _Nullable)ignoreURLSchemes {
    
    @synchronized (kXMNWebViewControllerIgnoredSchemes) {
        return kXMNWebViewControllerIgnoredSchemes;
    }
}

+ (void)setIgnoreSchemes:(NSArray * _Nullable)schemes {
    
    @synchronized (kXMNWebViewControllerIgnoredSchemes) {
        kXMNWebViewControllerIgnoredSchemes = schemes;
    }
}

+ (NSArray <NSString *> * _Nullable)ignoreURLHosts {
    
    @synchronized (kXMNWebViewControllerIgnoredHosts) {
        return kXMNWebViewControllerIgnoredHosts;
    }
}

+ (void)setIgnoreHosts:(NSArray * _Nullable)hosts {
 
    @synchronized (kXMNWebViewControllerIgnoredHosts) {
        kXMNWebViewControllerIgnoredHosts = hosts;
    }
}

@end
