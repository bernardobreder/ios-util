//
//  CKQueue.h
//  CollectionsKit
//
//  Created by Igor Rastvorov on 12/2/14.
//  Copyright (c) 2014 Igor Rastvorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CKCollection.h"

@protocol CKQueue <CKCollection>

/**
 Adds object to the tail of the queue.
 
 @param object An object to add to tail
 */
-(void) addObjectToTail:(id) object;

/**
 Removes object from the head of the queue.
 */
-(void) removeObjectFromHead;

/**
 Retrieves object from the head of the queue.
 
 @return Object at head
 */
-(id) objectAtHead;

@end