//
//  NSTree.h
//  iSql
//
//  Created by Bernardo Breder on 31/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

@class NSTreeNode;

@interface NSTree : NSObject {
	@package
	NSTreeNode* root;
}

@property (nonatomic, assign) NSUInteger size;

- (bool)add:(NSInteger)key value:(NSObject*)value;

- (NSObject*)get:(NSInteger)key;

- (bool)set:(NSInteger)key value:(NSObject*)value;

- (bool)remove:(NSInteger)key;

- (bool)isEmpty;

- (void)clear;

- (NSTreeNode*)first;

- (NSTreeNode*)getNode:(NSInteger)key;

@end

@interface NSTreeNode : NSObject {
	@package
	NSInteger key;
	NSObject* value;
	NSTreeNode* left;
	NSTreeNode* right;
	NSTreeNode* parent;
	bool black;
}

- (NSTreeNode*)next;

- (void)clear;

@end