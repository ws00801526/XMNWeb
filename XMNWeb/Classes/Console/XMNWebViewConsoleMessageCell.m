//
//  XMNWebViewConsoleMessageCell.m
//  Pods
//
//  Created by XMFraker on 17/2/20.
//
//

#import "XMNWebViewConsoleMessageCell.h"
#import "XMNWebViewConsoleMessage.h"

#import "XMNWebViewConsole.h"

@interface XMNWebViewConsoleMessageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *callerLabel;

@property (strong, nonatomic) XMNWebViewConsoleMessage *message;

@end

@implementation XMNWebViewConsoleMessageCell


#pragma mark - Override Method

- (void)awakeFromNib {
    
    [super awakeFromNib];
    UIView * selectionView = [[UIView alloc] initWithFrame:CGRectZero];
    selectionView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.selectedBackgroundView = selectionView;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    return (action == @selector(copy:));
}

#pragma mark - Public Method

- (void)configCellWithMessage:(XMNWebViewConsoleMessage *)message {
    
    self.message = message;
    
    self.messageLabel.text = message.message;
    self.callerLabel.text = message.caller;
    [self updateMessageCellStyle];
}

#pragma mark - Private Method

- (void)updateMessageCellStyle {
    
    UIColor * color = nil;
    NSString * iconName = nil;
    UIColor * callerColor = [UIColor grayColor];
    
    if (self.cleared) {
        
        color = [UIColor colorWithWhite:0.0 alpha:0.2];
        callerColor = [UIColor colorWithWhite:0.0 alpha:0.15];
    } else {
        XMNWebViewConsoleMessageLevel level = _message.level;
        XMNWebViewConsoleMessageSource source = _message.source;
        
        if (source == XMNWebViewConsoleMessageSourceUserCommand) {
            color = [UIColor colorWithRed:77/255.f green:153/255.f blue:255/255.f alpha:1.f];
            iconName = @"userinput_prompt_previous";
        } else if (source == XMNWebViewConsoleMessageSourceUserCommandResult) {

            color = [UIColor colorWithRed:0/255.f green:80/255.f blue:255/255.f alpha:1.f];
            iconName = @"userinput_result";
        } else {
            switch (level) {
                case XMNWebViewConsoleMessageLevelDebug:
                    color = [UIColor blueColor];
                    iconName = @"debug_icon";
                    break;
                case XMNWebViewConsoleMessageLevelError:
                    color = [UIColor redColor];
                    iconName = @"error_icon";
                    break;
                case XMNWebViewConsoleMessageLevelWarning:
                    color = [UIColor blackColor];
                    iconName = @"issue_icon";
                    if (source == XMNWebViewConsoleMessageSourceNavigation) {
                        iconName = @"navigation_issue_icon";
                        color = [UIColor colorWithRed:246/255.f green:187/255.f blue:14/255.f alpha:1.f];
                    }
                    break;
                case XMNWebViewConsoleMessageLevelNone:
                    color = [UIColor colorWithWhite:0.0 alpha:0.2];
                    break;
                case XMNWebViewConsoleMessageLevelInfo:
                    color = [UIColor colorWithWhite:0.0 alpha:0.5];
                    iconName = @"info_icon";
                    break;
                case XMNWebViewConsoleMessageLevelSuccess:
                    color = [UIColor colorWithRed:0/255.f green:148/255.f blue:10/255.f alpha:1.f];
                    iconName = @"success_icon";
                    if (source == XMNWebViewConsoleMessageSourceNavigation) {
                        iconName = @"navigation_success_icon";
                    }
                    break;
                case XMNWebViewConsoleMessageLevelLog:
                default:
                    color = [UIColor blackColor];
                    break;
            }
        }
        
        if ([_message.message isEqual:@"undefined"] ||
            [_message.message isEqual:@"null"])
        {
            if (source != XMNWebViewConsoleMessageSourceUserCommand)
            {
                color = [UIColor colorWithWhite:0.0 alpha:0.3];
                callerColor = [UIColor colorWithWhite:0.0 alpha:0.2];
            }
        }
    }
    
    self.messageLabel.textColor = color;
    self.callerLabel.textColor = callerColor;
    self.iconImageView.image = nil;
    
    if (iconName) {
        NSString *iconPath = [XMNWebConsoleBundle() pathForResource:[iconName stringByAppendingString:@"@2x"] ofType:@"png"];
        self.iconImageView.image = [UIImage imageWithContentsOfFile:iconPath];
    }
}

#pragma mark - Setter

- (void)setCleared:(BOOL)cleared {
    
    if (_cleared == cleared) {
        return;
    }
    _cleared = cleared;
    [self updateMessageCellStyle];
}

@end
