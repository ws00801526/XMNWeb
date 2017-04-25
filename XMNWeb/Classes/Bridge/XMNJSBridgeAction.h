//
//  XMNJSBridgeAction.h
//  Pods
//
//  Created by XMFraker on 17/2/17.
//
//

#import "XMNJSBridgeMessage.h"
#import "XMNWebMacro.h"

NS_ASSUME_NONNULL_BEGIN

@class XMNWebViewJSBridge;
@interface XMNJSBridgeAction : NSObject

@property (nonatomic, weak, readonly)   XMNWebViewJSBridge * JSBridge;
@property (nonatomic, strong, readonly) XMNJSBridgeMessage * message;

- (instancetype)initWithBridge:(XMNWebViewJSBridge *)bridge
                       message:(XMNJSBridgeMessage *)message NS_DESIGNATED_INITIALIZER;

- (void)startAction;

- (void)actionWithResult:(nullable NSDictionary *)result;
- (void)actionSuccessedWithResult:(nullable NSDictionary *)result;
- (void)actionFailed;

+ (nullable Class)actionClassForActionName:(NSString *)actionName;

@end

NS_ASSUME_NONNULL_END
