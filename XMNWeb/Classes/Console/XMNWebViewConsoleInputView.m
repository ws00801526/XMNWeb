//
//  XMNWebViewConsoleInputView.m
//  Pods
//
//  Created by XMFraker on 17/2/21.
//
//

#import "XMNWebViewConsoleInputView.h"
#import "XMNTextView.h"

#import "XMNWebViewConsole.h"

#import "NSObject+XMNJSONKit.h"

@interface XMNWebViewConsoleInputView () <XMNTextViewDelegate>
{
    struct { unsigned int insertNewLine: 1; } _flags;
}
@property (strong, nonatomic) UIView *topBorderView;
@property (strong, nonatomic) XMNTextView *textView;
@property (copy, nonatomic)   NSString *promptJS;

@property (copy, nonatomic)   NSArray<NSString *> *suggestions;
@property (strong, nonatomic) UITableView *promptTableView;

@end

@implementation XMNWebViewConsoleInputView
@dynamic text;

#pragma mark - Life Cycle

- (instancetype)init {
    
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setup];
    }
    return self;
}

#pragma mark - Override Method

- (CGSize)intrinsicContentSize {
    
    return [self.textView intrinsicContentSize];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.topBorderView.frame = CGRectMake(0, 0, self.bounds.size.width, 1.f/[UIScreen mainScreen].scale);
    self.textView.frame = self.bounds;
}

#pragma mark - Private Method

- (void)setup {
    
    self.backgroundColor = [UIColor whiteColor];
    self.topBorderView = [[UIView alloc] init];
    self.topBorderView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.2f];
    
    self.textView = [[XMNTextView alloc] initWithFrame:CGRectZero];
    self.textView.minHeight = 44.f;
    self.textView.maxHeight = 120.f;
    self.textView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
    self.textView.placeHolder = @"input something";
    self.textView.placeHolderColor = [UIColor lightGrayColor];
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.delegate = self;
    self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self addSubview:self.textView];
    [self addSubview:self.topBorderView];
}


- (void)commitCurrentCommand {
    
    NSString * command = _textView.text;
    
    /** 不符合字符集,过滤 */
    if (![command stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) return;
    
//    WBWebViewConsoleInputHistoryEntry * emptyEntry = [WBWebViewConsoleInputHistoryEntry new]; // not actual +[ emptyEntry];
//    WBWebViewConsoleInputHistoryEntry * historyEntry = [self historyEntryForCurrentText];
//    
//    // Replace the previous entry if it does not have text or if the text is the same.
//    WBWebViewConsoleInputHistoryEntry * previousEntry = [self historyEntryAtIndex:1];
//    if (!previousEntry.isEmpty && (!previousEntry.text.length || [previousEntry.text isEqual:historyEntry.text]))
//    {
//        _history[1] = historyEntry;
//        _history[0] = emptyEntry;
//    }
//    else
//    {
//        // Replace the first history entry and push a new empty one.
//        _history[0] = historyEntry;
//        [_history insertObject:emptyEntry atIndex:0];
//        
//        // Trim the history length if needed.
//        if (_history.count > WBWebViewConsoleInputMaxHistorySize)
//        {
//            [_history removeObjectsInRange:NSMakeRange(WBWebViewConsoleInputMaxHistorySize, _history.count - WBWebViewConsoleInputMaxHistorySize)];
//        }
//    }
//    
//    _historyIndex = 0;
    _textView.text = nil;

    /** 发送命令 */
    [self.console logCommandMessage:command];
    
//
//    if ([_delegate respondsToSelector:@selector(consoleInputView:didCommitCommand:)])
//    {
//        [_delegate consoleInputView:self didCommitCommand:command];
//    }
}


- (void)fetchSuggestionsWithPrompt:(NSString *)prompt
                       cursorIndex:(NSInteger)cursorIndex
                        completion:(void (^)(NSArray * suggestions, NSRange replacementRange))completion {
    
    if (!completion) return;
    
    void (^failedBlock)(void) = ^{
        completion(nil, NSMakeRange(NSNotFound, 0));
    };
    
    if (!self.console) {
        failedBlock();
        return;
    }
    
    if (!prompt.length) {
        failedBlock();
        return;
    }
    
    NSString * js = self.promptJS;
    js = [js stringByAppendingFormat:@"('%@', %ld)", [[prompt dataUsingEncoding:NSUTF8StringEncoding] base64Encoding], (long)cursorIndex];
    
    
    
    [self.console.webController xmn_evaluateJavaScript:js
                                       completionBlock:^(NSString * _Nullable result, NSError * _Nullable error) {
       
                                           if (![result isKindOfClass:[NSString class]]) {
                                               failedBlock();
                                               return;
                                           }
                                           NSDictionary * resultDict = [result xmn_objectFromJSONString];
                                           NSArray * suggestions = resultDict[@"completions"];
                                           NSInteger tokenStart = resultDict[@"token_start"];
                                           NSInteger tokenEnd = resultDict[@"token_end"];
                                           
                                           if (![suggestions isKindOfClass:[NSArray class]] || !suggestions.count) {
                                               failedBlock();
                                               return;
                                           }
                                           completion(suggestions, NSMakeRange(tokenStart, tokenEnd - tokenStart));

    }];
}

#pragma mark - XMNTextViewDelegate

- (void)textViewHeightDidChanged:(XMNTextView *)textView {
    
    [self invalidateIntrinsicContentSize];
    [UIView animateWithDuration:.3 animations:^{
        [self.superview layoutIfNeeded];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"] && !_flags.insertNewLine) {
        /** 监听换行符,并且不是新增一行 */
        [self commitCurrentCommand];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length && textView.selectedRange.length == 0 && textView.isFirstResponder) {

        [self fetchSuggestionsWithPrompt:self.text
                             cursorIndex:textView.selectedRange.location
                              completion:^(NSArray *suggestions, NSRange replacementRange) {
                                  
                                  NSLog(@"this is suggestions :%@", suggestions);
                              }];
    }
}

#pragma mark - Setter

- (void)setText:(NSString *)text {
    
    self.textView.text = text;
}

#pragma mark - Getter

- (NSString *)text {
    
    return self.textView.text;
}

- (NSArray <UIKeyCommand *> *)keyCommands {
    
    {
//        UIKeyCommand * up = [UIKeyCommand keyCommandWithInput:UIKeyInputUpArrow modifierFlags:0 action:@selector(handlePreviousKey:)];
//        UIKeyCommand * down = [UIKeyCommand keyCommandWithInput:UIKeyInputDownArrow modifierFlags:0 action:@selector(handleNextKey:)];
//        UIKeyCommand * newline = [UIKeyCommand keyCommandWithInput:@"\r" modifierFlags:UIKeyModifierControl action:@selector(insertNewline:)]; // control+enter key
        
    }
    return  nil;
}


- (NSString *)promptJS {
    
    if (!_promptJS) {
        NSString * jsPath = [XMNWebConsoleBundle() pathForResource:@"xmn_console_prompt" ofType:@"js"];
        NSString * js = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:NULL];
        _promptJS = js;
    }
    return _promptJS;
}

@end
