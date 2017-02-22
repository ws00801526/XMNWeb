//
//  XMNTypeCastUtil.m
//  Pods
//
//  Created by XMFraker on 17/2/22.
//
//

#import "XMNTypeCastUtil.h"


NSString * __nullable xmn_stringOfValue(id _Nullable value,  NSString * _Nullable defaultValue) {
    
    if (!value) {
        return defaultValue;
    }
    
    if (![value isKindOfClass:[NSString class]]) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        }
        return defaultValue;
    }
    return value;
}

NSInteger xmn_integerOfValue(id _Nullable value,  NSInteger defaultValue) {
    
    if ([value respondsToSelector:@selector(integerValue)])
        return [value integerValue];
    
    return defaultValue;
}

NSArray * __nullable xmn_arrayOfValue(id _Nullable value,  NSArray * _Nullable defaultValue) {
    
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return defaultValue;
}

NSDictionary * __nullable xmn_dictionaryOfValue(id _Nullable value,  NSDictionary * _Nullable defaultValue) {
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return defaultValue;
}


@implementation NSDictionary (XMNTypeCast)

/*!
 *  返回当前key对应value的NSString值，没有则返回nil
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 当key对应的值为NSString类型时返回该值，没有则返回nil
 */
- (NSString *)xmn_stringForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    return xmn_stringOfValue(value, nil);
}

/*!
 *  返回当前key对应value的NSDictionary值，没有则返回nil
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的NSDictionary值，不存在则返回Nil
 */
- (NSDictionary *)xmn_dictForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    return xmn_dictionaryOfValue(value, nil);

}

/*!
 *  返回当前key对应value的NSArray值，没有则返回nil
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的NSArray值，不存在则返回nil
 */
- (NSArray *)xmn_arrayForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    return xmn_arrayOfValue(value, nil);
}

/*!
 *  返回当前key对应value的NSInteger值，没有则返回0
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的NSInteger值，不存在则返回0
 */
- (NSInteger)xmn_integerForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    return xmn_integerOfValue(value, 0);
}

@end
