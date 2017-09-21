//
//  DBDatabase.h
//  iBandeiraSimple
//
//  Created by Bernardo Breder on 03/09/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DB_ORDER 32

@protocol DBStorage <NSObject>

- (void)writeData:(NSData*)data andName:(NSString*)name andId:(NSUInteger)sequence;

- (void)removeDataWithName:(NSString*)name andId:(NSUInteger)sequence;

- (BOOL)hasDataWithName:(NSString*)name andId:(NSUInteger)sequence;

- (NSData*)readDataWithName:(NSString*)name andId:(NSUInteger)sequence;

@end

@interface DBInput : NSObject

- (instancetype)initWithData:(NSData*)data;

- (void)reset;

- (void)reset:(NSData*)data;

- (unsigned int)readUInt32;

- (bool)readBool;

- (NSString*)readString;

- (NSData*)readData;

- (NSData*)data;

- (bool)eof;

@end

@interface DBOutput : NSObject

- (DBOutput*)writeUInt32:(unsigned int)value;

- (DBOutput*)writeBool:(bool)value;

- (DBOutput*)writeString:(NSString*)value;

- (DBOutput*)writeData:(NSData*)value;

- (DBOutput*)open;

- (DBOutput*)close;

- (DBInput*)input;

- (NSData*)data;

@end

@interface DBTableNode : NSObject {
	@package
	int id;
	bool is_leaf;
	__strong NSObject *parent;
	uint32_t parentId;
	uint32_t size;
	uint32_t keys[DB_ORDER];
	uint32_t pointerIds[DB_ORDER+1];
	__strong NSObject *pointers[DB_ORDER+1];
	bool changed;
}

- (instancetype)initWithSequence:(uint32_t)sequence;

- (instancetype)initLeafNodeWithSequence:(uint32_t)sequence;

- (instancetype)initFromNode:(uint32_t)id value:(DBInput*)value sequence:(uint32_t)sequence;

- (instancetype)initFromNode:(DBTableNode*)left key:(uint32_t)id right:(DBTableNode*)right sequence:(uint32_t)sequence;

- (instancetype)initWithInput:(DBInput*)input;

@end

@interface DBTable : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, weak) id<DBStorage> storage;

@property (nonatomic, assign) uint32_t size;

@property (nonatomic, assign) uint32_t sequence;

@property (nonatomic, strong) DBTableNode *root;

@property (nonatomic, assign) BOOL changed;

- (id)initWithName:(NSString*)name storage:(id<DBStorage>)storage;

- (DBInput*)search:(uint32_t)id;

- (void)insert:(uint32_t)id value:(DBInput*)value;

- (void)clear;

- (void)commit;

- (void)rollback;

@end

@interface DBIndex : NSObject

@property (nonatomic, strong) NSString *name;

- (id)initWithName:(NSString*)name;

- (NSUInteger)search:(NSUInteger)id;

- (BOOL)insert:(NSUInteger)id value:(NSUInteger)value;

- (void)clear;

- (void)commit;

- (void)rollback;

@end