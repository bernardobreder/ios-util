//
//  CKArrayList.m
//  CollectionsKit
//
//  Created by Igor Rastvorov on 12/12/14.
//  Copyright (c) 2014 The. All rights reserved.
//

#import "CKArrayList.h"

static const unsigned int LIST_HEAD_INDEX = 0;

@implementation CKArrayList

#pragma mark - Initializers

#pragma mark - CKCollection

-(instancetype) init {
    return [self initWithArray: nil];
}

-(instancetype) initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        if (array != nil) {
            _array = [NSMutableArray arrayWithArray:array];
        }
    }
    
    return self;
}

#pragma mark - Adding objects

-(void) addObjectToHead:(id)object {
    [_array insertObject:object atIndex:LIST_HEAD_INDEX];
}

-(void) addObjectToTail:(id)object {
    [_array addObject:object];
}

#pragma mark - Retrieving objects and indexes

-(id) objectAtHead {
    return [_array firstObject];
}

-(id) objectAtTail {
    return [_array lastObject];
}

-(id) objectAtIndex:(NSUInteger) index {
    return [_array objectAtIndex:index];
}

-(NSUInteger) indexOfObject:(id)object {
    return [_array indexOfObject:object];
}

-(NSUInteger) lastIndexOfObject:(id) object {
    for (NSUInteger index = [_array count]; index != 0; --index) {
        if ([[_array objectAtIndex:index] isEqual: object]) {
            return index;
        }
    }
    
    return NSNotFound;
}

-(id <CKList>) sublistWithRange:(NSRange) range {
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:range];
    
    return [[CKArrayList alloc] initWithArray:[_array objectsAtIndexes:indexes]];
}

#pragma mark - Removing objects

-(void) removeObjectFromHead {
    [_array removeObjectAtIndex:LIST_HEAD_INDEX];
}

-(void) removeObjectFromTail {
    [_array removeLastObject];
}

-(void) removeObjectAtIndex:(NSUInteger) index {
    [_array removeObjectAtIndex:index];
}

#pragma mark - CKCollection

-(void) clear {
    [_array removeAllObjects];
}

#pragma mark List state

#pragma mark - CKCollection

-(NSUInteger) size {
    return [_array count];
}

-(NSString *) description {
    return [_array description];
}

-(BOOL) isEmpty {
    return ([_array count] == 0);
}

-(BOOL) isEqual:(id) object {
    return [_array isEqual:object];
}

-(BOOL) containsObject:(id) object {
    return [_array containsObject:object];
}

-(NSUInteger) hash {
    if ([self isEmpty]) {
        return [super hash];
    }
    
    NSUInteger hashCode = [[self objectAtIndex:0] hash];
    for (NSUInteger i = 1; i < [self size]; ++i) {
        hashCode ^= [[self objectAtIndex:i] hash];
    }
    
    return hashCode;
}

-(NSArray *) toArray {
    return [_array copy];
}

@end
