//
//  XMNWebViewConsoleMessage.m
//  Pods
//
//  Created by XMFraker on 17/2/20.
//
//

#import "XMNWebViewConsoleMessage.h"

@interface XMNWebViewConsoleMessage ()

@property (nonatomic) XMNWebViewConsoleMessageSource source;
@property (nonatomic) XMNWebViewConsoleMessageType type;
@property (nonatomic) XMNWebViewConsoleMessageLevel level;
@property (nonatomic, strong) NSString * message;

@property (nonatomic) NSInteger line;
@property (nonatomic) NSInteger column;
@property (nonatomic, strong) NSString * url;

@property (nonatomic, strong) NSString * caller;

@end

@implementation XMNWebViewConsoleMessage

#pragma mark - Life Cycle

+ (instancetype)messageWithMessage:(NSString *)message
                              type:(XMNWebViewConsoleMessageType)type
                             level:(XMNWebViewConsoleMessageLevel)level
                            source:(XMNWebViewConsoleMessageSource)source {
    
    return [self messageWithMessage:message type:type level:level source:source url:nil line:0 column:0];
}

+ (instancetype)messageWithMessage:(NSString *)message
                              type:(XMNWebViewConsoleMessageType)type
                             level:(XMNWebViewConsoleMessageLevel)level
                            source:(XMNWebViewConsoleMessageSource)source
                               url:(NSString *)url
                              line:(NSInteger)line
                            column:(NSInteger)column {
    
    XMNWebViewConsoleMessage *ret = [[XMNWebViewConsoleMessage alloc] init];
    ret.source = source;
    ret.type = type;
    ret.level = level;
    ret.message = message;
    ret.line = line;
    ret.column = column;
    ret.url = url;
    
    ret.caller = ret.defaultCaller;
    return ret;
}

+ (instancetype)messageWithMessage:(NSString *)message
                             level:(XMNWebViewConsoleMessageLevel)level
                            source:(XMNWebViewConsoleMessageSource)source
                            caller:(NSString *)caller {
    
    XMNWebViewConsoleMessage *ret = [[XMNWebViewConsoleMessage alloc] init];
    ret.source = source;
    ret.level = level;
    ret.message = message;
    ret.caller = caller;
    return ret;
}

#pragma mark - Getter

- (NSString *)caller {
    
    return (_caller && _caller.length) ? _caller : self.defaultCaller;
}

@end

@implementation XMNWebViewConsoleMessage (XMNCaller)

- (NSString *)defaultCaller {
    
    if (!self.url || !self.url.length) {
        
        return nil;
    }

    NSString * filename = nil;
    NSURL * url = [NSURL URLWithString:_url];
    if (url) {
        filename = [url.path lastPathComponent];
    } else  {
        filename = [[_url componentsSeparatedByString:@"/"] lastObject];
    }
    
    if (!_line) return filename;
    
    return [NSString stringWithFormat:@"%@:%ld", filename, (long)_line];
}

@end
