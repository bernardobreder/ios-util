//
//  CKStack.h
//  CollectionsKit
//
//  Created by Igor Rastvorov on 12/2/14.
//  Copyright (c) 2014 Igor Rastvorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKCollection.h"
#import "CKList.h"

@interface CKStack : NSObject <CKCollection> {
    id <CKList> _objects;
}

@property(nonatomic, assign) NSUInteger sizeLimit;

/**
 Initializes an empty stack with the size limit.
 
 @param sizeLimit The limit by which the stack may grow.
 */
-(instancetype) initWithSizeLimit:(NSUInteger) sizeLimit;

/**
 The designated initializer.
 Initializes a stack with the objects from the given array and sets a size limit.
 
 @param array The array objects from which are pushed into the stack.
 @param sizeLimit The limit by which the stack may grow.
 */
-(instancetype) initWithArray:(NSArray *) array sizeLimit:(NSUInteger) sizeLimit;

/**
 Pushes an object to the stack.
 
 @param object An object to push into the stack
 */
-(void) push:(id) object;

/**
 Removes object from the head of stack.
 */
-(void) pop;

/**
 Retrieves object from the head of stack.
 
 @return Object at the head of stack
 */
-(id) top;

@end