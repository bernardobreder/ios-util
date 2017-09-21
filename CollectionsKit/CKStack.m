//
//  CKStack.m
//  CollectionsKit
//
//  Created by Igor Rastvorov on 12/2/14.
//  Copyright (c) 2014 Igor Rastvorov. All rights reserved.
//

#import "CKStack.h"
#import "CKLinkedList.h"

static const NSUInteger NO_STACK_SIZE_LIMIT = 0;

@implementation CKStack

@synthesize sizeLimit = _sizeLimit;

#pragma mark - Initializing

-(instancetype) initWithSizeLimit:(NSUInteger) sizeLimit {
    return [self initWithArray:nil sizeLimit:sizeLimit];
}

-(instancetype) initWithArray:(NSArray *) array sizeLimit:(NSUInteger) sizeLimit {
    self = [super init];
    if (self) {
        _objects = [[CKLinkedList alloc] initWithArray:array];
        self.sizeLimit = sizeLimit;
    }
    
    return self;
}

#pragma mark - CKCollection

-(instancetype)init {
    return [self initWithArray:nil sizeLimit:NO_STACK_SIZE_LIMIT];
}

-(instancetype) initWithArray:(NSArray *) array {
    return [self initWithArray:array sizeLimit:NO_STACK_SIZE_LIMIT];
}

#pragma mark - Adding object

-(void) push:(id) object {
    if (self.sizeLimit == _objects.size) {
        NSException *sizeLimitExceedException = [NSException
                                                 exceptionWithName:@"StackSizeLimitExceeded"
                                                 reason:@"Attempt to push more elements than size limit permits"
                                                 userInfo:nil];
        @throw sizeLimitExceedException;
    }
    
    [_objects addObjectToHead:object];
}

#pragma mark - Retrieving object

-(id) top {
    return [_objects objectAtHead];
}

#pragma mark - Removing objects

-(void) pop {
    [_objects removeObjectFromHead];
}

#pragma mark - CKCollection

-(void) clear {
    [_objects clear];
}

#pragma - Queue state

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

-(NSArray *) toArray {
    return [_objects toArray];
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

@end
