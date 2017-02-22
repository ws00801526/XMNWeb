//
//  XMNWebController.m
//  Pods
//
//  Created by XMFraker on 17/2/15.
//
//

#import "XMNWebController.h"
#import "XMNWebProgressView.h"
#import "XMNWebMacro.h"
#import <KVOController/KVOController.h>

#import "NSObject+XMNJSONKit.h"
#import "XMNWebController+XMNWebOptions.h"

#ifdef XMNBRIDGE_ENABLED
    #import "XMNWebController+JSBridge.h"
#endif

#ifdef XMNCONSOLE_ENABLED
    #import "XMNWebDebugConsoleController.h"
    #import "XMNWebController+Console.h"
#endif

static WKProcessPool *kXMNWebPool = nil;

#pragma mark - XMNWebController

@interface XMNWebController () <UIViewControllerPreviewingDelegate>

@property (strong, nonatomic) NSURL *originURL;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) XMNWebProgressView *progressView;

@property (assign, nonatomic) NSTimeInterval timeout;
@property (copy, nonatomic)   NSDictionary *customHeaders;

@end

@implementation XMNWebController
@synthesize webView = _webView;

#pragma mark - Life Cycle

+ (void)initialize {
    
    kXMNWebPool = [[WKProcessPool alloc] init];
}

- (instancetype)init {
    
    return [self initWithURL:nil options:[XMNWebController webViewOptions]];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
 
    return [self initWithURL:nil options:[XMNWebController webViewOptions]];
}

- (instancetype)initWithURL:(NSURL *)URL {
    
    return [self initWithURL:URL
                     options:[XMNWebController webViewOptions]];
}

- (instancetype)initWithURL:(NSURL *)URL
                    options:(nullable NSDictionary *)options {

    if (self = [super init]) {

        self.originURL = URL;
        [self parseWebViewOptions:options];
    }
    
#if XMNBRIDGE_ENABLED
    XMNLog(@"XMNWeb support bridge");
    [self xmn_configJSBridge:[[XMNWebViewJSBridge alloc] initWithWebController:self]];
#endif
    
#if XMNCONSOLE_ENABLED
    XMNLog(@"XMWeb support console");
    [self xmn_configConsole:[[XMNWebViewConsole alloc] initWithWebController:self]];
#endif
    
    return self;
}


