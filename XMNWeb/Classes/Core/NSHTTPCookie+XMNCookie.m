//
//  NSHTTPCookie+XMNCookie.m
//  Pods
//
//  Created by XMFraker on 17/2/15.
//
//

#import "NSHTTPCookie+XMNCookie.h"

static NSString *kXMNCookieStorageKey = @"com.XMFraker.XMNWeb.kXMNCookieStorageKey";

@implementation NSHTTPCookie (XMNCookie)

- (NSString *)xmn_description {
    
    if (!self) {
        return @"cookie is nil";
    }

    if (![self isKindOfClass:[NSHTTPCookie class]]) {
        
        
        return [NSString stringWithFormat:@"%@ is not cookie class",[self description]];
    }
    
    if ([self.value rangeOfString:@"'"].location != NSNotFound) {

        return [NSString stringWithFormat:@"%@ is a illegal cookie",[self description]];
    }
    
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@",
                        self.name,
                        self.value,
                        self.domain,
                        self.path ?: @"/"];
    if (self.secure) {
        string = [string stringByAppendingString:@";secure=true;"];
    }
    return string;
}



/**
 获取存储的cookie
 
 @return @[NSHTTPCookie]
 */
+ (nullable NSArray<NSHTTPCookie *> *)xmn_cookies {
    
    return [self xmn_cookiesWithNames:nil
                              domains:nil];
}

/**
 获取指定names的cookie
 
 @param names 指定的cookie.name
 
 @return @[NSHTTPCookie]
 */
+ (nullable NSArray<NSHTTPCookie *> *)xmn_cookiesWithNames:(NSArray<NSString *> *)names {
    
    return [self xmn_cookiesWithNames:(names && names.count) ? names : nil
                              domains:nil];
}


/**
 获取cookies
 
 @param domains 指定cookie.name
 
 @return
 */
+ (nullable NSArray<NSHTTPCookie *> *)xmn_cookiesWithDomains:(NSArray<NSString *> *)domains {
    
    return [self xmn_cookiesWithNames:nil
                              domains:(domains && domains.count) ? domains : nil];
}


/**
 获取cookies
 
 @param names   指定cookie.name
 @param domains 指定cookie.domain
 
 @return
 */
+ (nullable NSArray<NSHTTPCookie *> *)xmn_cookiesWithNames:(NSArray<NSString *> *)names
                                                   domains:(NSArray<NSString *> *)domains {
    
    NSArray *cookieProperties = [[NSUserDefaults standardUserDefaults] objectForKey:kXMNCookieStorageKey];
    if (!cookieProperties) {
        return nil;
    }
    
    NSMutableArray *cookies = [NSMutableArray arrayWithCapacity:cookieProperties.count];
    for (NSDictionary *cookieProperty in cookieProperties) {
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperty];
        if (cookie) {
            [cookies addObject:cookie];
        }
    }
    
    if (names && names.count) {
        [cookies filterUsingPredicate:[NSPredicate predicateWithFormat:@"name in (%@)", names]];
    }
    
    if (domains && domains.count) {
        [cookies filterUsingPredicate:[NSPredicate predicateWithFormat:@"domain in (%@)", domains]];
    }

    return (cookies && cookies.count) ? [cookies copy] : nil;
}
@end


@implementation NSHTTPCookie (XMNCookieStorage)

+ (nullable NSArray<NSDictionary *> *)xmn_storeCookies {
    
    return [self xmn_storeCookiesWithNames:nil
                                   domains:nil];
}

+ (nullable NSArray<NSDictionary *> *)xmn_storeCookiesWithNames:(nullable NSArray<NSString *> *)names {
 
    return [self xmn_storeCookiesWithNames:(names && names.count) ? names : nil
                                   domains:nil];
}

+ (nullable NSArray<NSDictionary *> *)xmn_storeCookiesWithDomains:(nullable NSArray<NSString *> *)domains {
    
    return [self xmn_storeCookiesWithNames:nil
                                   domains:(domains && domains.count) ? domains : nil];
}

+ (nullable NSArray<NSDictionary *> *)xmn_storeCookiesWithNames:(nullable NSArray<NSString *> *)names
                                                        domains:(nullable NSArray<NSString *> *)domains {
    
    NSArray<NSHTTPCookie *> *cookiesInStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if (names && names.count) {
        cookiesInStorage = [cookiesInStorage filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name in (%@)", names]];
    }
    
    if (domains && domains.count) {
        cookiesInStorage = [cookiesInStorage filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"domain in (%@)", domains]];
    }
    
    if (!cookiesInStorage || !cookiesInStorage.count) {
        return nil;
    }
    
    NSMutableArray<NSDictionary *> *cookieProperties = [NSMutableArray array];
    for (NSHTTPCookie *cookie in cookiesInStorage) {
        
        if (cookie.properties) {
            [cookieProperties addObject:cookie.properties];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[cookieProperties copy] forKey:kXMNCookieStorageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return cookieProperties;
}
@end

@implementation NSHTTPCookie (XMNCookieRemove)

+ (void)xmn_deleteCookies {
    
    [self xmn_deleteCookiesWithNames:nil
                             domains:nil];
}

+ (void)xmn_deleteCookiesWithNames:(nullable NSArray<NSString *> *)names {
    
    
    [self xmn_deleteCookiesWithNames:(names && names.count) ? names : nil
                             domains:nil];
}


+ (void)xmn_deleteCookiesWithDomains:(nullable NSArray<NSString *> *)domains {
    
    [self xmn_deleteCookiesWithNames:nil
                             domains:(domains && domains.count) ? domains : nil];
}

+ (void)xmn_deleteCookiesWithNames:(nullable NSArray<NSString *> *)names
                           domains:(nullable NSArray<NSString *> *)domains {
    
    NSArray *cookieProperties = [[NSUserDefaults standardUserDefaults] objectForKey:kXMNCookieStorageKey];
    if (!cookieProperties) {
        return;
    }
    
    NSMutableArray *cookies = [NSMutableArray arrayWithCapacity:cookieProperties.count];
    for (NSDictionary *cookieProperty in cookieProperties) {
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperty];
        if (cookie) {
            [cookies addObject:cookie];
        }
    }
    
    if (names && names.count) {

        [cookies filterUsingPredicate:[NSPredicate predicateWithFormat:@"not name in (%@)", names]];
    }
    
    if (domains && domains.count) {

        [cookies filterUsingPredicate:[NSPredicate predicateWithFormat:@"not domain in (%@)", domains]];
    }
    
    if (!cookies || !cookies.count) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMNCookieStorageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    {
        NSMutableArray<NSDictionary *> *cookieProperties = [NSMutableArray array];
        for (NSHTTPCookie *cookie in cookies) {
            
            if (cookie.properties) {
                [cookieProperties addObject:cookie.properties];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:[cookieProperties copy] forKey:kXMNCookieStorageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
