//
//  XMNWebJSBridge.h
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import <Foundation/Foundation.h>
#import "XMNWebController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMNWebViewJSBridge : NSObject

@property (weak, nonatomic, readonly) __kindof XMNWebController *webController;

@property (copy, nonatomic)   NSString *interfaceName;
@property (copy, nonatomic)   NSString *readyEventName;
@property (copy, nonatomic)   NSString *invokeScheme;

@property (copy, nonatomic, readonly)   NSString *javaScriptSource;

- (instancetype)initWithWebController:(__kindof XMNWebController *)webController NS_DESIGNATED_INITIALIZER;

@end

@interface XMNWebViewJSBridge (XMNWebDeprecated)

- (instancetype)init OBJC_UNAVAILABLE("use initWithWebController:");

@end

NS_ASSUME_NONNULL_END
