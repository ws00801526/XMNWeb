//
//  XMNWebViewUserScript.m
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import "XMNWebViewUserScript.h"

@implementation XMNWebViewUserScript
@synthesize source = _source;
@synthesize scriptInjectionTime = _scriptInjectionTime;
@synthesize forMainFrameOnly = _forMainFrameOnly;

#pragma mark - Life Cycle

- (instancetype)initWithSource:(NSString *)source
                 injectionTime:(XMNUserScriptInjectionTime)injectionTime
                 mainFrameOnly:(BOOL)mainFrameOnly {
    
    if (self = [super init]) {
        
        _source = [source copy];
        _scriptInjectionTime = injectionTime;
        _forMainFrameOnly = mainFrameOnly;
    }
    return self;
}

+ (instancetype)scriptWithSource:(NSString *)source injectionTime:(XMNUserScriptInjectionTime)injectionTime mainFrameOnly:(BOOL)mainFrameOnly {
    
    return [[self alloc] initWithSource:source injectionTime:injectionTime mainFrameOnly:mainFrameOnly];
}

#pragma mark - Getter

- (BOOL)isForMainFrameOnly {
    
    return _forMainFrameOnly;
}

@end
