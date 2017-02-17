//
//  XMNWebController.h
//  Pods
//
//  Created by XMFraker on 17/2/15.
//
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

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
- (nullable instancetype)initWithURL:(NSURL *)URL NS_DESIGNATED_INITIALIZER;

/**
 初始化方法

 @param URL      originURL
 @param options  默认配置
 @return nil or XMNWebController实例
 */
- (nullable instancetype)initWithURL:(NSURL *)URL
                             options:(nullable NSDictionary *)options NS_DESIGNATED_INITIALIZER;

/**
 加载URL
 如果当前originURL 为nil  则置originURL = URL
 @param URL 需要加载的URL
 */
- (void)loadWithURL:(NSURL *)URL;

/**
 加载URL

 @param URL     需要加载的URL
 @param timeout 超时时间
 */
- (void)loadWithURL:(NSURL *)URL
            options:(nullable NSDictionary *)options;

@end

@interface XMNWebController (XMNWebDeprecated)

- (instancetype)init OBJC_UNAVAILABLE("use initWithURL:");
- (instancetype)initWithCoder:(NSCoder *)aDecoder OBJC_UNAVAILABLE("use initWithURL:");
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil OBJC_UNAVAILABLE("use initWithURL:");

@end

NS_ASSUME_NONNULL_END
