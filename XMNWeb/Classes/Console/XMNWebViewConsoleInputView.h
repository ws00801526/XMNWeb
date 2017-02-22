//
//  XMNWebViewConsoleInputView.h
//  Pods
//
//  Created by XMFraker on 17/2/21.
//
//

#import <UIKit/UIKit.h>
#import "XMNTextView.h"

@class XMNWebViewConsole;
@interface XMNWebViewConsoleInputView : UIView

@property (copy, nonatomic)   NSString *text;
@property (strong, nonatomic) XMNWebViewConsole *console;

@property (strong, nonatomic, readonly) XMNTextView *textView;

@end
