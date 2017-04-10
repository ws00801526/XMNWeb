//
//  XMNWebController.h
//  Pods
//
//  Created by XMFraker on 17/2/15.
//
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <XMNWeb/XMNWebViewUserScript.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMNWebController : UIViewController

/** 是否显示加载进度 默认YES */
@property (assign, nonatomic) BOOL showProgress;
/** 进度条颜色 默认 RGB(22,126,251)*/
@property (strong, nonatomic) UIColor *progressColor;

/** 当前webView显示的网页地址 */
@property (strong, nonatomic, readonly) NSURL *currentURL;
/** 当前webView第一个加载的网页 */
@property (strong, nonatomic, readonly) NSURL *originURL;
/** 网页请求超时时间,默认 20s */
@property (assign, nonatomic, readonly) NSTimeInterval timeout;
/** 加载网页的webView */
@property (strong, nonatomic, readonly) WKWebView *webView;
/** 自定义加载头部 */
@property (copy, nonatomic, readonly)   NSDictionary *customHeaders;

/**
 初始化方法

 @param URL originURL
 @return nil or XMNWebController实例
 */
- (nullable instancetype)initWithURL:(nullable NSURL *)URL;

/**
 初始化方法

 @param URL      originURL
 @param options  默认配置
 @return nil or XMNWebController实例
 */
- (nullable instancetype)initWithURL:(nullable NSURL *)URL
                             options:(nullable NSDictionary *)options NS_DESIGNATED_INITIALIZER;

/**
 初始化UI界面  包括webView,processView

 */
- (void)setupUI;


/**
 对webView 进行配置
 setupUI完成后调用, 可以添加JS,添加需要执行的脚本等
 
 默认支持 allowsLinkPreview,allowsBackForwardNavigationGestures
 @param webView 需要配置的webView
 */
- (void)configWebView:(WKWebView *)webView;

/**
 加载URL
 如果当前originURL 为nil  则置originURL = URL
 @param URL 需要加载的URL
 */
- (void)loadWithURL:(nullable NSURL *)URL;

/**
 加载URL

 @param URL     需要加载的URL
 @param timeout 超时时间
 */
- (void)loadWithURL:(nullable NSURL *)URL
            options:(nullable NSDictionary *)options;


/**
 重新加载当前web内容
 */
- (void)reloadController;


@end

@interface XMNWebController (XMNJS)

/** 当前webControler.webView中添加的所有用户脚本 */
@property (copy, nonatomic, readonly, nullable) NSArray<WKUserScript *> *userScripts;

/**
 执行一段JS代码
 
 @param javaScriptString 需要执行的JS代码
 @param completionBlock  回调block
 */
- (void)xmn_evaluateJavaScript:(NSString *)javaScriptString
               completionBlock:(nullable void(^)( NSString * _Nullable  result, NSError * _Nullable error))completionBlock;

/**
 添加一点JS脚本
 
 @param userScript 需要添加的JS脚本
 */
- (void)xmn_addUserScript:(XMNWebViewUserScript *)userScript;

/**
 删除所有手动添加的JS脚本
 */
- (void)xmn_removeAllUserScripts;


#pragma mark - Class Method

/**
 *  重置WKWebProgressPool
 *  用于立即更新缓存
 */
+ (void)resetProcessPool:(WKProcessPool *)processPool;

/**
 获取当前使用的progressPool
 
 @return WKProcessPool 实例
 */
+ (WKProcessPool *)processPool;

/**
 *  清空所有缓存
 */
+ (void)removeAllCaches;

/**
 清空对应缓存类型的缓存数据

 @param dataTypes 需要清空的缓存数据 参考  WKWebsiteDataStore
 */
+ (void)removeCahcesWithDataTypes:(NSSet <NSString *> *)dataTypes;

@end

/** 暴露XMNWebController实现的 WKUIDelegate, WKNavigationDelegate 接口,供子类重写*/
@interface XMNWebController (XMNWebDelegate) <WKUIDelegate, WKNavigationDelegate>

@property (strong, nonatomic, readonly) NSError *loadingError;

@end


#if DEBUG

@interface XMNWebController (Debug)

/**
 增加DEBUG模式下使用的同步加载网页
 主要用于Tests 中 等待网页加载完成
 
 @param URL     需要加载的地址
 @param error   error
 @return 是否加载成功
 */
- (BOOL)xmn_syncLoadURL:(NSURL *)URL error:(NSError **)error;


/**
 DEBUG 模式下 同步获取js执行结果

 @param javascript 需要执行的js
 @param error      error信息
 @return js 执行结果 ornil
 */
- (NSString *)xmn_syncEvaluateJavascript:(NSString *)javascript
                                   error:(NSError **)error;

@end

#endif

#if XMNCONSOLE_ENABLED


@interface XMNWebController (ConsoleDebug)

- (void)xmn_webDebugLogInfo:(NSString *)info;

- (void)xmn_webDebugLogFailedWithError:(NSError *)error;

- (void)xmn_webDebugLogNavigation:(WKNavigationAction *)navigation
                           result:(BOOL)result;
@end

#endif

NS_ASSUME_NONNULL_END
