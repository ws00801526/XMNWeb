//
//  XMNWebViewUserScript.h
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XMNUserScriptInjectionTime) {
    XMNUserScriptInjectionTimeAtDocumentStart,
    XMNUserScriptInjectionTimeAtDocumentEnd
};

NS_ASSUME_NONNULL_BEGIN

@protocol XMNWebViewUserScript <NSObject>

@property (nonatomic, copy, readonly, nullable) NSString * source;
@property (nonatomic, readonly) XMNUserScriptInjectionTime scriptInjectionTime;
@property (nonatomic, readonly, getter=isForMainFrameOnly) BOOL forMainFrameOnly;

@end

@interface XMNWebViewUserScript : NSObject <XMNWebViewUserScript>

+ (instancetype)scriptWithSource:(NSString *)source
                   injectionTime:(XMNUserScriptInjectionTime)injectionTime
                   mainFrameOnly:(BOOL)mainFrameOnly;

@end

NS_ASSUME_NONNULL_END
