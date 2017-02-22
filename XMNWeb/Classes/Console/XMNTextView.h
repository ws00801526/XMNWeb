//
//  XMNTextView.h
//  Pods
//
//  Created by XMFraker on 17/2/21.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMNTextView;
@protocol XMNTextViewDelegate <UITextViewDelegate>

@optional
- (void)textViewHeightDidChanged:(XMNTextView *)textView;
- (void)textView:(XMNTextView *)textView willChangeHeight:(NSInteger)height;

@end

/**
 带有placeholder的 textView

 */
IB_DESIGNABLE
@interface XMNTextView : UITextView

/** palceHolder 字体 */
@property (strong, nonatomic, nullable) UIFont *placeHolderFont;
/** placeHolder 字体颜色 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *placeHolderColor;
/** placeHolder 文字 */
@property (copy, nonatomic, nullable) IBInspectable  NSString *placeHolder;

/** 替换delegate */
@property (weak, nonatomic, nullable)   id<XMNTextViewDelegate> textDelegate;

/** textView最小行数 */
@property (assign, nonatomic) NSInteger maxNumberOfLines;

/** textView 最大行数 */
@property (assign, nonatomic) NSInteger minNumberOfLines;

/** textView 最小高度 默认font.lineHeight */
@property (assign, nonatomic) IBInspectable NSInteger minHeight;

/** textView 最大高度 */
@property (assign, nonatomic) IBInspectable NSInteger maxHeight;

/** textView 高度发生变化时, 是否显示动画效果 */
@property (assign, nonatomic, getter=isAnimateHeightChange) IBInspectable BOOL animateHeightChange;

/** textView 是否处于scrollView中  或者当前高度>= maxHeight */
@property (assign, nonatomic, getter=isWraperWithScrollView) IBInspectable BOOL wraperWithScrollView;

@end

NS_ASSUME_NONNULL_END
