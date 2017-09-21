//
//  TimeTests.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 06/08/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSIntegerCollection.h"

@interface NSIntegerMapTests : XCTestCase

@end

@implementation NSIntegerMapTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAdd
{
    NSIntegerMap *map = [[NSIntegerMap alloc] init];
    [map putKey:5 withValue:10];
    [map putKey:10 withValue:15];
    [map putKey:15 withValue:20];
    [map putKey:20 withValue:25];
    [map putKey:25 withValue:30];
    [map putKey:30 withValue:35];
    XCTAssertEqual(10, [map getKey:5]);
    XCTAssertEqual(15, [map getKey:10]);
    XCTAssertEqual(20, [map getKey:15]);
    XCTAssertEqual(25, [map getKey:20]);
    XCTAssertEqual(30, [map getKey:25]);
    XCTAssertEqual(35, [map getKey:30]);
}

- (void)testAddRandom
{
    int max = 16 * 1024;
    int ids[max];
    for (int n = 0 ; n < max ; n++) {
        ids[n] = n + 1;
    }
    for (int n = 0 ; n < max ; n++) {
        int aux = ids[n];
        int index = n + (rand() % (max - n));
        ids[n] = ids[index];
        ids[index] = aux;
    }
    NSIntegerMap *map = [[NSIntegerMap alloc] init];
    for (int n = 0 ; n < max ; n++) {
        [map putKey:n withValue:n];
    }
    for (int n = 0 ; n < max ; n++) {
        XCTAssertEqual(n, [map getKey:n]);
    }
    for (int n = 0 ; n < max ; n++) {
        XCTAssertEqual(n, [map getKey:n]);
        [map removeKey:n];
        XCTAssertEqual(-1, [map getKey:n]);
    }
}

- (void)testMultiAdd
{
    NSIntegerArrayMap *map = [[NSIntegerArrayMap alloc] init];
    [map addKey:5 withValue:10];
    [map addKey:10 withValue:15];
    [map addKey:5 withValue:20];
    [map addKey:10 withValue:25];
    [map addKey:2 withValue:30];
    [map addKey:2 withValue:35];
    XCTAssertEqual(10, [[map getKey:5] get:0]);
    XCTAssertEqual(15, [[map getKey:10] get:0]);
    XCTAssertEqual(20, [[map getKey:5] get:1]);
    XCTAssertEqual(25, [[map getKey:10] get:0]);
    XCTAssertEqual(30, [[map getKey:2] get:0]);
    XCTAssertEqual(35, [[map getKey:2] get:1]);
}

@end
