//
//  XMNTypeCastUtil.h
//  Pods
//
//  Created by XMFraker on 17/2/22.
//
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN_INLINE NSString * __nullable xmn_stringOfValue(id _Nullable value,  NSString * _Nullable defaultValue);
FOUNDATION_EXTERN_INLINE NSInteger xmn_integerOfValue(id _Nullable value,  NSInteger defaultValue);
FOUNDATION_EXTERN_INLINE NSArray * __nullable xmn_arrayOfValue(id _Nullable value,  NSArray * _Nullable defaultValue);
FOUNDATION_EXTERN_INLINE NSDictionary * __nullable xmn_dictionaryOfValue(id _Nullable value,  NSDictionary * _Nullable defaultValue);


@interface NSDictionary (XMNTypeCast)

/*!
 *  返回当前key对应value的NSString值，没有则返回nil
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 当key对应的值为NSString类型时返回该值，没有则返回nil
 */
- (NSString *)xmn_stringForKey:(NSString *)key;

/*!
 *  返回当前key对应value的NSDictionary值，没有则返回nil
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的NSDictionary值，不存在则返回Nil
 */
- (NSDictionary *)xmn_dictForKey:(NSString *)key;

/*!
 *  返回当前key对应value的NSArray值，没有则返回nil
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的NSArray值，不存在则返回nil
 */
- (NSArray *)xmn_arrayForKey:(NSString *)key;

/*!
 *  返回当前key对应value的NSInteger值，没有则返回0
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的NSInteger值，不存在则返回0
 */
- (NSInteger)xmn_integerForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
