//
//  DbDatabase.h
//  iDatabase
//
//  Created by Bernardo Breder on 07/06/14.
//  Copyright (c) 2014 Breder Organization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DbDatabase : NSObject

@end

@interface DbTreeMapEntry : NSObject

@property (nonatomic, strong) NSObject *key;

@property (nonatomic, strong) NSObject *value;

@property (nonatomic, strong) DbTreeMapEntry *left;

@property (nonatomic, strong) DbTreeMapEntry *right;

@property (nonatomic, strong) DbTreeMapEntry *parent;

- (DbTreeMapEntry*)successor;

- (DbTreeMapEntry*)predecessor;

@end

@interface DbTreeMap : NSObject

- (id)initWithComparator:(NSComparator)comparator;

- (NSInteger)size;

- (BOOL)isEmpty;

- (BOOL)has:(NSObject*)key;

- (NSObject*)get:(NSObject*)key;

- (DbTreeMapEntry*)getEntry:(NSObject*)key;

- (DbTreeMapEntry*)first;

- (DbTreeMapEntry*)last;

- (NSObject*)put:(NSObject*)key value:(NSObject*)value;

- (NSObject*)remove:(NSObject*)key;

- (void)clear;

@end

@protocol DbTableTreeIODelegator <NSObject>

@required

- (NSData*)readNode:(NSString*)name id:(SInt64)id;

- (void)writeNode:(NSString*)name id:(SInt64)id data:(NSData*)data;

- (NSData*)readStructure:(NSString*)name;

- (void)writeStructure:(NSString*)name data:(NSData*)data;

- (BOOL)hasStructure:(NSString*)name;

@end

@interface DbTableTreeNode : NSObject

@end

@interface DbTableTree : NSObject

- (id)initCreate:(id<DbTableTreeIODelegator>)ioDelegator name:(NSString*)name order:(int)order;

- (id)initOpen:(id<DbTableTreeIODelegator>)ioDelegator name:(NSString*)name;

- (void)writeStructure:(NSMutableData*)data;

- (NSData*)readStructure;

@end