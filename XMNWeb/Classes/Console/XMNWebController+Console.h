//
//  XMNWebController+Console.h
//  Pods
//
//  Created by XMFraker on 17/2/20.
//
//


#import "XMNWebViewConsole.h"

@interface XMNWebController (Console)

/** 当前webController拥有的控制台console */
@property (strong, nonatomic, readonly) XMNWebViewConsole *console;

/**
 为XMNWebController配置一个console

 @param console 配置的console
 */
- (void)xmn_configConsole:(XMNWebViewConsole *)console;

@end
