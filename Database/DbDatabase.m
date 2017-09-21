//
//  DbDatabase.m
//  iDatabase
//
//  Created by Bernardo BDBTREEMAP_DBTREEMAP_REDer on 07/06/14.
//  Copyright (c) 2014 Breder Organization. All rights reserved.
//

#import "DbDatabase.h"

@implementation DbDatabase

@end

@interface DbTreeMapEntry ()

@property (nonatomic, assign) BOOL color;

@end

@implementation DbTreeMapEntry

@synthesize key = _key;
@synthesize value = _value;
@synthesize left = _left;
@synthesize right = _right;
@synthesize parent = _parent;
@synthesize color = _color;

- (DbTreeMapEntry*) successor
{
	if (!_right) {
		DbTreeMapEntry* p = _right;
		while (p.left) {
			p = p.left;
		}
		return p;
	} else {
		DbTreeMapEntry* p = _parent;
		DbTreeMapEntry* ch = self;
		while (p && ch == p.right) {
			ch = p;
			p = p.parent;
		}
		return p;
	}
}

- (DbTreeMapEntry*)predecessor
{
	if (_left) {
		DbTreeMapEntry* p = _left;
		while (p.right) {
			p = p.right;
		}
		return p;
	} else {
		DbTreeMapEntry* p = _parent;
		DbTreeMapEntry* ch = self;
		while (p && ch == p.left) {
			ch = p;
			p = p.parent;
		}
		return p;
	}
}

- (void)clear
{
	_key = nil;
	_value = nil;
	_parent = nil;
	[_left clear];
	[_right clear];
}

@end

@interface DbTreeMap ()

@property (nonatomic, strong) DbTreeMapEntry* root;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, strong) NSComparator comparator;

@end

@implementation DbTreeMap

@synthesize root = _root;
@synthesize size = _size;
@synthesize comparator = _comparator;

#define DBTREEMAP_RED false
#define DBTREEMAP_BLACK true
#define DBTREEMAP_SET_COLOR(p,c) if (p) { p.color = c; }
#define DBTREEMAP_COLOR(p) (!p ? DBTREEMAP_BLACK: p.color)
#define DBTREEMAP_RIGHT(p) (!p ? 0: p.right)
#define DBTREEMAP_LEFT(p) (!p ? 0: p.left)
#define DBTREEMAP_PARENT(p) (!p ? 0: p.parent)

- (id)initWithComparator:(NSComparator)comparator
{
	if (!(self = [super init])) return nil;
	_comparator = comparator;
	return self;
}

- (BOOL)isEmpty
{
	return _size == 0;
}

- (BOOL)has:(NSObject*)key
{
	return [self getEntry:key] != nil;
}

- (NSObject*)get:(NSObject*)key
{
	DbTreeMapEntry* p = [self getEntry:key];
	return p ? nil : p.value;
}

- (DbTreeMapEntry*)getEntry:(NSObject*)key
{
	if (!key) {
		return nil;
	}
	NSObject* k = key;
	DbTreeMapEntry* p = _root;
	while (p) {
		NSInteger cmp = _comparator(k, p.key);
		if (cmp < 0) {
			p = p.left;
		} else if (cmp > 0) {
			p = p.right;
		} else {
			return p;
		}
	}
	return nil;
}

- (DbTreeMapEntry*)first
{
	DbTreeMapEntry* p = _root;
	if (p) {
		while (p.left) {
			p = p.left;
		}
	}
	return p;
}

- (DbTreeMapEntry*)last
{
	DbTreeMapEntry* p = _root;
	if (p) {
		while (p.right) {
			p = p.right;
		}
	}
	return p;
}

- (NSObject*)put:(NSObject*)key value:(NSObject*)value
{
	if (!key) {
		return nil;
	}
	DbTreeMapEntry* node = _root;
	if (!node) {
		_root = [[DbTreeMapEntry alloc] init];
		_root.key = key;
		_root.value = value;
		_size = 1;
		return nil;
	}
	NSInteger cmp;
	DbTreeMapEntry* parent;
	do {
		parent = node;
		cmp = _comparator(key, node.key);
		if (cmp < 0) {
			node = node.left;
		} else if (cmp > 0) {
			node = node.right;
		} else {
			NSObject* result = node.value;
			node.value = value;
			return result;
		}
	} while (node);
	DbTreeMapEntry* e = [[DbTreeMapEntry alloc] init];
	e.key = key;
	e.value = value;
	e.parent = parent;
	if (cmp < 0) {
		parent.left = e;
	} else {
		parent.right = e;
	}
	[self fixAfterInsertion:e];
	_size++;
	return nil;
}

- (NSObject*)remove:(NSObject*)key
{
	DbTreeMapEntry* p = [self getEntry:key];
	if (!p) {
		return nil;
	}
	NSObject* oldValue = p.value;
	[self deleteEntry:p];
	return oldValue;
}

