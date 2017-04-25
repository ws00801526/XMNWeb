//
//  NSHTTPCookie+XMNCookie.h
//  Pods
//
//  Created by XMFraker on 17/2/15.
//
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSHTTPCookie (XMNCookie)

- (NSString *)xmn_description;

/**
 获取存储的cookie
 
 @return @[NSHTTPCookie]
 */
+ (nullable NSArray<NSHTTPCookie *> *)xmn_cookies;

/**
 获取指定names的cookie
 
 @param names 指定的cookie.name
 
 @return @[NSHTTPCookie]
 */
+ (nullable NSArray<NSHTTPCookie *> *)xmn_cookiesWithNames:(nullable NSArray<NSString *> *)names;


/**
 获取cookies
 
 @param domains 指定cookie.name
 
 @return @[NSHTTPCookie]
 */
+ (nullable NSArray<NSHTTPCookie *> *)xmn_cookiesWithDomains:(nullable NSArray<NSString *> *)domains;


/**
 获取cookies
 
 @param names   指定cookie.name
 @param domains 指定cookie.domain
 
 @return @[NSHTTPCookie]
 */
+ (nullable NSArray<NSHTTPCookie *> *)xmn_cookiesWithNames:(nullable NSArray<NSString *> *)names
                                                   domains:(nullable NSArray<NSString *> *)domains;
@end


@interface NSHTTPCookie (XMNCookieStorage)

/**
 存储cookies
 获取当前[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies],存储起对应的cookieProperty
 
 @return cookies 被存储起来的cookies
 */
+ (nullable NSArray<NSDictionary *> *)xmn_storeCookies;

/**
 存储cookies
 
 @param  names @[cookie.name]
 @return cookies 被存储起来的cookies
 */
+ (nullable NSArray<NSDictionary *> *)xmn_storeCookiesWithNames:(nullable NSArray<NSString *> *)names;


/**
 存储cookies
 
 @param domains @[cookie.domain]
 
 @return cookies 被存储起来的cookies
 */
+ (nullable NSArray<NSDictionary *> *)xmn_storeCookiesWithDomains:(nullable NSArray<NSString *> *)domains;

/**
 存储cookies
 
 @param names   指定cookie.name
 @param domains 指定cookie.domain
 
 @return cookies 被存储起来的cookies
 */
+ (nullable NSArray<NSDictionary *> *)xmn_storeCookiesWithNames:(nullable NSArray<NSString *> *)names
                                                        domains:(nullable NSArray<NSString *> *)domains;

@end

@interface NSHTTPCookie (XMNCookieRemove)

/**
 删除所有cookies

 */
+ (void)xmn_deleteCookies;


/**
 删除指定names的cookies
 
 @param names @[cookie.name]
 */
+ (void)xmn_deleteCookiesWithNames:(nullable NSArray<NSString *> *)names;


/**
 删除cookies
 
 @param domains @[cookie.domain]
 */
+ (void)xmn_deleteCookiesWithDomains:(nullable NSArray<NSString *> *)domains;

/**
 删除cookies
 
 @param names   指定cookie.name
 @param domains 指定cookie.domain
 */
+ (void)xmn_deleteCookiesWithNames:(nullable NSArray<NSString *> *)names
                           domains:(nullable NSArray<NSString *> *)domains;

@end

NS_ASSUME_NONNULL_END
