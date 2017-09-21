//
//  NSIntegerArray.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 14/09/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "NSIntegerCollection.h"

@interface NSIntegerArray () {
	NSInteger *_array;
	NSUInteger _size;
	NSUInteger _max;
}

@end

@implementation NSIntegerArray

- (instancetype)init
{
    return [self initWithCapacity:8];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    if (!(self = [super init])) return self;
    _max = capacity < 1 ? 1 : capacity;
    _size = 0;
    _array = malloc(_max * sizeof(NSInteger));
    return self;
}

- (void)dealloc
{
	free(_array);
}

- (NSInteger)get:(NSUInteger)index
{
	if (index >= _size) return -1;
	return _array[index];
}

- (void)add:(NSInteger)value
{
	if (_max == _size) {
		NSInteger *array = (NSInteger*)realloc(_array, _max * 2 * sizeof(NSInteger));
		if (!array) return;
		_array = array;
		_max *= 2;
	}
	_array[_size++] = value;
}

- (void)add:(NSInteger)value atIndex:(NSUInteger)index
{
	if (_max == _size) {
		NSInteger *array = (NSInteger*)realloc(_array, _max * 2 * sizeof(NSInteger));
		if (!array) return;
		_array = array;
		_max *= 2;
	}
	for (NSUInteger n = _size - 1 ; n >= index ; n--) {
		_array[n+1] = _array[n];
	}
	_array[index] = value;
	_size++;
}

- (void)remove:(NSUInteger)index
{
	if (_size >= index) return;
	_array[index] = _array[--_size];
}

- (void)clear
{
	_size = 0;
}

- (NSUInteger)size
{
	return _size;
}

@end

@interface NSIntegerMap () {
    struct NSIntegerMapEntry **_table;
    NSUInteger _size;
    NSUInteger _max;
}

@end

struct NSIntegerMapEntry {
    NSInteger key;
    NSInteger value;
    struct NSIntegerMapEntry *next;
};

@implementation NSIntegerMap

- (instancetype)init
{
    return [self initWithCapacity:8];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    if (!(self = [super init])) return nil;
    _max = capacity < 1 ? 1 : capacity;
    _size = 0;
    _table = (struct NSIntegerMapEntry**) calloc(_max, sizeof(struct NSIntegerMapEntry*));
    return self;
}

- (void)dealloc
{
    free(_table);
}

+ (NSUInteger)hash:(NSInteger)key
{
    NSInteger h = key;
    h ^= (h >> 20) ^ (h >> 12);
    h = h ^ (h >> 7) ^ (h >> 4);
    return (NSUInteger) h;
}

- (NSInteger)getKey:(NSInteger)key
{
    if (_size == 0) return -1;
    NSUInteger hash = [NSIntegerMap hash:key];
    NSUInteger index = hash % _max;
    struct NSIntegerMapEntry *back = nil, *itable = _table[index];
    if (!itable) return -1;
    while (itable) {
        if (itable->key == key) {
            if (back) {
                back->next = itable->next;
                itable->next = _table[index];
                _table[index] = itable;
            }
            return itable->value;
        }
        back = itable;
        itable = itable->next;
    }
    return -1;
}

- (void)putKey:(NSInteger)key withValue:(NSInteger)value
{
    NSUInteger hash = [NSIntegerMap hash:key];
    NSUInteger index = hash % _max;
    struct NSIntegerMapEntry *back = nil, *itable = _table[index];
    while (itable) {
        if (itable->key == key) {
            if (back) {
                back->next = itable->next;
                itable->next = _table[index];
                _table[index] = itable;
            }
            itable->value = value;
            return;
        }
        back = itable;
        itable = itable->next;
    }
    struct NSIntegerMapEntry *entry = (struct NSIntegerMapEntry*) malloc(sizeof(struct NSIntegerMapEntry));
    entry->key = key;
    entry->value = value;
    entry->next = _table[index];
    _table[index] = entry;
    if (++_size > _max * 32) {
        [self grow:_max * 32];
    }
}

- (void)removeKey:(NSInteger)key
{
    if (_size == 0) return;
    NSUInteger hash = [NSIntegerMap hash:key];
    NSUInteger index = hash % _max;
    struct NSIntegerMapEntry *itable = _table[index];
    if (!itable) return;
    struct NSIntegerMapEntry *back = nil;
    while (itable) {
        if (itable->key == key) {
            if (!back) {
                _table[index] = itable->next;
            } else {
                back->next = itable->next;
            }
            free(itable);
            _size--;
            return;
        }
        back = itable;
        itable = itable->next;
    }
}

