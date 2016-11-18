//
//  Fifa_competitionsTests.m
//  Fifa_competitionsTests
//
//  Created by Andy Chikalo on 11/11/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Club.h"

@interface Fifa_competitionsTests : XCTestCase

@end

@implementation Fifa_competitionsTests

- (void)setUp {
    [super setUp];
    Club * club = [Club new];
    
    club.title = @"213213";
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
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
