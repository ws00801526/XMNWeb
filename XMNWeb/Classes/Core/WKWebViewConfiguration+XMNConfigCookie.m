//
//  WKWebViewConfiguration+XMNConfigCookie.m
//  Pods
//
//  Created by XMFraker on 17/2/15.
//
//

#import "NSHTTPCookie+XMNCookie.h"
#import "WKWebViewConfiguration+XMNConfigCookie.h"

#import "XMNWebMacro.h"

@implementation NSHTTPCookie (XMNCookiePrivate)

- (NSString *)xmn_configJS {
    
    if (!self || ![self isKindOfClass:[NSHTTPCookie class]]) {
        return nil;
    }
    
    if ([self.value rangeOfString:@"'"].location != NSNotFound) {
        
        return nil;
    }
    
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@",
                        self.name,
                        self.value,
                        self.domain,
                        self.path ?: @"/"];
    if (self.secure) {
        string = [string stringByAppendingString:@";secure=true"];
    }
    return string;
}

@end

@implementation WKWebViewConfiguration (XMNConfigCookie)

- (BOOL)xmn_configCookieJS {
    
    return [self xmn_configCookieJSWithNames:nil
                                     domains:nil];
}

- (BOOL)xmn_configCookieJSWithNames:(NSArray<NSString *> *)names {
    
    return [self xmn_configCookieJSWithNames:(names && names.count) ? names : nil
                                     domains:nil];
}

- (BOOL)xmn_configCookieJSWithDomains:(NSArray<NSString *> *)domains {
    
    return [self xmn_configCookieJSWithNames:nil
                                     domains:(domains && domains.count) ? domains : nil];
}

- (BOOL)xmn_configCookieJSWithNames:(NSArray<NSString *> *)names
                            domains:(NSArray<NSString *> *)domains {
    
    NSArray<NSHTTPCookie *> *cookies = [NSHTTPCookie xmn_cookiesWithNames:names
                                                                  domains:domains];
    
    if (!cookies || cookies.count == 0) {
        
        XMNLog(@"you dont have any cookie  about names  :%@   \n domains :%@",names, cookies);
        return NO;
    }
    
    NSMutableString *script = [NSMutableString string];
    // Get the currently set cookie names in javascriptland
    for (NSHTTPCookie *cookie in cookies) {
        
        NSString *configJS = [cookie xmn_configJS];
        if (!configJS || !configJS.length) {
            continue;
        }
        [script appendFormat:@"document.cookie='%@';\n",configJS];
    }
    if (script.length) {
        
        XMNLog(@"you will set cookie :%@",script);
        WKUserScript *cookieInScript = [[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [self.userContentController addUserScript:cookieInScript];
        return YES;
    }
    return NO;
}


- (BOOL)xmn_setCookieWithName:(NSString *)cookieName
                        value:(NSString *)cookieValue
                       domain:(NSString *)domain
                         path:(NSString *)path
                       secure:(BOOL)secure {

    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:@{NSHTTPCookieName : cookieName ? : @"",
                                                                NSHTTPCookieValue : cookieValue ? : @"",
                                                                NSHTTPCookieDomain : domain ? : @"",
                                                                NSHTTPCookiePath : path ? : @"/",
                                                                NSHTTPCookieSecure : @(secure)}];
    NSString *configJS = [cookie xmn_configJS];
    if (!configJS || !configJS.length) {
        return NO;
    }
    NSString *script = [NSString stringWithFormat:@"document.cookie='%@';\n",configJS];
    if (script && script.length) {
        XMNLog(@"you will set cookie :%@",script);
        WKUserScript *cookieInScript = [[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [self.userContentController addUserScript:cookieInScript];
        return YES;
    }
    return NO;
}

@end
