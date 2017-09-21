//
//  CKListQueue.h
//  CollectionsKit
//
//  Created by Igor Rastvorov on 12/2/14.
//  Copyright (c) 2014 Igor Rastvorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKQueue.h"
#import "CKList.h"

/**
 Represents a queue of objects.
 Internally emplemented as `CKArrayList`.
 */
@interface CKListQueue : NSObject <CKQueue> {
    id <CKList> _objects;
}

@end