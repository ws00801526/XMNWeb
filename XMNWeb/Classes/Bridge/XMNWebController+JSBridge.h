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

#ifndef XMNWebViewJSBridgeEnabled
    #define XMNWebViewJSBridgeEnabled 1
#endif

NS_ASSUME_NONNULL_BEGIN

@interface XMNWebController (JSBridge)

/** 当前webController 的JSBridge */
@property (strong, nonatomic, readonly) XMNWebViewJSBridge *JSBridge;
/** 当前webControler.webView中添加的所有用户脚本 */
@property (copy, nonatomic, readonly, nullable) NSArray<WKUserScript *> *userScripts;

/**
 配置一个webView的JSBridge

 @param JSBridge 需要配置的JSBridge
 */
- (void)xmn_configJSBridge:(XMNWebViewJSBridge *)JSBridge;

/**
 执行一段JS代码

 @param javaScriptString 需要执行的JS代码
 @param completionBlock  回调block
 */
- (void)xmn_evaluateJavaScript:(NSString *)javaScriptString
               completionBlock:(void(^)(NSString * result, NSError * error))completionBlock;

/**
 添加一点JS脚本

 @param userScript 需要添加的JS脚本
 */
- (void)xmn_addUserScript:(XMNWebViewUserScript *)userScript;


/**
 删除所有手动添加的JS脚本
 */
- (void)xmn_removeAllUserScripts;

@end

NS_ASSUME_NONNULL_END
