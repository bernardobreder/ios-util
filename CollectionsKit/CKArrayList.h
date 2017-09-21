//
//  CKArrayList.h
//  CollectionsKit
//
//  Created by Igor Rastvorov on 12/12/14.
//  Copyright (c) 2014 The. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKList.h"

/**
 Represents a list of objects structured in the array.
 */
@interface CKArrayList : NSObject <CKCollection, CKList> {
    NSMutableArray *_array;
}

@end