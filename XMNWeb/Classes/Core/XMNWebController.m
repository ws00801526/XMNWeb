//
//  XMNWebController.m
//  Pods
//
//  Created by XMFraker on 17/2/15.
//
//

#import "XMNWebController.h"
#import "XMNWebProgressView.h"
#import "XMNWebMarco.h"

#import "XMNWebController+XMNWebOptions.h"

static WKProcessPool *kXMNWebPool = nil;

@interface XMNWebController ()

@property (assign, nonatomic) NSTimeInterval timeout;
@property (strong, nonatomic) NSURL *originURL;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) XMNWebProgressView *progressView;

@property (copy, nonatomic)   NSDictionary *customHeaders;


@end

@implementation XMNWebController
@synthesize webView = _webView;

#pragma mark - Life Cycle

+ (void)initialize {
    
    kXMNWebPool = [[WKProcessPool alloc] init];
}

- (instancetype)initWithURL:(NSURL *)URL {
    
    return [self initWithURL:URL
                     options:nil];
}

- (instancetype)initWithURL:(NSURL *)URL
                    options:(nullable NSDictionary *)options {
    

    
    if (!URL) {
        return nil;
    }
    
    if (self = [super init]) {
        
        [self setupUI];
        [self loadWithURL:URL
                  options:options];
    }
    return self;
}

    
#pragma mark - Override Method

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"%@ viewWillAppear",NSStringFromClass([self class]));
    self.showProgress ? [self.navigationController.navigationBar addSubview:self.progressView] : nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    NSLog(@"%@ viewWillDisappear",NSStringFromClass([self class]));
    /** 需要移除progressView */
    self.showProgress ? [self.progressView removeFromSuperview] : nil;
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
    NSLog(@"%@  dealloc",self);
}

#pragma mark - Public Method

- (void)setupUI {
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    if (iOS10Later && [configuration respondsToSelector:@selector(setDataDetectorTypes:)]) {
        configuration.dataDetectorTypes = WKDataDetectorTypeAll;
    }
    configuration.processPool = kXMNWebPool;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    [self.view addSubview:self.webView = webView];
    
    self.showProgress = YES;
    [self.progressView setProgress:0.f];
}


- (void)loadWithURL:(NSURL *)URL {
    
    [self loadWithURL:URL
              options:nil];
}

- (void)loadWithURL:(NSURL *)URL
            options:(nullable NSDictionary *)options {

    if (!URL) {
        return;
    }
    
    if (!self.originURL) {
        self.originURL = URL;
    }

    /** 本地文件 */
    if ([URL isFileURL]) {
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
    }else {
        self.timeout = options[XMNWebViewTimeoutKey] ? [options[XMNWebViewTimeoutKey] integerValue] : 20.f;
        
        if (options[XMNWebViewCustomHeadersKey] && [options[XMNWebViewCustomHeadersKey] isKindOfClass:[NSDictionary class]]) {
            self.customHeaders = options[XMNWebViewCustomHeadersKey];
        }
        
        NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeout];
        [mutableRequest setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forHTTPHeaderField:[[NSBundle mainBundle] bundleIdentifier]];
        if (self.customHeaders) {
            [self.customHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [mutableRequest setValue:obj ? : @"invalid header" forHTTPHeaderField:key];
            }];
        }
        [self.webView loadRequest:[mutableRequest copy]];
    }
}

#pragma mark - Setter

- (void)setShowProgress:(BOOL)showProgress {
    
    if (_showProgress == showProgress) {
        return;
    }
    _showProgress = showProgress;
    @try {
        if (showProgress) {
            [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        }else {
            [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
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

- (NSURL *)currentURL {
    
    return self.webView.URL;
}
@end

@interface XMNWebController (XMNWebDelegate) <WKUIDelegate, WKNavigationDelegate>

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
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    if (error.code == NSURLErrorCancelled) {
        return;
    }
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
@end
