//
//  XMNJSBridgeMessage.h
//  Pods
//
//  Created by XMFraker on 17/2/17.
//
//

#import <Foundation/Foundation.h>
#import "XMNWebMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMNJSBridgeMessage : NSObject

@property (nonatomic, copy, readonly) NSString * action;
@property (nonatomic, copy, readonly) NSDictionary * parameters;
@property (nonatomic, copy, readonly) NSString * callbackID;

/**
 初始化方法

 @param dict 相关参数
 @return XMNJSBridgeMessage 实例
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
