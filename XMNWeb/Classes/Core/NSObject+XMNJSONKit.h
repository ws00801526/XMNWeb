//
//  NSObject+XMNJSONKit.h
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XMNJSONKit)

@end

@interface NSString (XMNJSONKit)

@property (nonatomic, copy, readonly, nullable) NSString * xmn_JSONString;
@property (nonatomic, copy, readonly, nullable) id xmn_objectFromJSONString;

@end

@interface NSArray (XMNJSONKit)

@property (nonatomic, copy, readonly, nullable) NSString * xmn_JSONString;

@end

@interface NSDictionary (XMNJSONKit)

@property (nonatomic, copy, readonly, nullable) NSString * xmn_JSONString;

@end

NS_ASSUME_NONNULL_END
