//
//  XMNWebViewConsole.h
//  Pods
//
//  Created by XMFraker on 17/2/20.
//
//

#import <UIKit/UIKit.h>
#import "XMNWebController.h"
#import "XMNWebViewConsoleMessage.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const XMNWebViewConsoleDidAddMessageNotification;
UIKIT_EXTERN NSString * const XMNWebViewConsoleDidClearMessagesNotification;
UIKIT_EXTERN NSString * const XMNWebViewConsoleLastSelectionElementName;

@interface XMNWebViewConsole : NSObject

@property (nonatomic, strong, readonly) NSArray<XMNWebViewConsoleMessage *> * messages;
@property (nonatomic, strong, readonly) NSArray<XMNWebViewConsoleMessage *> * clearedMessages;
@property (nonatomic, weak, readonly) __kindof XMNWebController *webController;

@property (copy, nonatomic, readonly)   NSString *javaScriptSource;


/**
 初始化方法, 获得一个JSBridge实例
 当JSBridge实例初始化完成后,  JSBridge.javaScriptSource 会被添加到webController.webView中
 
 @param webController 使用JSBridge的webController
 @return JSBridge 实例
 */
- (instancetype)initWithWebController:(__kindof XMNWebController *)webController NS_DESIGNATED_INITIALIZER;


/**
 清除当前控制台已经存储的日志信息
 */
- (void)clearMesssages;


/**
 记录一条日志信息到控制台

 @param message     消息内容
 @param type        消息类型
 @param level       消息日志级别
 @param source      消息来源
 */
- (void)logMessage:(NSString *)message
              type:(XMNWebViewConsoleMessageType)type
             level:(XMNWebViewConsoleMessageLevel)level
            source:(XMNWebViewConsoleMessageSource)source;


/**
 记录一条日志到控制台

 @param message    日志内容
 @param type       日志类型
 @param level      日志级别
 @param source     日志来源
 @param url        日志url地址
 @param line       日志行号
 @param column     日志column标号
 */
- (void)logMessage:(NSString *)message
              type:(XMNWebViewConsoleMessageType)type
             level:(XMNWebViewConsoleMessageLevel)level
            source:(XMNWebViewConsoleMessageSource)source
               url:(NSString *)url
              line:(NSInteger)line
            column:(NSInteger)column;


/**
 记录一条日志到控制台

 @param message    日志内容
 @param level      日志级别
 @param source     日志来源
 @param caller     日志发送者
 */
- (void)logMessage:(NSString *)message
             level:(XMNWebViewConsoleMessageLevel)level
            source:(XMNWebViewConsoleMessageSource)source
            caller:(NSString *)caller;

/**
 记录一条控制台命令日志

 @param message 命令内容
 */
- (void)logCommandMessage:(NSString *)message;

@end


@interface XMNWebViewConsole (XMNWebDeprecated)

- (instancetype)init OBJC_UNAVAILABLE("use initWithWebController:");

@end

inline static NSBundle * XMNWebConsoleBundle()
{
    return [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/%@", [NSBundle bundleForClass:[XMNWebViewConsole class]].bundlePath, @"XMNWebConsole.bundle"]];
}
NS_ASSUME_NONNULL_END
