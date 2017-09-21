//
//  CKCollection.h
//  CollectionsKit
//
//  Created by Igor Rastvorov on 12/2/14.
//  Copyright (c) 2014 Igor Rastvorov. All rights reserved.
//

@class NSString;
@class NSArray;

/**
 `CKCollection` is a formal protocol for all the adopters that represent a heterogenous collection of objects.
 */
@protocol CKCollection

/// ---------------------------------
/// @name Initializing the collection
/// ---------------------------------

/**
 Initializes an empty list.
 */
-(instancetype) init;

/**
 Initializes a collection with the objects from the specified array.
 This is the designated initializer.
 
 @param array Array of objects to initialize the collection with.
 */
-(instancetype) initWithArray: (NSArray *) array;

/**
 Checks if the collection contatains the specified object.
 @param object Any object that will be compared against the elements in the collection.
 @return BOOL value indicating wheter the specified object is stored in the collection.
 */
-(BOOL) containsObject:(id) object;

/** 
 @return NSString containing objects from the collection.
 */
-(NSString *) description;

/**
 Checks if the collection object equals to any other object.
 @param object Any object that will be compared with the `CKCollection` object.
 @return YES if the passed object adopts to `CKCollection' protocol and all the messages `isEqual:` sent to
        every objectin the collection return YES.
 */
-(BOOL) isEqual:(id) object;

/**
 @return An unsigned integer associated with the collection.
*/
-(NSUInteger) hash;

/**
 Tests `CKCollection` object for emptiness.
 @return YES if there are no objects in the collection.
 */
-(BOOL) isEmpty;

/**
 Removes all objects from the collection.
 */
-(void) clear;

/**
 @return Number of objects in the collection.
 */
-(NSUInteger) size;

/// ------------------------------------------
/// @name Converting to another representation
/// ------------------------------------------

/**
 Converts a collection to the `NSArray` representation.
 
 @return Array containing all objects in the collection
 */
-(NSArray *) toArray;

@end