#pragma mark - Override Method

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupUI];
    
    [self configWebView:self.webView];

    if (self.originURL) {
        /** 本地文件 */
        if ([self.originURL isFileURL]) {
            
            [self loadLocalURL:self.originURL];
        }else {
            
            [self loadRemoteURL:self.originURL];
        }
    }
    
    XMNLog(@"webC will loadURL :%@",self.originURL);
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"%@ viewWillAppear",NSStringFromClass([self class]));
    if (self.showProgress && !self.progressView.superview) {
        [self.navigationController.navigationBar addSubview:self.progressView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    NSLog(@"%@ viewWillDisappear",NSStringFromClass([self class]));
    /** 需要移除progressView */
    if (self.progressView.superview) {
        [self.progressView removeFromSuperview];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        [self.progressView setProgress:[change[NSKeyValueChangeNewKey] floatValue] animated:YES];
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)dealloc {

    self.showProgress = NO;
    XMNLog(@"%@  dealloc",self);
}

#pragma mark - Public Method

- (void)setupUI {
    
    [self.view addSubview:self.webView];
    [self.progressView setProgress:0.f];
}

- (void)configWebView:(WKWebView *)webView {
    
    XMNLog(@"override is you need config cookie for webView");
    
#if XMNBRIDGE_ENABLED
    [webView.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:self.JSBridge.javaScriptSource
                                                                                      injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                                                   forMainFrameOnly:NO]];
    
    
    
#endif
    
#if XMNCONSOLE_ENABLED
    
    [webView.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:self.console.javaScriptSource
                                                                                      injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                                                   forMainFrameOnly:NO]];
    
    
    NSString *prettyJSSource = [NSString stringWithContentsOfFile:[XMNWebConsoleBundle() pathForResource:@"xmn_console_pretty" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
    
    [webView.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:prettyJSSource
                                                                                      injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                                                   forMainFrameOnly:NO]];

#endif
    
    
    self.webView.allowsLinkPreview = YES;
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    self.showProgress = YES;
}

- (void)loadWithURL:(nullable NSURL *)URL {
    
    [self loadWithURL:URL
              options:nil];
}

- (void)loadWithURL:(nullable NSURL *)URL
            options:(nullable NSDictionary *)options {

    if (!URL) {
        return;
    }
    
    if (!self.originURL) {
        self.originURL = URL;
    }
    
    if (options) {
        [self parseWebViewOptions:options];
    }

    /** 本地文件 */
    if ([URL isFileURL]) {
        
        [self loadLocalURL:URL];
    }else {
        
        [self loadRemoteURL:URL];
    }
}


#pragma mark - Private Method

- (void)parseWebViewOptions:(NSDictionary *)options {
    
    self.timeout = options[XMNWebViewTimeoutKey] ? [options[XMNWebViewTimeoutKey] integerValue] : 20.f;
    
    if (options[XMNWebViewCustomHeadersKey] && [options[XMNWebViewCustomHeadersKey] isKindOfClass:[NSDictionary class]]) {
        self.customHeaders = options[XMNWebViewCustomHeadersKey];
    }
}

- (void)loadLocalURL:(NSURL *)URL {
    
    if (iOS9Later && [self.webView respondsToSelector:@selector(loadFileURL:allowingReadAccessToURL:)]) {
        
        /** 9.0+ */
        [self.webView loadFileURL:URL
          allowingReadAccessToURL:[[NSBundle mainBundle] bundleURL]];
    }else {
        
        /** 9.0- 使用loadHTML 方法加载本地文件*/
        NSError *error;
        NSString *html = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
        if (html && html.length && !error) {
            [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
        }else {
            
            NSLog(@"load local file error :%@",[error localizedDescription]);
        }
    }
}

- (void)loadRemoteURL:(NSURL *)URL {
    
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeout];
    [mutableRequest setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forHTTPHeaderField:[[NSBundle mainBundle] bundleIdentifier]];
    if (self.customHeaders) {
        [self.customHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [mutableRequest setValue:obj ? : @"invalid header" forHTTPHeaderField:key];
        }];
    }
    [self.webView loadRequest:[mutableRequest copy]];
}

#pragma mark - Setter

- (void)setShowProgress:(BOOL)showProgress {
    
    if (_showProgress == showProgress) {
        return;
    }
    _showProgress = showProgress;
    if (showProgress) {
        __weak typeof(*&self) wSelf = self;
        [self.KVOControllerNonRetaining observe:self.webView
                                        keyPath:@"estimatedProgress"
                                        options:NSKeyValueChangeNewKey
                                          block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                                              
                                              __strong typeof(*&wSelf) self = wSelf;
                                              if ([object isKindOfClass:[WKWebView class]] && [object respondsToSelector:@selector(estimatedProgress)]) {
                                                  [self.progressView setProgress:[object estimatedProgress] animated:YES];
                                              }
                                          }];
    }else {
        
        [self.KVOControllerNonRetaining unobserveAll];
    }
}

- (void)setProgressColor:(UIColor *)progressColor {
    
    self.progressView.progressColor = progressColor;
}

#pragma mark - Getter

- (UIColor *)progressColor {
    
    return self.progressView.progressColor;
}

