//
//  XMNWebMacro.h
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#ifndef XMNWebMacro_h
#define XMNWebMacro_h

#ifndef XMNLog
    #if DEBUG
        #define XMNLog(FORMAT,...) fprintf(stderr,"==============================================================\n=           com.XMFraker.WMLog                              =\n==============================================================\n%s  %s %d :\n       %s\n==============================================================\n=           com.XMFraker.WMLog End                          =\n==============================================================\n\n\n\n",__TIME__,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
    #else
        #define XMNLog(FORMAT,...);
    #endif
#endif

#ifndef XMN_UNAVAILABLE_MSG
    #define XMN_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif

/// ========================================
/// @name   相关版本宏
/// ========================================

#ifndef iOS7Later
    #define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#endif

#ifndef iOS8Later
    #define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#endif

#ifndef iOS9Later
    #define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#endif

#ifndef iOS10Later
    #define iOS10Later ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)
#endif


#pragma mark - 相关常量定义

static NSString * const XMNWebViewTimeoutKey = @"com.XMFraker.XMNWeb.XMNWebViewTimeoutKey";
static NSString * const XMNWebViewCustomHeadersKey = @"com.XMFraker.XMNWeb.XMNWebViewCustomHeaderKey";

#endif /* XMNWebMacro_h */