- (void)deleteEntry:(DbTreeMapEntry*) p
{
	_size--;
	if (p.left && p.right) {
		DbTreeMapEntry* s = [p successor];
		p.key = s.key;
		p.value = s.value;
		p = s;
	}
	DbTreeMapEntry* replacement = (p.left ? p.left : p.right);
	if (replacement) {
		replacement.parent = p.parent;
		if (!p.parent) {
			_root = replacement;
		} else if (p == p.parent.left) {
			p.parent.left = replacement;
		} else {
			p.parent.right = replacement;
		}
		p.left = p.right = p.parent = nil;
		if (p.color == DBTREEMAP_BLACK) {
			[self fixAfterDeletion:replacement];
		}
	} else if (!p.parent) {
		_root = nil;
	} else {
		if (p.color == DBTREEMAP_BLACK) {
			[self fixAfterDeletion:p];
		}
		if (p.parent) {
			if (p == p.parent.left) {
				p.parent.left = nil;
			} else if (p == p.parent.right) {
				p.parent.right = nil;
			}
			p.parent = nil;
		}
	}
}

- (void)clear
{
	_size = 0;
	if (_root) {
		[_root clear];
		_root = nil;
	}
}

- (void)rotateLeft:(DbTreeMapEntry*)p
{
	if (p) {
		DbTreeMapEntry* r = p.right;
		p.right = r.left;
		if (r.left) {
			r.left.parent = p;
		}
		r.parent = p.parent;
		if (!p.parent) {
			_root = r;
		} else if (p.parent.left == p) {
			p.parent.left = r;
		} else {
			p.parent.right = r;
		}
		r.left = p;
		p.parent = r;
	}
}

- (void)rotateRight:(DbTreeMapEntry*)p
{
	if (p) {
		DbTreeMapEntry* l = p.left;
		p.left = l.right;
		if (l.right) {
			l.right.parent = p;
		}
		l.parent = p.parent;
		if (!p.parent) {
			_root = l;
		} else if (p.parent.right == p) {
			p.parent.right = l;
		} else {
			p.parent.left = l;
		}
		l.right = p;
		p.parent = l;
	}
}

- (void)fixAfterInsertion:(DbTreeMapEntry*)x
{
	x.color = DBTREEMAP_RED;
	while (x && x != _root && x.parent.color == DBTREEMAP_RED) {
		if (DBTREEMAP_PARENT(x) == DBTREEMAP_LEFT(DBTREEMAP_PARENT(DBTREEMAP_PARENT(x)))) {
			DbTreeMapEntry* y = DBTREEMAP_RIGHT(DBTREEMAP_PARENT(DBTREEMAP_PARENT(x)));
			if (DBTREEMAP_COLOR(y) == DBTREEMAP_RED) {
				DBTREEMAP_SET_COLOR(DBTREEMAP_PARENT(x), DBTREEMAP_BLACK);
				DBTREEMAP_SET_COLOR(y, DBTREEMAP_BLACK);
				DBTREEMAP_SET_COLOR(DBTREEMAP_PARENT(DBTREEMAP_PARENT(x)), DBTREEMAP_RED);
				x = DBTREEMAP_PARENT(DBTREEMAP_PARENT(x));
			} else {
				if (x == DBTREEMAP_RIGHT(DBTREEMAP_PARENT(x))) {
					x = DBTREEMAP_PARENT(x);
					[self rotateLeft:x];
				}
				DBTREEMAP_SET_COLOR(DBTREEMAP_PARENT(x), DBTREEMAP_BLACK);
				DBTREEMAP_SET_COLOR(DBTREEMAP_PARENT(DBTREEMAP_PARENT(x)), DBTREEMAP_RED);
				[self rotateRight:DBTREEMAP_PARENT(DBTREEMAP_PARENT(x))];
			}
		} else {
			DbTreeMapEntry* y = DBTREEMAP_LEFT(DBTREEMAP_PARENT(DBTREEMAP_PARENT(x)));
			if (DBTREEMAP_COLOR(y) == DBTREEMAP_RED) {
				DBTREEMAP_SET_COLOR(DBTREEMAP_PARENT(x), DBTREEMAP_BLACK);
				DBTREEMAP_SET_COLOR(y, DBTREEMAP_BLACK);
				DBTREEMAP_SET_COLOR(DBTREEMAP_PARENT(DBTREEMAP_PARENT(x)), DBTREEMAP_RED);
				x = DBTREEMAP_PARENT(DBTREEMAP_PARENT(x));
			} else {
				if (x == DBTREEMAP_LEFT(DBTREEMAP_PARENT(x))) {
					x = DBTREEMAP_PARENT(x);
					[self rotateRight:x];
				}
				DBTREEMAP_SET_COLOR(DBTREEMAP_PARENT(x), DBTREEMAP_BLACK);
				DBTREEMAP_SET_COLOR(DBTREEMAP_PARENT(DBTREEMAP_PARENT(x)), DBTREEMAP_RED);
				[self rotateLeft:DBTREEMAP_PARENT(DBTREEMAP_PARENT(x))];
			}
		}
	}
	_root.color = DBTREEMAP_BLACK;
}

