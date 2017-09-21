//
//  TimeTests.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 06/08/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DBDatabase.h"

@interface DBDatabaseTests : XCTestCase <DBStorage>

@property (nonatomic, strong) NSMutableDictionary *dataMap;

@end

@implementation DBDatabaseTests

- (void)setUp {
    [super setUp];
    _dataMap = [[NSMutableDictionary alloc] init];
}

- (void)tearDown {
    [super tearDown];
    [_dataMap removeAllObjects];
}

- (void)testOnePerson {
    DBTable *table = [[DBTable alloc] initWithName:@"person" storage:self];
    [table insert:1 value:[[[[[[[DBOutput alloc] init] open] writeUInt32:1] open] writeString:@"Bernardo"] input]];
    [table commit];
    table = [[DBTable alloc] initWithName:@"person" storage:self];
    DBInput *person1 = [table search:1];
    XCTAssertNotNil(person1);
    XCTAssertEqual(1, person1.eof ? 0 : [person1 readUInt32]);
    XCTAssertEqualObjects(@"Bernardo", person1.eof ? nil : [person1 readString]);
}

- (void)testManyPerson {
	int max = 8 * 1024;
    DBTable *table = [[DBTable alloc] initWithName:@"person" storage:self];
	for (int n = 1 ; n <= max ; n++) {
		[table insert:n value:[[[[[DBOutput alloc] init] open] writeUInt32:n] input]];
	}
    [table commit];
    table = [[DBTable alloc] initWithName:@"person" storage:self];
	for (int n = 1 ; n <= max ; n++) {
		DBInput *person = [table search:n];
		XCTAssertNotNil(person);
		XCTAssertEqual(n, person.eof ? 0 : [person readUInt32]);
	}
}

- (void)testManyRandomPerson {
	int max = 8 * 1024;
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
    DBTable *table = [[DBTable alloc] initWithName:@"person" storage:self];
	for (int n = 0 ; n < max ; n++) {
		int key = ids[n];
		[table insert:key value:[[[[[DBOutput alloc] init] open] writeUInt32:key] input]];
	}
    [table commit];
    table = [[DBTable alloc] initWithName:@"person" storage:self];
	for (int n = 0 ; n < max ; n++) {
		int key = ids[n];
		DBInput *person = [table search:key];
		XCTAssertNotNil(person);
		XCTAssertEqual(key, person.eof ? 0 : [person readUInt32]);
	}
}

- (void)testArcDynamic
{
	__strong NSObject **dynamicArray = (__strong NSObject **)calloc(10, sizeof(NSObject *));
	for (int i = 0; i < 10; i++) {
		dynamicArray[i] = [[NSMutableArray alloc] init];
	}
	for (int i = 0; i < 10; i++) {
		NSMutableArray *array = (NSMutableArray*) dynamicArray[i];
		XCTAssertEqual(0, array.count);
		[array addObject:@1];
	}
	for (int i = 0; i < 10; i++) {
		NSMutableArray *array = (NSMutableArray*) dynamicArray[i];
		XCTAssertEqual(1, array.count);
	}
	for (int i = 0; i < 10; i++) {
		dynamicArray[i] = nil;
	}
	free(dynamicArray);
}

- (void)testArcStatic
{
	__strong NSObject *dynamicArray[10];
	for (int i = 0; i < 10; i++) {
		dynamicArray[i] = [[NSMutableArray alloc] init];
	}
	for (int i = 0; i < 10; i++) {
		NSMutableArray *array = (NSMutableArray*) dynamicArray[i];
		XCTAssertEqual(0, array.count);
		[array addObject:@1];
	}
	for (int i = 0; i < 10; i++) {
		NSMutableArray *array = (NSMutableArray*) dynamicArray[i];
		XCTAssertEqual(1, array.count);
	}
	for (int i = 0; i < 10; i++) {
		dynamicArray[i] = nil;
	}
}

- (void)writeData:(NSData*)data andName:(NSString*)name andId:(NSUInteger)sequence
{
    NSString *key = [NSString stringWithFormat:@"%@_%ld", name, (unsigned long)sequence];
    _dataMap[key] = data;
}

- (void)removeDataWithName:(NSString*)name andId:(NSUInteger)sequence
{
    NSString *key = [NSString stringWithFormat:@"%@_%ld", name, (unsigned long)sequence];
    [_dataMap removeObjectForKey:key];
}

- (NSData*)readDataWithName:(NSString*)name andId:(NSUInteger)sequence
{
    NSString *key = [NSString stringWithFormat:@"%@_%ld", name, (unsigned long)sequence];
    NSData *data = _dataMap[key];
    return data;
}

- (BOOL)hasDataWithName:(NSString*)name andId:(NSUInteger)sequence
{
    NSString *key = [NSString stringWithFormat:@"%@_%ld", name, (unsigned long)sequence];
    return _dataMap[key] != nil;
}

@end
