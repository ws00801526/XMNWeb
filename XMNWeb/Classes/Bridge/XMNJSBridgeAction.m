//
//  XMNJSBridgeAction.m
//  Pods
//
//  Created by XMFraker on 17/2/17.
//
//

#import "XMNJSBridgeAction.h"
#import "XMNWebViewJSBridge.h"

@interface XMNJSBridgeAction ()

@property (weak, nonatomic) XMNWebViewJSBridge *JSBridge;
@property (strong, nonatomic) XMNJSBridgeMessage *message;

@end

@implementation XMNJSBridgeAction

#pragma mark - Life Cycle

- (instancetype)initWithBridge:(XMNWebViewJSBridge *)bridge
                       message:(XMNJSBridgeMessage *)message {
    
    if (self = [super init]) {
     
        self.JSBridge = bridge;
        self.message = message;
    }
    return self;
}

#pragma mark - Public Method

- (void)startAction {
    
    [self actionFailed];
}

- (void)actionFailed {
    
    [self.JSBridge actionDidFinish:self success:NO result:nil];
}

- (void)actionSuccessedWithResult:(NSDictionary *)result {
    
    [self.JSBridge actionDidFinish:self success:YES result:result];
}

#pragma mark - Class Method

NSString * const XMNJSBridgeActionClassNamePrefix = @"XMNJSBridgeAction";

+ (Class)actionClassForActionName:(NSString *)actionName {
    
    if (!actionName || !actionName.length) {
        return  NULL;
    }
    
    actionName = [actionName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[actionName substringToIndex:1].capitalizedString];
    
    NSString * actionClassName = [NSString stringWithFormat:@"%@%@", XMNJSBridgeActionClassNamePrefix, actionName];
    Class klass = NSClassFromString(actionClassName);
    
    if (klass && [klass isSubclassOfClass:[XMNJSBridgeAction class]]) {
        return klass;
    }
    
    return NULL;
}

@end
