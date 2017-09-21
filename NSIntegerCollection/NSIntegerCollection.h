//
//  NSIntegerArray.h
//  iPhoneUtil
//
//  Created by Bernardo Breder on 14/09/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIntegerArray : NSObject

- (instancetype)init;

- (instancetype)initWithCapacity:(NSUInteger)capacity;

- (void)add:(NSInteger)value;

- (void)add:(NSInteger)value atIndex:(NSUInteger)index;

- (NSInteger)get:(NSUInteger)index;

- (void)remove:(NSUInteger)index;

- (void)clear;

- (NSUInteger)size;

@end

@interface NSIntegerMap : NSObject

- (instancetype)init;

- (instancetype)initWithCapacity:(NSUInteger)capacity;

- (NSInteger)getKey:(NSInteger)key;

- (void)putKey:(NSInteger)key withValue:(NSInteger)value;

- (void)removeKey:(NSInteger)key;

- (NSUInteger)size;

@end

@interface NSIntegerArrayMap : NSObject

- (instancetype)init;

- (instancetype)initWithCapacity:(NSUInteger)capacity;

- (NSIntegerArray*)getKey:(NSInteger)key;

- (void)getKey:(NSInteger)key withReuse:(NSIntegerArray*)reuse;

- (void)addKey:(NSInteger)key withValue:(NSInteger)value;

- (void)removeKey:(NSInteger)key withValue:(NSInteger)value;

- (NSUInteger)size;

@end