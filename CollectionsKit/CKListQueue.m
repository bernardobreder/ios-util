//
//  CKListQueue.m
//  CollectionsKit
//
//  Created by Igor Rastvorov on 12/2/14.
//  Copyright (c) 2014 Igor Rastvorov. All rights reserved.
//

#import "CKListQueue.h"
#import "CKArrayList.h"

@implementation CKListQueue

#pragma mark - Initializing

#pragma mark - CKCollection

-(instancetype) init {
    return [self initWithArray:nil];
}

-(instancetype) initWithArray:(NSArray *) array {
    self = [super init];
    if (self) {
        _objects = [[CKArrayList alloc] initWithArray:array];
    }
    
    return self;
}

#pragma mark - Adding objects

-(void) addObjectToTail:(id) object {
    [_objects addObjectToTail:object];
}

-(id) objectAtHead {
    return [_objects objectAtHead];
}

#pragma mark - Removing objects

-(void) removeObjectFromHead {
    [_objects removeObjectFromHead];
}

#pragma mark - CKCollection

-(void) clear {
    [_objects clear];
}

#pragma mark - List state

#pragma mark - CKCollection

-(NSUInteger) size {
    return [_objects size];
}

-(BOOL) isEmpty {
    return [_objects isEmpty];
}

-(NSString *) description {
    return [_objects description];
}

-(BOOL) isEqual:(id)object {
    return [_objects isEqual:object];
}

-(BOOL) containsObject:(id)object {
    return [_objects containsObject:object];
}

-(NSUInteger) hash {
    if ([self isEmpty]) {
        return [super hash];
    }
    
    NSUInteger hashCode = [[_objects objectAtIndex:0] hash];
    for (NSUInteger i = 1; i < [self size]; ++i) {
        hashCode ^= [[_objects objectAtIndex:i] hash];
    }
    
    return hashCode;
}

-(NSArray *) toArray {
    return [_objects toArray];
}

@end