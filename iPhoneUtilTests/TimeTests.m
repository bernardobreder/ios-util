//
//  TimeTests.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 06/08/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Time.h"

@interface TimeTests : XCTestCase

@end

@implementation TimeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNumberOfWeeks {
    XCTAssertEqual(1, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1]]);
    XCTAssertEqual(1, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:2]]);
    XCTAssertEqual(2, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:3]]);
    XCTAssertEqual(2, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:9]]);
    XCTAssertEqual(3, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:10]]);
    XCTAssertEqual(3, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:16]]);
    XCTAssertEqual(6, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:31]]);
    XCTAssertEqual(6, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:1 andDay:1]]);
    XCTAssertEqual(6, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:1 andDay:6]]);
    XCTAssertEqual(7, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:1 andDay:7]]);
    XCTAssertEqual(10, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:1 andDay:28]]);
    XCTAssertEqual(10, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:2 andDay:1]]);
    XCTAssertEqual(10, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:2 andDay:6]]);
    XCTAssertEqual(11, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:2 andDay:7]]);
    XCTAssertEqual(1, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:2] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:2]]);
    XCTAssertEqual(2, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:2] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:3]]);
    XCTAssertEqual(4, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:29]]);
    XCTAssertEqual(6, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:1 andDay:12]]);
    XCTAssertEqual(6, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:1 andDay:13]]);
    XCTAssertEqual(7, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:1 andDay:14]]);
    XCTAssertEqual(5, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:1 andDay:3]]);
    XCTAssertEqual(5, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:1 andDay:6]]);
    XCTAssertEqual(5, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:1 andDay:1]]);
    XCTAssertEqual(9, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:2 andDay:3]]);
    XCTAssertEqual(9, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:2 andDay:1]]);
    XCTAssertEqual(9, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:2 andDay:6]]);
    XCTAssertEqual(10, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:2 andDay:7]]);
    XCTAssertEqual(10, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:2 andDay:13]]);
    XCTAssertEqual(11, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:2 andDay:14]]);
    XCTAssertEqual(13, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:2 andDay:28]]);
    XCTAssertEqual(13, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:2 andDay:31]]);
    XCTAssertEqual(13, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:3 andDay:3]]);
    XCTAssertEqual(14, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:3 andDay:4]]);
    XCTAssertEqual(14, [[[DayTime alloc] initWithYear:2010 andMonth:3 andDay:4] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:8]]);
    XCTAssertEqual(4, [[[DayTime alloc] initWithYear:2010 andMonth:6 andDay:21] numberOfWeeks:[[DayTime alloc] initWithYear:2010 andMonth:7 andDay:11]]);
}

- (void)testDayWeek {
    XCTAssertEqual(5, [[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1].dayOfWeek);
    XCTAssertEqual(6, [[DayTime alloc] initWithYear:2010 andMonth:0 andDay:2].dayOfWeek);
    XCTAssertEqual(0, [[DayTime alloc] initWithYear:2010 andMonth:0 andDay:3].dayOfWeek);
}

- (void)testGetElapsedDays {
    
    XCTAssertEqual(0, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] getElapsedDays:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1]]);
    XCTAssertEqual(1, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] getElapsedDays:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:2]]);
    XCTAssertEqual(2, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1] getElapsedDays:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:3]]);
    XCTAssertEqual(0, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:2] getElapsedDays:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:2]]);
    XCTAssertEqual(1, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:2] getElapsedDays:[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:3]]);
    XCTAssertEqual(31, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:2] getElapsedDays:[[DayTime alloc] initWithYear:2010 andMonth:1 andDay:2]]);
    XCTAssertEqual(59, [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:2] getElapsedDays:[[DayTime alloc] initWithYear:2010 andMonth:2 andDay:2]]);
    XCTAssertEqual(32, [[[DayTime alloc] initWithYear:2008 andMonth:4 andDay:29] getElapsedDays:[[DayTime alloc] initWithYear:2008 andMonth:5 andDay:30]]);
    XCTAssertEqual(31, [[[DayTime alloc] initWithYear:2008 andMonth:4 andDay:30] getElapsedDays:[[DayTime alloc] initWithYear:2008 andMonth:5 andDay:30]]);
    XCTAssertEqual(30, [[[DayTime alloc] initWithYear:2008 andMonth:4 andDay:31] getElapsedDays:[[DayTime alloc] initWithYear:2008 andMonth:5 andDay:30]]);
}

- (void)testGetElapsedDaysStress {
    DayTime *begin = [[DayTime alloc] initWithYear:2008 andMonth:0 andDay:1];
    DayTime *day = begin.clone;
    for (NSUInteger n = 0 ; n < 16 * 1024 ; n++) {
        XCTAssertEqual(n, [begin getElapsedDays:day]);
        [day addDay:1];
    }
}

- (void)testGetYearMonthDay {
    XCTAssertEqual(2010, [[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1].year);
    XCTAssertEqual(0, [[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1].month);
    XCTAssertEqual(1, [[DayTime alloc] initWithYear:2010 andMonth:0 andDay:1].day);
    NSUInteger y, m, d;
    [[[DayTime alloc] initWithYear:2010 andMonth:0 andDay:2] getYear:&y andMonth:&m andDay:&d];
    XCTAssertEqual(2010, y);
    XCTAssertEqual(0, m);
    XCTAssertEqual(2, d);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    //    [self measureBlock:^{
    // Put the code you want to measure the time of here.
    //    }];
}

@end
