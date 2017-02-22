//
//  NSObject+XMNJSONKit.m
//  Pods
//
//  Created by XMFraker on 17/2/16.
//
//

#import "NSObject+XMNJSONKit.h"

@implementation NSObject (XMNJSONKit)

@end

@implementation NSString (WBJSONKit)

- (NSString *)xmn_JSONString {
    
    return [self copy];
}

- (id)xmn_objectFromJSONString {
    
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
}

@end

@implementation NSArray (WBJSONKit)

- (NSString *)xmn_JSONString {
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

@implementation NSDictionary (WBJSONKit)

- (NSString *)xmn_JSONString {
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
