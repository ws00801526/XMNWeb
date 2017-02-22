//
//  XMNTextView.m
//  Pods
//
//  Created by XMFraker on 17/2/21.
//
//

#import "XMNTextView.h"

@interface XMNTextView () {
    
    struct { unsigned int inited: 1 } _flags;
}

@property (assign, nonatomic) CGFloat contentHeight;

@property (strong, nonatomic) UILabel *placeHolderLabel;

- (void)showPlaceHolder:(BOOL)show;

@end


@implementation XMNTextView
@synthesize wraperWithScrollView = _wraperWithScrollView;
@dynamic placeHolderFont;
@dynamic placeHolderColor;
@dynamic placeHolder;

#pragma mark - Life Cycle

- (instancetype)init {
    
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    _flags.inited = YES;
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setup];
    }
    _flags.inited = YES;
    return self;
}

- (CGSize)intrinsicContentSize {
    
    return CGSizeMake(self.bounds.size.width, self.contentHeight);
}

#pragma mark - Override Method

- (void)didMoveToSuperview {
    
    if (self.superview && [self.superview isKindOfClass:[UIScrollView class]]) {
        self.wraperWithScrollView = YES;
    }else {
        self.wraperWithScrollView = NO;
    }
}

- (void)layoutSubviews {

    [super layoutSubviews];
    [self showPlaceHolder:(self.text.length == 0)];
}

- (void)scrollRangeToVisible:(NSRange)range {
 
    CGRect rect = [self caretRectForPosition:self.selectedTextRange.start];
    [self scrollRectToVisible:rect animated:NO];
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
    
    if (self.isWraperWithScrollView && [self.superview isKindOfClass:[UIScrollView class]]) {
       
        UIScrollView * superScrollView = (UIScrollView *)self.superview;
        CGRect rectInsuperView = [self convertRect:rect toView:superScrollView];
        CGRect result = CGRectInset(rectInsuperView, 0, -20);
        result = CGRectIntersection(result, self.frame);
        
        if (CGRectIsNull(result)) result = rectInsuperView;
        
        [(UIScrollView *)self.superview scrollRectToVisible:result animated:animated];
    }else {
        [super scrollRectToVisible:rect animated:animated];
    }
}

#pragma mark - Public Method

#pragma mark - Private Method

- (void)setup {
 
    self.font = [UIFont systemFontOfSize:14.f];
    self.contentHeight = self.minHeight = self.font.lineHeight;
    self.maxHeight = CGFLOAT_MAX;
    
    [super setDelegate:(id<UITextViewDelegate>)self];
    
    [self showPlaceHolder:(self.text.length == 0)];
}

- (void)showPlaceHolder:(BOOL)show {
    
    if (show) {
        
        self.placeHolderLabel.hidden = NO;
        [self bringSubviewToFront:self.placeHolderLabel];
        self.placeHolderLabel.userInteractionEnabled = NO;
        self.placeHolderLabel.frame = CGRectMake(self.textContainerInset.left + 8.f, self.textContainerInset.top, self.bounds.size.width - 2 * self.textContainerInset.left - 16.f, 30.f);
        CGRect frame = self.placeHolderLabel.frame;
        frame.size.height = [self.placeHolderLabel.text sizeWithFont:self.placeHolderFont
                                                   constrainedToSize:CGSizeMake(self.placeHolderLabel.frame.size.width, self.maxHeight)].height;
        self.placeHolderLabel.frame = frame;
    }else {
        
        self.placeHolderLabel.hidden = YES;
    }
}

- (void)resizeTextView:(NSInteger)height {
    
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textView:willChangeHeight:)]) {
        [self.textDelegate textView:self willChangeHeight:height];
    }
    self.contentHeight = height;
    [self invalidateIntrinsicContentSize];
}

- (void)textViewDidChangedContentSize {
    
    if (!_flags.inited) {
        return;
    }
    //size of content, so we can set the frame of self
    //+ self.textContainerInset.bottom 方便每次换行滚动到最下方
    NSInteger newSizeH = self.contentSize.height + self.textContainerInset.bottom;
    
    newSizeH = MAX(newSizeH, self.minHeight);
    
    if (self.frame.size.height >= self.maxHeight && newSizeH >= self.maxHeight) {
        newSizeH = self.maxHeight;                                               // not taller than maxHeight
    }
    
    if (self.frame.size.height != newSizeH) {

        self.wraperWithScrollView = (newSizeH < self.maxHeight);
        
        if (newSizeH > self.maxHeight && self.frame.size.height <= self.maxHeight) {
            
            newSizeH = self.maxHeight;
        }
        
        if (newSizeH <= self.maxHeight) {
            
            [self resizeTextView:newSizeH];
            
            if (self.isAnimateHeightChange) {
                [UIView animateWithDuration:.2f
                                      delay:0
                                    options:(UIViewAnimationOptionAllowUserInteraction |
                                             UIViewAnimationOptionBeginFromCurrentState)
                                 animations:^(void) {
                                     [self.superview layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished) {
                                   
                                     if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textViewHeightDidChanged:)]) {
                                         [self.textDelegate textViewHeightDidChanged:self];
                                     }
                                 }
                 ];
            } else {
                [self.superview layoutIfNeeded];
                if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textViewHeightDidChanged:)]) {
                    [self.textDelegate textViewHeightDidChanged:self];
                }
            }
        }
    }
}

#pragma mark - Setter

