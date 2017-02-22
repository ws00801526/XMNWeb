//
//  XMNWebViewConsoleMessageCell.h
//  Pods
//
//  Created by XMFraker on 17/2/20.
//
//

#import <UIKit/UIKit.h>

@class XMNWebViewConsoleMessage;
@interface XMNWebViewConsoleMessageCell : UITableViewCell

@property (strong, nonatomic, readonly) XMNWebViewConsoleMessage *message;

/** 是否是已经被清楚的message */
@property (assign, nonatomic) BOOL cleared;

/**
 配置MessageCell

 @param message 需要显示的消息
 */
- (void)configCellWithMessage:(XMNWebViewConsoleMessage *)message;

@end
