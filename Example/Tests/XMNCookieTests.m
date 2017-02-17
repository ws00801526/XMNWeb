//
//  XMNCookieTest.m
//  XMNWeb
//
//  Created by XMFraker on 17/2/15.
//  Copyright © 2017年 ws00801526. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <XMNWeb/NSHTTPCookie+XMNCookie.h>

@interface XMNCookieTests : XCTestCase

@end

@implementation XMNCookieTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    
    NSArray<NSString *> *domains = @[@"baidu.com",@"google.com",@"zuifuli.io",@"test.zuifuli.io"];
    
    /** 配置10条cookie */
    for (int i = 0; i < 10; i ++) {
        NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:@{NSHTTPCookieName : [NSString stringWithFormat:@"cookie_%d",i],
                                                                          NSHTTPCookieDomain : domains[i % 4],
                                                                          NSHTTPCookieValue : @"xxxxxCookie value",
                                                                          NSHTTPCookiePath : @"/"}];
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
    NSLog(@"bundle version :%@",UIApplicationStateRestorationBundleVersionKey);
    NSLog(@"bundle version 2 :%@ ",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] removeCookiesSinceDate:[NSDate dateWithTimeIntervalSince1970:0]];
}

- (void)testStoreCookie {
    
    {
        NSArray<NSDictionary *> *storeCookies = [NSHTTPCookie xmn_storeCookies];
        XCTAssertEqual(storeCookies.count, 10);
        
        NSArray<NSHTTPCookie *> *fetchCookies = [NSHTTPCookie xmn_cookies];
        XCTAssertEqual(fetchCookies.count, 10);
    }
    
    {
        NSArray<NSDictionary *> *storeCookies = [NSHTTPCookie xmn_storeCookiesWithNames:@[@"cookie_1",@"cookie_2"]];
        XCTAssertEqual(storeCookies.count, 2);
        
        NSArray<NSHTTPCookie *> *fetchCookies = [NSHTTPCookie xmn_cookiesWithNames:@[@"cookie_1",@"cookie_2"]];
        XCTAssertEqual(fetchCookies.count, 2);
    }
    
    {
        
        NSArray<NSDictionary *> *storeCookies = [NSHTTPCookie xmn_storeCookiesWithDomains:@[@"test.zuifuli.io"]];
        XCTAssertEqual(storeCookies.count, 2);
        
        NSArray<NSHTTPCookie *> *fetchCookies = [NSHTTPCookie xmn_cookiesWithDomains:@[@"test.zuifuli.io"]];
        XCTAssertEqual(fetchCookies.count, 2);
    }
    
    {
        NSArray<NSDictionary *> *storeCookies = [NSHTTPCookie xmn_storeCookiesWithNames:@[@"cookie_1",@"cookie_2"]
                                                                                domains:@[@"baidu.com",@"google.com"]];
        XCTAssertEqual(storeCookies.count, 1);
        
        NSArray<NSHTTPCookie *> *fetchCookies = [NSHTTPCookie xmn_cookiesWithNames:@[@"cookie_1",@"cookie_2"]
                                                                           domains:@[@"baidu.com",@"google.com"]];
        XCTAssertEqual(fetchCookies.count, 1);
    }
}


- (void)testDeleteCookie {
    
    {
        NSArray<NSDictionary *> *storeCookies = [NSHTTPCookie xmn_storeCookies];
        XCTAssertEqual(storeCookies.count, 10);
        
        NSArray<NSHTTPCookie *> *fetchCookies = [NSHTTPCookie xmn_cookies];
        XCTAssertEqual(fetchCookies.count, 10);
        
        [NSHTTPCookie xmn_deleteCookiesWithNames:@[@"cookie_1",@"cookie_2"]
                                         domains:nil];
        
        NSArray<NSHTTPCookie *> *fetchCookiesAfter = [NSHTTPCookie xmn_cookies];
        XCTAssertEqual(fetchCookiesAfter.count, 8);
        
    }
}

@end
