//
//  XMNWebController+JSBridge.h
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import "XMNWebController.h"
#import "XMNWebViewJSBridge.h"
#import "XMNWebViewUserScript.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMNWebController (JSBridge)

/** 当前webController 的JSBridge */
@property (strong, nonatomic, readonly) XMNWebViewJSBridge *JSBridge;

/**
 配置一个webView的JSBridge

 @param JSBridge 需要配置的JSBridge
 */
- (void)xmn_configJSBridge:(XMNWebViewJSBridge *)JSBridge;

@end

NS_ASSUME_NONNULL_END
