//
//  WKWebViewConfiguration+XMNConfigCookie.h
//  Pods
//
//  Created by XMFraker on 17/2/15.
//
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WKWebViewConfiguration (XMNConfigCookie)

/**
 *  @brief iOS8+ 使用  WKWebView不会直接使用NSHTTPCookieStorage中的cookie
 *  使用此方法,可以将NSHTTPCookieStorage中的cookie 通过JS方法 写入到webView中
 */
- (BOOL)xmn_configCookieJS;

/**
 使用JS方法,将cookie写入到webView中
 
 @param names 指定cookie.name
 */
- (BOOL)xmn_configCookieJSWithNames:(NSArray<NSString *> *)names;


/**
 使用JS方法,将cookie写入到webView中
 
 @param domains 指定cookie.domain
 */
- (BOOL)xmn_configCookieJSWithDomains:(NSArray<NSString *> *)domains;


/**
 使用JS方法,将cookie写入到webView中
 
 @param names   指定的cookie.name
 @param domains 指定的cookie.domains
 */
- (BOOL)xmn_configCookieJSWithNames:(NSArray<NSString *> *)names
                            domains:(NSArray<NSString *> *)domains;


/**
 配置单独的一个cookie, 直接写入

 @param cookieName   cookie名称
 @param cookieValue  cookie值
 @param domain       cookie域
 @param path         cookie路径
 @param secure       是否为安全cookie
 @return YES or NO
 */
- (BOOL)xmn_setCookieWithName:(NSString *)cookieName
                        value:(NSString *)cookieValue
                       domain:(NSString *)domain
                         path:(NSString *)path
                       secure:(BOOL)secure;
@end