- (XMNWebProgressView *)progressView {
    
    if (!_progressView) {
        
        CGRect barFrame = CGRectMake(0, 44 - 2.f, self.view.bounds.size.width, 2.f);
        _progressView = [[XMNWebProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _progressView;
}

- (WKWebView *)webView {
    
    if (!_webView) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [[WKUserContentController alloc] init];
        if (iOS10Later && [configuration respondsToSelector:@selector(setDataDetectorTypes:)]) {
            configuration.dataDetectorTypes = WKDataDetectorTypeAll;
        }

        configuration.processPool = kXMNWebPool;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (NSURL *)currentURL {
    
    return self.webView.URL;
}

@end

#pragma mark - XMNWebController (XMNWebDelegate)

#import <objc/runtime.h>

@interface XMNWebController (XMNWebDelegate) <WKUIDelegate, WKNavigationDelegate>

@property (strong, nonatomic) NSError *loadingError;

@end

@implementation XMNWebController (XMNWebDelegate)

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if (!self.navigationItem.title) {
        self.navigationItem.title = webView.title;
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    if (error.code == NSURLErrorCancelled) {
        return;
    }

    self.loadingError = error;
#ifdef XMNCONSOLE_ENABLED
    [self xmn_webDebugLogFailedWithError:error];
#endif
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    self.loadingError = error;
#ifdef XMNCONSOLE_ENABLED
    [self xmn_webDebugLogFailedWithError:error];
#endif
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *scheme = navigationAction.request.URL.scheme;
    if ([[XMNWebController applicatonURLSchemes] containsObject:scheme]) {
        /** 该请求 是可以呗UIApplication 打开的请求的请求,不在继续用webView打开 */
        if (iOS10Later && [[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:nil completionHandler:NULL];
        }else {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        XMNLog(@"URL %@ 将会使用UIApplication打开",navigationAction.request.URL);
        return;
    }
    
    if ([[XMNWebController ignoreURLSchemes] containsObject:scheme]) {
        
        /** 该请求 是可以被忽略的请求,不在继续 */
        decisionHandler(WKNavigationActionPolicyCancel);
        XMNLog(@"URL %@ 属于忽略网址,不会使用webView打开", navigationAction.request.URL);
        return;
    }
    
    if ([[XMNWebController ignoreURLHosts] containsObject:navigationAction.request.URL.host]) {
        
        /** 该请求 是可以被忽略的请求,不在继续 */
        decisionHandler(WKNavigationActionPolicyCancel);
        XMNLog(@"URL %@ 属于忽略网址,不会使用webView打开", navigationAction.request.URL);
        return;
    }
    
#ifdef XMNBRIDGE_ENABLED
    if (![self.JSBridge shouldContinueWebRequest:navigationAction.request]) {
        
        XMNLog(@"URL %@ 在JSBridge 中被拒绝继续请求", navigationAction.request.URL);
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
#endif
    
#ifdef XMNCONSOLE_ENABLED
    [self xmn_webDebugLogNavigation:navigationAction result:YES];
#endif
    
    /** 其他请求正常进行 */
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self showDetailViewController:alertController sender:self];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(NO);
                                                      }]];
    [self showDetailViewController:alertController sender:self];
}


- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:prompt
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
        textField.placeholder = prompt;
        textField.text = defaultText;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          if (alertController.textFields && alertController.textFields.count) {
                                                              completionHandler([[alertController.textFields firstObject] text]);
                                                          }else {
                                                              completionHandler(nil);
                                                          }
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                          completionHandler(nil);
                                                      }]];
    [self showDetailViewController:alertController sender:self];
}


- (NSError *)loadingError {
    
    return objc_getAssociatedObject(self, @selector(loadingError));
}

