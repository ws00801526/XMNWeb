//
//  XMNWebViewConsoleMessage.h
//  Pods
//
//  Created by XMFraker on 17/2/20.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XMNWebViewConsoleMessageSource)
{
    XMNWebViewConsoleMessageSourceJS = 0,
    XMNWebViewConsoleMessageSourceNavigation,
    XMNWebViewConsoleMessageSourceUserCommand,
    XMNWebViewConsoleMessageSourceUserCommandResult,
    XMNWebViewConsoleMessageSourceNative,
};

typedef NS_ENUM(NSInteger, XMNWebViewConsoleMessageType)
{
    XMNWebViewConsoleMessageTypeLog = 0,
    XMNWebViewConsoleMessageTypeClear,
    XMNWebViewConsoleMessageTypeAssert,
};

typedef NS_ENUM(NSInteger, XMNWebViewConsoleMessageLevel)
{
    XMNWebViewConsoleMessageLevelNone = 0,
    XMNWebViewConsoleMessageLevelLog = 1,
    XMNWebViewConsoleMessageLevelWarning = 2,
    XMNWebViewConsoleMessageLevelError = 3,
    XMNWebViewConsoleMessageLevelDebug = 4,
    XMNWebViewConsoleMessageLevelInfo = 5,
    XMNWebViewConsoleMessageLevelSuccess = 6,
};

NS_ASSUME_NONNULL_BEGIN

@interface XMNWebViewConsoleMessage : NSObject

/** 消息来源 */
@property (nonatomic, readonly) XMNWebViewConsoleMessageSource source;
/** 消息类型 */
@property (nonatomic, readonly) XMNWebViewConsoleMessageType type;
/** 消息日志级别 */
@property (nonatomic, readonly) XMNWebViewConsoleMessageLevel level;

/** 消息内容 */
@property (nonatomic, strong, readonly) NSString * message;

@property (nonatomic, assign, readonly) NSInteger line;
@property (nonatomic, assign, readonly) NSInteger column;

@property (nonatomic, strong, readonly, nullable) NSString * url;

/** 消息发送者 */
@property (nonatomic, strong, readonly) NSString * caller;


/**
 初始化XMNWebViewConsoleMessage消息实例

 @param message     消息内容
 @param type        消息类型
 @param level       消息日志级别
 @param source      消息来源
 @return    XMNWebViewConsoleMessage 实例
 */
+ (instancetype)messageWithMessage:(NSString *)message
                              type:(XMNWebViewConsoleMessageType)type
                             level:(XMNWebViewConsoleMessageLevel)level
                            source:(XMNWebViewConsoleMessageSource)source;


/**
 初始化XMNWebViewConsoleMessage消息实例

 @param message     消息内容
 @param type        消息类型
 @param level       消息日志级别
 @param source      消息来源
 @param url         消息url地址
 @param line        消息所在列
 @param column      消息所在行号
 @return    XMNWebViewConsoleMessage 实例
 */
+ (instancetype)messageWithMessage:(NSString *)message
                              type:(XMNWebViewConsoleMessageType)type
                             level:(XMNWebViewConsoleMessageLevel)level
                            source:(XMNWebViewConsoleMessageSource)source
                               url:(nullable NSString *)url
                              line:(NSInteger)line
                            column:(NSInteger)column;


/**
 初始化XMNWebViewConsoleMessage消息实例
 
 @param message     消息内容
 @param level       消息日志级别
 @param source      消息来源
 @param caller      消息触发者
 @return    XMNWebViewConsoleMessage 实例
 */
+ (instancetype)messageWithMessage:(NSString *)message
                             level:(XMNWebViewConsoleMessageLevel)level
                            source:(XMNWebViewConsoleMessageSource)source
                            caller:(NSString *)caller;

@end


@interface XMNWebViewConsoleMessage (XMNCaller)

@property (copy, nonatomic, readonly)   NSString *defaultCaller;

@end

NS_ASSUME_NONNULL_END
