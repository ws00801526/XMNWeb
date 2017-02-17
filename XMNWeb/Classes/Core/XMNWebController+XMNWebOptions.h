//
//  XMNWebController+XMNWebOptions.h
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import "XMNWebController.h"

@interface XMNWebController (XMNWebOptions)

/**
 默认webView加载的配置
 目前支持XMNWebViewTimeoutKey,XMNWebViewCustomHeadersKey
 @return NSDictionary
 */
+ (nonnull NSDictionary *)webViewOptions;


/**
 设置webView默认加载配置
 目前支持XMNWebViewTimeoutKey,XMNWebViewCustomHeadersKey

 @param options 新的设置
 */
+ (void)setWebViewOptions:(nonnull NSDictionary *)options;

/**
 *  @brief 如果网络请求urlscheme 在applicationURLSchemes中
 *  会使用[[UIApplication sharedApplication] openURL:] 调起当前请求
 *  默认处理下列协议 @[@"alipay",@"alipays",@"weixin",@"wechat",@"tel",@"mailto",@"itms-appss"]
 *  @return
 */
+ (nonnull NSArray <NSString *> *)applicatonURLSchemes;

/**
 *  @brief 设置URLSchemes
 *
 *  @param schemes 由[UIApplication sharedApplication] 打开的schemes
 */
+ (void)setApplicationURLSchemes:(nullable NSArray<NSString *> *)schemes;

/**
 *  @brief 如果请求scheme 在ignoreURLSchemes中,则忽略该请求
 *
 *  @return
 */
+ (nullable NSArray <NSString *> *)ignoreURLSchemes;

/**
 *  @brief 设置可以被忽略的urlSchemes
 *
 *  @param schemes 可为空
 */
+ (void)setIgnoreSchemes:(nullable NSArray *)schemes;

/**
 *  @brief 如果请求scheme 在ignoreURLHosts中,则忽略该请求
 *
 *  @return
 */
+ (nullable NSArray <NSString *> *)ignoreURLHosts;

/**
 *  @brief 设置可以被忽略的url host
 *
 *  @param schemes 可为空
 */
+ (void)setIgnoreHosts:(nullable NSArray *)hosts;

@end
