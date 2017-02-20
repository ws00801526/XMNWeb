//
//  XMNWebJSBridge.h
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import <Foundation/Foundation.h>
#import "XMNWebController.h"
#import "XMNJSBridgeAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMNWebViewJSBridge : NSObject

/** jsbridge 关联的webController */
@property (weak, nonatomic, readonly) __kindof XMNWebController *webController;

/** 当前JSBridge 名称 */
@property (copy, nonatomic)   NSString *interfaceName;
/** 当前JSBridge 在document执行完成后的回调名称 */
@property (copy, nonatomic)   NSString *readyEventName;
/** JSBridge invoke方法的 请求URL, 此URL 会在shouldContinueWebRequest 中被忽略 */
@property (copy, nonatomic)   NSString *invokeScheme;
/** 初始化js源码 */
@property (copy, nonatomic, readonly)   NSString *javaScriptSource;


/**
 初始化方法, 获得一个JSBridge实例
 当JSBridge实例初始化完成后,  JSBridge.javaScriptSource 会被添加到webController.webView中
 
 @param webController 使用JSBridge的webController
 @return JSBridge 实例
 */
- (instancetype)initWithWebController:(__kindof XMNWebController *)webController NS_DESIGNATED_INITIALIZER;

/**
 在JSBridge中判断当前请求是否应该继续

 @param request 请求实例
 @return YES or NO
 */
- (BOOL)shouldContinueWebRequest:(NSURLRequest *)request;


/**
 action执行完成后,提供给action进行回调的方法

 @param action   执行的action
 @param success  是否执行成功
 @param result   执行结果
 */
- (void)actionDidFinish:(XMNJSBridgeAction *)action
                success:(BOOL)success
                 result:(NSString *)result;

@end

@interface XMNWebViewJSBridge (XMNWebDeprecated)

- (instancetype)init OBJC_UNAVAILABLE("use initWithWebController:");

@end

NS_ASSUME_NONNULL_END