- (void)setLoadingError:(NSError *)loadingError {
    
    objc_setAssociatedObject(self, @selector(loadingError), loadingError, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark - XMNWebController (XMNJS)

@implementation XMNWebController (XMNJS)

- (void)xmn_evaluateJavaScript:(NSString *)javaScriptString
               completionBlock:(void(^)(NSString * result, NSError * error))completionBlock {
    
    [self.webView evaluateJavaScript:javaScriptString
                   completionHandler:^(id result, NSError * _Nullable error) {
                       
                       if (completionBlock) {
                           NSString * resultString = nil;
                           if ([result isKindOfClass:[NSString class]]) {
                               resultString = result;
                           } else if ([result respondsToSelector:@selector(stringValue)]) {
                               resultString = [result stringValue];
                           } else if ([result respondsToSelector:@selector(xmn_JSONString)]) {
                               resultString = [result xmn_JSONString];
                           }
                           completionBlock(resultString, error);
                       }
                   }];
}

- (void)xmn_addUserScript:(XMNWebViewUserScript *)userScript {
    
    [self.webView.configuration.userContentController addUserScript:[[WKUserScript alloc]
                                                                     initWithSource:userScript.source
                                                                     injectionTime:userScript.scriptInjectionTime
                                                                     forMainFrameOnly:userScript.isForMainFrameOnly]];
}

- (void)xmn_removeAllUserScripts {
    
    [self.webView.configuration.userContentController removeAllUserScripts];
}

- (NSArray<WKUserScript *> *)userScripts {
    
    return self.webView.configuration.userContentController.userScripts;
}

@end



#if DEBUG

@implementation XMNWebController (Debug)

- (BOOL)xmn_syncLoadURL:(NSURL *)URL error:(NSError **)error {

    [self loadWithURL:URL];
    
    while (self.webView.isLoading) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    if (error && self.loadingError) {
        *error = self.loadingError;
    }
    
    return self.loadingError == nil;
}

- (NSString *)xmn_syncEvaluateJavascript:(NSString *)javascript
                                   error:(NSError **)error {
    
    __block NSString *result;
    __block BOOL evaluateFinished = NO;;

    [self xmn_evaluateJavaScript:javascript completionBlock:^(NSString * _Nonnull jsResult, NSError * _Nonnull jsError) {
        
        if (!jsError && jsResult) {
            result = [jsResult copy];
        }else if(jsError){
            *error = jsError;
        }
        evaluateFinished = YES;
    }];
    
    while (!evaluateFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return result;
}

@end

@implementation XMNWebController (ConsoleDebug)

- (void)xmn_webDebugLogInfo:(NSString *)info {
    
    [self.console logMessage:info
                        type:XMNWebViewConsoleMessageTypeLog
                       level:XMNWebViewConsoleMessageLevelLog
                      source:XMNWebViewConsoleMessageSourceNative];
}

- (void)xmn_webDebugLogFailedWithError:(NSError *)error {
    
    
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
        /** 忽略取消网络请求错误 */
        return;
    }
    NSString * url = error.userInfo[NSURLErrorFailingURLStringErrorKey];
    NSString * message = nil, * caller = nil;
    
    if (url) {
        NSMutableString * m = [NSMutableString string];
        
        [m appendFormat:@"domain: %@, ", error.domain];
        [m appendFormat:@"code: %ld, ", (long)error.code];
        [m appendFormat:@"reason: %@", error.localizedDescription];
        
        message = [m copy];
        caller = url;
    } else  {
        message = error.description;
    }
    
    [self.console logMessage:message
                       level:XMNWebViewConsoleMessageLevelError
                      source:XMNWebViewConsoleMessageSourceNavigation
                      caller:caller];
}

- (void)xmn_webDebugLogNavigation:(WKNavigationAction *)navigation
                           result:(BOOL)result {
    
    if (![[[[navigation request] URL] absoluteString] isEqualToString:[[[navigation request] mainDocumentURL] absoluteString]]) return;
    
    NSString * message = navigation.request.URL.absoluteString;
    XMNWebViewConsoleMessageLevel level = result ? XMNWebViewConsoleMessageLevelSuccess : XMNWebViewConsoleMessageLevelWarning;
    NSString * caller;
    switch ([navigation navigationType]) {
        case WKNavigationTypeReload: caller = @"reload"; break;
        case WKNavigationTypeFormSubmitted: caller = @"from submit"; break;
        case WKNavigationTypeFormResubmitted: caller = @"from resubmit"; break;
        case WKNavigationTypeLinkActivated: caller = @"link click"; break;
        case WKNavigationTypeBackForward: caller = @"back/forward"; break;
        default:
            break;
    }
    if (caller) {
        caller = [NSString stringWithFormat:@"triggered by :%@",caller];
    }
 
    [self.console logMessage:message level:level source:XMNWebViewConsoleMessageSourceNavigation caller:caller];
}

@end

#endif
