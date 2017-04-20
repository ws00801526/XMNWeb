//
//  XMNWebJSBridge.m
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import "XMNWebViewJSBridge.h"

#import "NSObject+XMNJSONKit.h"
#import "XMNWebController+JSBridge.h"

@interface XMNWebViewJSBridge ()
{
    struct {
        
        unsigned int needsUpdate: 1;;
    } _flags;
}
@property (strong, nonatomic) NSMutableArray *actions;
@property (weak, nonatomic)   XMNWebController *webController;
@property (copy, nonatomic)   NSString *javaScriptSource;

@end

@implementation XMNWebViewJSBridge

#pragma mark - Life Cycle

- (instancetype)initWithWebController:(XMNWebController *)webC {
    
    NSAssert(webC, @"webController can not be nil while init JSBridge");

    if (self = [super init]) {
        
        self.actions = [NSMutableArray array];
        self.webController = webC;
        
        self.interfaceName = @"XMNJSBridge";
        self.readyEventName = @"XMNJSBridgeReady";
        self.invokeScheme = @"xmnjs://invoke";
    }
    return self;
}


#pragma mark - Public Method

- (BOOL)shouldContinueWebRequest:(NSURLRequest *)request {
    
    if (!request) {
        
        return NO;
    }
    
    NSURL * url = request.URL;
    if ([url.absoluteString isEqual:self.invokeScheme]) {
        NSString * js = [NSString stringWithFormat:@"%@._messageQueue()", _interfaceName];
        
        __weak typeof(*&self) wSelf = self;
        [self.webController xmn_evaluateJavaScript:js
                                   completionBlock:^(NSString * _Nonnull result, NSError * _Nonnull error) {
                                       __strong typeof(*&wSelf) self = wSelf;
                                       NSArray * queue = [result xmn_objectFromJSONString];
                                       if ([queue isKindOfClass:[NSArray class]]) {
                                           [self processMessageQueue:queue];
                                       }
                                   }];
        return NO;
    }
    return YES;
}


- (void)actionDidFinish:(XMNJSBridgeAction *)action
                success:(BOOL)success
                 result:(NSDictionary *)result {
    
    [self actionDidFinish:action success:success result:result removed:YES];
}

- (void)actionDidFinish:(XMNJSBridgeAction *)action
                success:(BOOL)success
                 result:(NSDictionary *)result
                removed:(BOOL)shouldRemoved {
    
    if (![self.actions containsObject:action]) return;
    
    if (shouldRemoved) {
        [self.actions removeObject:action];
    }
    [self sendCallbackForMessage:action.message success:success result:result];
}

#pragma mark - Private Method


/**
 处理需要执行的消息队列
 
 @param queue 需要处理的消息队列
 */
- (void)processMessageQueue:(NSArray<NSDictionary *> *)queue {
    
    for (NSDictionary * dict in queue) {
        
        XMNJSBridgeMessage * message = [[XMNJSBridgeMessage alloc] initWithDictionary:dict];
        [self processMessage:message];
    }
}


/**
 处理消息队列中的单条消息

 @param message 需要处理的消息
 */
- (void)processMessage:(XMNJSBridgeMessage *)message {
    
    /** 获取消息对应的action 处理类 */
    XMNJSBridgeAction * action = nil;
    Class klass = [XMNJSBridgeAction actionClassForActionName:message.action];
    
    if (klass) {
        
        action = [[klass alloc] initWithBridge:self
                                       message:message];
    }
    
    if (action) {
        /** 找到action, 执行action */
        [_actions addObject:action];
        [action startAction];
    } else {
        /** 未找到处理action的Class */
        [self sendCallbackForMessage:message
                             success:NO
                              result:nil];
    }
}

/**
 执行消息回到callBack

 @param message 回调的消息
 @param success 是否成功
 @param result  消息处理结果
 */
- (void)sendCallbackForMessage:(XMNJSBridgeMessage *)message
                       success:(BOOL)success
                        result:(NSDictionary *)result {
    
    if (!message.callbackID) {
        /** message 没有callBackID 无需回调*/
        return;
    }
    NSDictionary * callback = @{@"params": result ? : @{},
                                @"failed": @(!success),
                                @"callback_id": message.callbackID};
    NSString * js = [NSString stringWithFormat:@"%@._handleMessage(%@)", _interfaceName, callback.xmn_JSONString];
    [self.webController xmn_evaluateJavaScript:js completionBlock:NULL];
}

#pragma mark - Setter

- (void)setInterfaceName:(NSString *)interfaceName {
    
    if (_interfaceName != interfaceName) {
        _interfaceName = [interfaceName copy];
        _flags.needsUpdate =  1;
    }
}

- (void)setReadyEventName:(NSString *)readyEventName {
    
    if (_readyEventName != readyEventName) {
        _readyEventName = [readyEventName copy];
        _flags.needsUpdate =  1;
    }
}

- (void)setInvokeScheme:(NSString *)invokeScheme {
    
    if (_invokeScheme != invokeScheme) {
        _invokeScheme = [invokeScheme copy];
        _flags.needsUpdate = 1;
    }
}

#pragma mark - Getter

- (NSString *)javaScriptSource {
    
    if (!_javaScriptSource || _flags.needsUpdate) {
        
        _javaScriptSource = [[NSString alloc] initWithContentsOfFile:[XMNWebJSBridgeBundle() pathForResource:@"xmnjs" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL];
        NSAssert(_interfaceName, @"interfaceName must not nil");
        NSAssert(_readyEventName, @"readyEventName must not nil");
        NSAssert(_invokeScheme, @"invokeScheme must not nil");
        
        NSDictionary * config = @{@"interface": _interfaceName,
                                  @"readyEvent": _readyEventName,
                                  @"invokeScheme": _invokeScheme};
        
        NSString * json = [config xmn_JSONString];
        _javaScriptSource = [_javaScriptSource stringByAppendingFormat:@"(%@)", json];
    }
    return  _javaScriptSource;
}


@end
