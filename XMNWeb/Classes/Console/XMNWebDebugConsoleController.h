//
//  XMNWebDebugConsoleController.h
//  Pods
//
//  Created by XMFraker on 17/2/20.
//
//

#import <UIKit/UIKit.h>

@class XMNWebViewConsole;
@interface XMNWebDebugConsoleController : UIViewController

/** 控制台对应的控制日志 */
@property (nonatomic, strong, readonly) XMNWebViewConsole * console;
/** 初始化命令 */
@property (nonatomic, strong) NSString * initialCommand;

/**
 初始化XMNWebDebugConsoleController控制台实例

 @param console 控制器
 @return XMNWebDebugConsoleController 实例
 */
- (instancetype)initWithConsole:(XMNWebViewConsole *)console;

@end

@interface XMNWebDebugConsoleController (Deprecated)

- (instancetype)init OBJC_UNAVAILABLE("use initWithWebController:");
- (instancetype)initWithCoder:(NSCoder *)aDecoder OBJC_UNAVAILABLE("use initWithWebController:");

@end
