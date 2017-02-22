//
//  XMNWebViewConsole.m
//  Pods
//
//  Created by XMFraker on 17/2/20.
//
//

#import "XMNWebViewConsole.h"

#import "NSObject+XMNJSONKit.h"
#import "XMNWebController+JSBridge.h"

NSString * const XMNWebViewConsoleDidAddMessageNotification = @"com.XMFraker.XMNWeb.XMNWebViewConsoleDidAddMessageNotification";
NSString * const XMNWebViewConsoleDidClearMessagesNotification = @"com.XMFraker.XMNWeb.XMNWebViewConsoleDidClearMessagesNotification";
NSString * const XMNWebViewConsoleLastSelectionElementName = @"com.XMFraker.XMNWeb.XMNWebViewConsoleLastSelectionElementName";

@interface XMNWebViewConsole ()

@property (nonatomic, strong) NSMutableArray<XMNWebViewConsoleMessage *> * messages;
@property (nonatomic, strong) NSMutableArray<XMNWebViewConsoleMessage *> * clearedMessages;
@property (nonatomic, weak) __kindof XMNWebController *webController;


@end

@implementation XMNWebViewConsole
@synthesize javaScriptSource = _javaScriptSource;
#pragma mark - Life Cycle

- (instancetype)initWithWebController:(__kindof XMNWebController *)webController {
    
    NSAssert(webController, @"webController can not be nil while init Console");

    if (self = [super init]) {
        
        self.messages = [NSMutableArray array];
        self.clearedMessages = [NSMutableArray array];
        self.webController = webController;
    }
    return self;
}

#pragma mark - Public Method

- (void)clearMesssages {
    
    [_messages removeAllObjects];
    [_clearedMessages removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XMNWebViewConsoleDidClearMessagesNotification object:self];
}

- (void)softClearMessages {
    
    [_clearedMessages addObjectsFromArray:_messages];
    [_messages removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XMNWebViewConsoleDidClearMessagesNotification object:self];

}

- (void)logMessage:(NSString *)message
              type:(XMNWebViewConsoleMessageType)type
             level:(XMNWebViewConsoleMessageLevel)level
            source:(XMNWebViewConsoleMessageSource)source {
    
    [self logMessage:message type:type level:level source:source url:nil line:0 column:0];
}

- (void)logMessage:(NSString *)message
              type:(XMNWebViewConsoleMessageType)type
             level:(XMNWebViewConsoleMessageLevel)level
            source:(XMNWebViewConsoleMessageSource)source
               url:(NSString *)url
              line:(NSInteger)line
            column:(NSInteger)column {
    
    switch (type) {
        case XMNWebViewConsoleMessageTypeClear:
            [self softClearMessages];
            break;
        default:
            [self storeMessage:[XMNWebViewConsoleMessage messageWithMessage:message type:type level:level source:source url:url line:line column:column]];
            break;
    }
}

- (void)logMessage:(NSString *)message
             level:(XMNWebViewConsoleMessageLevel)level
            source:(XMNWebViewConsoleMessageSource)source
            caller:(NSString *)caller {
    
    [self storeMessage:[XMNWebViewConsoleMessage messageWithMessage:message level:level source:source caller:caller]];
}

- (void)logCommandMessage:(NSString *)message {
    
    [self storeMessage:[XMNWebViewConsoleMessage messageWithMessage:message
                                                              type:XMNWebViewConsoleMessageTypeLog
                                                             level:XMNWebViewConsoleMessageLevelLog
                                                            source:XMNWebViewConsoleMessageSourceUserCommand]];
    
    NSString * encoded = [[message dataUsingEncoding:NSUTF8StringEncoding] base64Encoding]; // base64 encode
    
    NSString * js = [NSString stringWithFormat:@"__WeiboConsoleEvalResult = eval(decodeURIComponent(escape(window.atob('%@'))));", encoded];
    js = [js stringByAppendingString:@"window.pretty(__WeiboConsoleEvalResult);"];
    
    __weak typeof(*&self) wSelf = self;
    [self.webController xmn_evaluateJavaScript:js
                               completionBlock:^(NSString * _Nullable result, NSError * _Nullable error) {
                                  
                                   __strong typeof(*&wSelf) self = wSelf;
                                   if (!result) {
                                       return ;
                                   }
                                   NSString * message = result;
                                   if (![result isKindOfClass:[NSString class]]) {
                                       message = [result xmn_JSONString];
                                   }
                                   if ([message isKindOfClass:[NSString class]]) {
                                       
                                       if ([message hasSuffix:@"\n"]) {
                                           message = [message substringToIndex:message.length - 1];
                                       }
                                       [self logMessage:message
                                                   type:XMNWebViewConsoleMessageTypeLog
                                                  level:XMNWebViewConsoleMessageLevelLog
                                                 source:XMNWebViewConsoleMessageSourceUserCommandResult];
                                   }
                               }];
}

- (void)storeMessage:(XMNWebViewConsoleMessage *)message {
    
    if (!message) {
        return;
    }
    [_messages addObject:message];
    [[NSNotificationCenter defaultCenter] postNotificationName:XMNWebViewConsoleDidAddMessageNotification object:self];
}

#pragma mark - Getter

- (NSArray *)messages {
    
    return _messages;
}

- (NSArray *)clearedMessages {
    
    return _clearedMessages;
}

- (NSString *)javaScriptSource {
    
    if (!_javaScriptSource) {
        
        NSString * js = [NSString stringWithContentsOfFile:[XMNWebConsoleBundle() pathForResource:@"xmnconsole" ofType:@"js"]
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
        
        NSString * interface = self.webController.JSBridge.interfaceName;
        
        NSMutableDictionary * config = [NSMutableDictionary dictionary];
        if (interface) {
            config[@"bridge"] = interface;
        }
        js = [js stringByAppendingFormat:@"(%@)", config.xmn_JSONString];
        _javaScriptSource = [js copy];
    }
    return _javaScriptSource;
}

@end