- (void)grow:(NSUInteger)max
{
    struct NSIntegerMapEntry **table = (struct NSIntegerMapEntry**) calloc(max, sizeof(struct NSIntegerMapEntry*));
    if (!table) return;
    for (NSUInteger n = 0 ; n < _max ; n++) {
        struct NSIntegerMapEntry *entry = _table[n];
        while (entry) {
            struct NSIntegerMapEntry *next = entry->next;
            NSUInteger hash = [NSIntegerMap hash:entry->key];
            NSUInteger index = hash % max;
            entry->next = table[index];
            table[index] = entry;
            entry = next;
        }
    }
    free(_table);
    _table = table;
    _max = max;
}

- (NSUInteger)size
{
    return _size;
}

@end

@interface NSIntegerArrayMap () {
    struct NSIntegerArrayMapEntry **_table;
    NSUInteger _size;
    NSUInteger _max;
}

@end

struct NSIntegerArrayMapEntry {
    NSInteger key;
    NSInteger value;
    struct NSIntegerArrayMapEntry *next;
};

@implementation NSIntegerArrayMap

- (instancetype)init
{
    return [self initWithCapacity:8];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    if (!(self = [super init])) return nil;
    _max = capacity < 1 ? 1 : capacity;
    _size = 0;
    _table = (struct NSIntegerArrayMapEntry**) calloc(_max, sizeof(struct NSIntegerArrayMapEntry*));
    return self;
}

- (void)dealloc
{
    free(_table);
}

- (NSIntegerArray*)getKey:(NSInteger)key
{
	if (_size == 0) return nil;
	NSUInteger hash = [NSIntegerMap hash:key];
	NSUInteger index = hash % _max;
	struct NSIntegerArrayMapEntry *back = nil, *itable = _table[index];
	if (!itable) return nil;
	NSIntegerArray* result = nil;
	while (itable) {
		if (itable->key == key) {
			if (back) {
				back->next = itable->next;
				itable->next = _table[index];
				_table[index] = itable;
			}
			if (!result) result = [[NSIntegerArray alloc] initWithCapacity:4];
			[result add:itable->value];
		}
		back = itable;
		itable = itable->next;
	}
	return result;
}

- (void)getKey:(NSInteger)key withReuse:(NSIntegerArray*)reuse
{
	[reuse clear];
	if (_size == 0) return;
	NSUInteger hash = [NSIntegerMap hash:key];
	NSUInteger index = hash % _max;
	struct NSIntegerArrayMapEntry *back = nil, *itable = _table[index];
	if (!itable) return;
	while (itable) {
		if (itable->key == key) {
			if (back) {
				back->next = itable->next;
				itable->next = _table[index];
				_table[index] = itable;
			}
			[reuse add:itable->value];
		}
		back = itable;
		itable = itable->next;
	}
}

- (void)addKey:(NSInteger)key withValue:(NSInteger)value
{
    NSUInteger hash = [NSIntegerMap hash:key];
    NSUInteger index = hash % _max;
    struct NSIntegerArrayMapEntry *entry = (struct NSIntegerArrayMapEntry*) malloc(sizeof(struct NSIntegerArrayMapEntry));
    entry->key = key;
    entry->value = value;
    entry->next = _table[index];
    _table[index] = entry;
    if (++_size > _max * 32) {
        [self grow:_max * 32];
    }
}

- (void)removeKey:(NSInteger)key withValue:(NSInteger)value
{
    if (_size == 0) return;
    NSUInteger hash = [NSIntegerMap hash:key];
    NSUInteger index = hash % _max;
    struct NSIntegerArrayMapEntry *itable = _table[index];
    if (!itable) return;
    struct NSIntegerArrayMapEntry *back = nil;
    while (itable) {
        if (itable->key == key && itable->value == value) {
            if (!back) {
                _table[index] = itable->next;
            } else {
                back->next = itable->next;
            }
            free(itable);
            _size--;
            return;
        }
        back = itable;
        itable = itable->next;
    }
}

- (void)grow:(NSUInteger)max
{
    struct NSIntegerArrayMapEntry **table = (struct NSIntegerArrayMapEntry**) calloc(max, sizeof(struct NSIntegerArrayMapEntry*));
    if (!table) return;
    for (NSUInteger n = 0 ; n < _max ; n++) {
        struct NSIntegerArrayMapEntry *entry = _table[n];
        while (entry) {
            struct NSIntegerArrayMapEntry *next = entry->next;
            NSUInteger hash = [NSIntegerMap hash:entry->key];
            NSUInteger index = hash % max;
            entry->next = table[index];
            table[index] = entry;
            entry = next;
        }
    }
    free(_table);
    _table = table;
    _max = max;
}

- (NSUInteger)size
{
    return _size;
}

@end
