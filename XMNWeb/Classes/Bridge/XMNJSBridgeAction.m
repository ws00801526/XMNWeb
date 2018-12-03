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

- (instancetype)init {
    
    return [self initWithBridge:[[XMNWebViewJSBridge alloc] init]
                        message:[[XMNJSBridgeMessage alloc] initWithDictionary:@{}]];
}

- (instancetype)initWithBridge:(XMNWebViewJSBridge *)bridge
                       message:(XMNJSBridgeMessage *)message {
    
    NSAssert(bridge, @"initJSBridgeAction bridge should not be nil");
    NSAssert(message, @"initJSBridgeAction message should not be nil");
    
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

- (void)actionWithResult:(nullable NSDictionary *)result {
    
    [self.JSBridge actionDidFinish:self success:YES result:result removed:NO];
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
    
    if (klass == nil) { // support swift
        NSString *module = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
        klass = NSClassFromString([NSString stringWithFormat:@"%@.%@", module, actionClassName]);
    }

    if (klass && [klass isSubclassOfClass:[XMNJSBridgeAction class]]) {
        return klass;
    }
    
    return NULL;
}

@end