- (void)setFont:(UIFont *)font {
    
    [super setFont:font];
    if (!self.placeHolderFont) {
        self.placeHolderFont = font;
    }
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    
    if ([delegate conformsToProtocol:@protocol(XMNTextViewDelegate)]) {
        self.textDelegate = delegate;
    }
}

- (void)setMinHeight:(NSInteger)minHeight {
    
    _minHeight = minHeight;
    self.contentHeight = minHeight;
}

- (void)setMaxHeight:(NSInteger)maxHeight {
    
    _maxHeight = MAX(maxHeight, self.minHeight);
}

- (void)setContentHeight:(CGFloat)contentHeight {
    
    _contentHeight = contentHeight;
    [self invalidateIntrinsicContentSize];
}

- (void)setMinNumberOfLines:(NSInteger)minNumberOfLines {
    
    NSString *newText = @"|W中|";
    
    for (int i = 1; i < minNumberOfLines; ++i) {
        newText = [newText stringByAppendingString:@"\n|W中|"];
    }
    
    CGRect rect = [newText boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:self.font}
                                        context:nil];
    self.minHeight = rect.size.height;
    self.minHeight += (self.textContainerInset.top + self.textContainerInset.bottom);
    _minNumberOfLines = minNumberOfLines;
}

- (void)setMaxNumberOfLines:(NSInteger)maxNumberOfLines {
    
    NSString *newText = @"|W中|";
    for (int i = 1; i < maxNumberOfLines; ++i) {
        newText = [newText stringByAppendingString:@"\n|W中|"];
    }
    CGRect rect = [newText boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:self.font}
                                        context:nil];
    self.maxHeight = rect.size.height;
    self.maxHeight += (self.textContainerInset.top + self.textContainerInset.bottom);
    _maxNumberOfLines = maxNumberOfLines;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    
    [super setContentInset:contentInset];
    [self textViewDidChangedContentSize];
    [self showPlaceHolder:(self.text.length == 0)];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    
    if (self.isWraperWithScrollView) {
        [super setContentOffset:CGPointMake(-self.contentInset.left, -self.contentInset.top)];
    } else {
        [super setContentOffset:contentOffset];
    }
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    
    if (self.isWraperWithScrollView) {
        [super setContentOffset:CGPointMake(-self.contentInset.left, -self.contentInset.top) animated:NO];
    }else {
        [super setContentOffset:contentOffset animated:animated];
    }
}

- (void)setContentSize:(CGSize)contentSize {
    
    if (contentSize.height < self.font.lineHeight) {
        return;
    }
    BOOL changed = ABS(self.contentSize.height - contentSize.height) > 0.01;
    [super setContentSize:contentSize];
    
    if (changed) {
        [self textViewDidChangedContentSize];
    }
    if (self.isFirstResponder) {
        [self scrollRangeToVisible:self.selectedRange];
    }
}

- (void)setWraperWithScrollView:(BOOL)wraperWithScrollView {
    
    _wraperWithScrollView = wraperWithScrollView;
    if (wraperWithScrollView) {
        
        self.bounces = NO;
        self.showsVerticalScrollIndicator = self.showsHorizontalScrollIndicator = NO;
    }else {
        
        self.bounces = YES;
        self.showsVerticalScrollIndicator = YES;
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    
    self.placeHolderLabel.text = placeHolder;
}

- (void)setPlaceHolderFont:(UIFont *)placeHolderFont {
    
    self.placeHolderLabel.font = placeHolderFont;
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    
    self.placeHolderLabel.textColor = placeHolderColor;
}

#pragma mark - Getter

- (BOOL)isWraperWithScrollView {
    
    return _wraperWithScrollView;
}

- (NSString *)placeHolder {
    
    return self.placeHolderLabel.text;
}

- (UIColor *)placeHolderColor {
    
    return self.placeHolderLabel.textColor;
}

- (UIFont *)placeHolderFont {
    
    return self.placeHolderLabel.font;
}

- (UILabel *)placeHolderLabel {
    
    if (!_placeHolderLabel) {
        
        CGRect frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
        frame = UIEdgeInsetsInsetRect(frame, self.textContainerInset);

        _placeHolderLabel = [[UILabel alloc] initWithFrame:frame];
        _placeHolderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = self.font;
        [self addSubview:_placeHolderLabel];
        _placeHolderLabel.hidden = YES;
        _placeHolderLabel.isAccessibilityElement = NO;
    }
    return _placeHolderLabel;
}

@end



#pragma mark - XMNTextView (UITextViewDelegate)
@interface XMNTextView (UITextViewDelegate) <UITextViewDelegate>

@end

@implementation XMNTextView (UITextViewDelegate)

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.textDelegate textViewShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.textDelegate textViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.textDelegate textViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.textDelegate textViewDidEndEditing:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.textDelegate textView:self shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [self showPlaceHolder:textView.text.length == 0];
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        
        [self.textDelegate textViewDidChange:self];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.textDelegate textViewDidChangeSelection:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
        return [self.textDelegate textView:self shouldInteractWithURL:URL inRange:characterRange];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]) {
        return [self.textDelegate textView:self shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0) {
    
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:interaction:)]) {
        
        return [self.textDelegate textView:self shouldInteractWithURL:URL inRange:characterRange interaction:interaction];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0) {
    
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:interaction:)]) {
        
        return [self.textDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange interaction:interaction];
    }
    return YES;
}
@end