- (void) fixAfterDeletion:(DbTreeMapEntry*)x
{
	while (x != _root && DBTREEMAP_COLOR(x) == DBTREEMAP_BLACK) {
		if (x == DBTREEMAP_LEFT(DBTREEMAP_PARENT(x))) {
			DbTreeMapEntry* sib = DBTREEMAP_RIGHT(DBTREEMAP_PARENT(x));
			if (DBTREEMAP_COLOR(sib) == DBTREEMAP_RED) {
				DBTREEMAP_SET_COLOR(sib, DBTREEMAP_BLACK);
				DBTREEMAP_SET_COLOR(DBTREEMAP_PARENT(x), DBTREEMAP_RED);
				[self rotateLeft:DBTREEMAP_PARENT(x)];
				sib = DBTREEMAP_RIGHT(DBTREEMAP_PARENT(x));
			}
			if (DBTREEMAP_COLOR(DBTREEMAP_LEFT(sib)) == DBTREEMAP_BLACK && DBTREEMAP_COLOR(DBTREEMAP_RIGHT(sib)) == DBTREEMAP_BLACK) {
				DBTREEMAP_SET_COLOR(sib, DBTREEMAP_RED);
				x = DBTREEMAP_PARENT(x);
			} else {
				if (DBTREEMAP_COLOR(DBTREEMAP_RIGHT(sib)) == DBTREEMAP_BLACK) {
					DBTREEMAP_SET_COLOR(DBTREEMAP_LEFT(sib), DBTREEMAP_BLACK);
					DBTREEMAP_SET_COLOR(sib, DBTREEMAP_RED);
					[self rotateRight:sib];
					sib = DBTREEMAP_RIGHT(DBTREEMAP_PARENT(x));
				}
				DBTREEMAP_SET_COLOR(sib, DBTREEMAP_COLOR(DBTREEMAP_PARENT(x)));
				DBTREEMAP_SET_COLOR(DBTREEMAP_PARENT(x), DBTREEMAP_BLACK);
				DBTREEMAP_SET_COLOR(DBTREEMAP_RIGHT(sib), DBTREEMAP_BLACK);
				[self rotateLeft:DBTREEMAP_PARENT(x)];
				x = _root;
			}
		} else {
			DbTreeMapEntry* sib = DBTREEMAP_LEFT(DBTREEMAP_PARENT(x));
			if (DBTREEMAP_COLOR(sib) == DBTREEMAP_RED) {
				DBTREEMAP_SET_COLOR(sib, DBTREEMAP_BLACK);
				DBTREEMAP_SET_COLOR(DBTREEMAP_PARENT(x), DBTREEMAP_RED);
				[self rotateRight:DBTREEMAP_PARENT(x)];
				sib = DBTREEMAP_LEFT(DBTREEMAP_PARENT(x));
			}
			if (DBTREEMAP_COLOR(DBTREEMAP_RIGHT(sib)) == DBTREEMAP_BLACK && DBTREEMAP_COLOR(DBTREEMAP_LEFT(sib)) == DBTREEMAP_BLACK) {
				DBTREEMAP_SET_COLOR(sib, DBTREEMAP_RED);
				x = DBTREEMAP_PARENT(x);
			} else {
				if (DBTREEMAP_COLOR(DBTREEMAP_LEFT(sib)) == DBTREEMAP_BLACK) {
					DBTREEMAP_SET_COLOR(DBTREEMAP_RIGHT(sib), DBTREEMAP_BLACK);
					DBTREEMAP_SET_COLOR(sib, DBTREEMAP_RED);
					[self rotateLeft:sib];
					sib = DBTREEMAP_LEFT(DBTREEMAP_PARENT(x));
				}
				DBTREEMAP_SET_COLOR(sib, DBTREEMAP_COLOR(DBTREEMAP_PARENT(x)));
				DBTREEMAP_SET_COLOR(DBTREEMAP_PARENT(x), DBTREEMAP_BLACK);
				DBTREEMAP_SET_COLOR(DBTREEMAP_LEFT(sib), DBTREEMAP_BLACK);
				[self rotateRight:DBTREEMAP_PARENT(x)];
				x = _root;
			}
		}
	}
	DBTREEMAP_SET_COLOR(x, DBTREEMAP_BLACK);
}

@end

@interface DbTableTree ()

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) int order;

@property (nonatomic, assign) SInt64 sequence;

@property (nonatomic, strong) DbTableTreeNode *root;

@property (nonatomic, assign) BOOL structureChanged;

@property (nonatomic, assign) BOOL dataChanged;

@property (nonatomic, weak) id<DbTableTreeIODelegator> io;

@end

@implementation DbTableTree

@end