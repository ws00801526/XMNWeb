//
//  XMNJSBridgeMessage.m
//  Pods
//
//  Created by XMFraker on 17/2/17.
//
//

#import "XMNJSBridgeMessage.h"

@interface XMNJSBridgeMessage ()

@property (nonatomic, copy) NSString * action;
@property (nonatomic, copy) NSDictionary * parameters;
@property (nonatomic, copy) NSString * callbackID;

@end

@implementation XMNJSBridgeMessage

- (instancetype)init {
    
    return [self initWithDictionary:@{}];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        if (dict[@"action"] && [dict[@"action"] isKindOfClass:[NSString class]]) {
            self.action = dict[@"action"];
        }
        
        if (dict[@"params"] && [dict[@"params"] isKindOfClass:[NSDictionary class]]) {
            
            self.parameters = dict[@"params"];
        }
        
        if (dict[@"callback_id"] && [dict[@"callback_id"] isKindOfClass:[NSString class]]) {
            
            self.callbackID = dict[@"callback_id"];
        }
    }
    return self;
}

@end
