//
//  XMNWebJSBridge.m
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import "XMNWebViewJSBridge.h"

#import "NSObject+XMNJSONKit.h"
#import "XMNWebController+JSBridge.h"

@interface XMNWebViewJSBridge ()
{
    struct {
        
        unsigned int needsUpdate: 1;;
    } _flags;
}
@property (strong, nonatomic) NSMutableArray *actions;
@property (weak, nonatomic)   XMNWebController *webController;
@property (copy, nonatomic)   NSString *javaScriptSource;

@end

@implementation XMNWebViewJSBridge

#pragma mark - Life Cycle

- (instancetype)initWithWebController:(XMNWebController *)webC {
    
    NSAssert(webC, @"webController can not be nil while init JSBridge");

    if (self = [super init]) {
        
        self.actions = [NSMutableArray array];
        self.webController = webC;
        
        self.interfaceName = @"XMNJSBridge";
        self.readyEventName = @"XMNJSBridgeReady";
        self.invokeScheme = @"xmnjs://invoke";
        
        __weak typeof(*&self) wSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
           
            __strong typeof(*&wSelf) self = wSelf;
            [self.webController xmn_addUserScript:[XMNWebViewUserScript scriptWithSource:self.javaScriptSource injectionTime:XMNUserScriptInjectionTimeAtDocumentStart mainFrameOnly:NO]];
        });
    }
    return self;
}


#pragma mark - Public Method


#pragma mark - Private Method


#pragma mark - Setter

- (void)setInterfaceName:(NSString *)interfaceName {
    
    if (_interfaceName != interfaceName) {
        _interfaceName = [interfaceName copy];
        _flags.needsUpdate =  1;
    }
}

- (void)setReadyEventName:(NSString *)readyEventName {
    
    if (_readyEventName != readyEventName) {
        _readyEventName = [readyEventName copy];
        _flags.needsUpdate =  1;
    }
}

- (void)setInvokeScheme:(NSString *)invokeScheme {
    
    if (_invokeScheme != invokeScheme) {
        _invokeScheme = [invokeScheme copy];
        _flags.needsUpdate = 1;
    }
}

#pragma mark - Getter

- (NSString *)javaScriptSource {
    
    if (!_javaScriptSource || _flags.needsUpdate) {
        
        NSBundle * bundle = [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle bundleForClass:[self class]] bundlePath], @"XMNWeb.bundle"]];
        
        _javaScriptSource = [[NSString alloc] initWithContentsOfFile:[bundle pathForResource:@"xmnjs" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL];
        NSAssert(_interfaceName, @"interfaceName must not nil");
        NSAssert(_readyEventName, @"readyEventName must not nil");
        NSAssert(_invokeScheme, @"invokeScheme must not nil");
        
        NSDictionary * config = @{@"interface": _interfaceName,
                                  @"readyEvent": _readyEventName,
                                  @"invokeScheme": _invokeScheme};
        
        NSString * json = [config xmn_JSONString];
        _javaScriptSource = [_javaScriptSource stringByAppendingFormat:@"(%@)", json];
    }
    return  _javaScriptSource;
}


@end
