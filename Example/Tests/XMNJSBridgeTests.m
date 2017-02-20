//
//  XMNJSBridgeTests.m
//  XMNWeb
//
//  Created by XMFraker on 17/2/17.
//  Copyright © 2017年 ws00801526. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <XMNWeb/XMNWebController+JSBridge.h>


#ifndef XMNASYNC_TEST_START
#define XMNASYNC_TEST_START                 __block BOOL hasCalledBack = NO;
#define XMNASYNC_TEST_DONE                  hasCalledBack = YES;
#define XMNASYNC_TEST_END_TIMEOUT(timeout)  NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];\
while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) { \
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil]; \
} \
if (!hasCalledBack) { XCTFail(@"Timeout"); }
#define XMNASYNC_TEST_END                   XMNASYNC_TEST_END_TIMEOUT(10)
#endif


@interface XMNJSBridgeActionGetValueTests : XMNJSBridgeAction

@end

@interface XMNJSBridgeActionFinishTests : XMNJSBridgeAction

@end


@interface XMNJSBridgeTests : XCTestCase

@property (strong, nonatomic) XMNWebController *webController;


@end

@implementation XMNJSBridgeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.webController = [[XMNWebController alloc] init];
    XCTAssertNotNil(self.webController.JSBridge);

    NSError *error;
    [self.webController xmn_syncLoadURL:[[NSBundle mainBundle] URLForResource:@"XMNJSBridgeTest.html" withExtension:nil]
                                  error:&error];
    
    XCTAssertNil(error);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJSBridgeInjection {

    NSError *error;
    NSString *result = [self.webController xmn_syncEvaluateJavascript:@"typeof window.XMNJSBridge"
                                                                error:&error];
    XCTAssert([result  isEqualToString:@"object"] && !error);
}


- (void)testJSBridgeInvoke {
    
    NSError *error;
    NSString *result = [self.webController xmn_syncEvaluateJavascript:@"invokeGetValue()" error:&error];
    XCTAssert([result isEqualToString:@"1"]);
}

- (void)testJSBridgeInvokeAndCallBack {
    
    NSString *result = [self.webController xmn_syncEvaluateJavascript:@"invokeGetValueWithParams({'key1':'value1'})"
                                                                error:NULL];
    XCTAssert([result isEqualToString:@"1"]);

    __weak typeof(*&self) wSelf = self;
    [self expectationForNotification:@"XMNJSBridgeInvokeFinished"
                              object:self.webController.JSBridge
                             handler:^BOOL(NSNotification * _Nonnull notification) {
        
                                 __strong typeof(*&wSelf) self = wSelf;
                                 
                                 NSLog(@"get value :%@", notification.userInfo[@"value"]);
                                 
                                 XCTAssert(notification.userInfo && notification.userInfo[@"value"]);
                                 XCTAssert([notification.userInfo[@"value"][@"bundleID"] isEqualToString:@"com.XMFraker.XMNWeb"]);
                                 return YES;
    }];

    [self waitForExpectationsWithTimeout:20.f handler:NULL];
}

@end

@implementation XMNJSBridgeActionGetValueTests

- (void)startAction {
    
    NSLog(@"js invoke getValueTest");
    NSLog(@"i get params :%@",self.message.parameters);
    
    [self actionSuccessedWithResult:@{ @"key2": @"value2"}];

//    __weak typeof(*&self) wSelf = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        __strong typeof(*&wSelf) self = wSelf;
//        NSLog(@"i will call back");
//        
//        [self actionSuccessedWithResult:@{ @"key2": @"value2"}];
//    });
}

@end



@implementation XMNJSBridgeActionFinishTests

- (void)startAction {

    [self actionSuccessedWithResult:@{}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XMNJSBridgeInvokeFinished"
                                                        object:self.JSBridge
                                                      userInfo:self.message.parameters];
}

@end
