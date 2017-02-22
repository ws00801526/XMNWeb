//
//  XMNURLRouteTests.m
//  XMNWeb
//
//  Created by XMFraker on 17/2/22.
//  Copyright © 2017年 ws00801526. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XMNURLRouteTests : XCTestCase

@end

@implementation XMNURLRouteTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNonSchemeURL {
    
    NSString *urlString = @"www.youku.com ";
    NSURL *URL = [NSURL URLWithString:urlString];
    XCTAssertNil([URL scheme]);
    
    urlString = @"xmnjs://invoke";
    URL = [NSURL URLWithString:urlString];
    XCTAssert([[URL scheme] isEqualToString:@"xmnjs"]);

}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
