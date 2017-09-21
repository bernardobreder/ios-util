
//  DBDatabase.m
//  iBandeiraSimple
//
//  Created by Bernardo Breder on 03/09/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "DBDatabase.h"

@implementation DBTable

@synthesize name = _name;

- (id)initWithName:(NSString*)name storage:(id<DBStorage>)storage
{
    if (!(self = [super init])) return nil;
    _name = name;
    _size = 0;
	_sequence = 0;
    _storage = storage;
    if ([_storage hasDataWithName:name andId:0]) {
        NSData *data = [storage readDataWithName:name andId:0];
        DBInput *input = [[DBInput alloc] initWithData:data];
		_size = [input readUInt32];
		_sequence = [input readUInt32];
        _root = [[DBTableNode alloc] initWithInput:[[DBInput alloc] initWithData:[storage readDataWithName:name andId:[input readUInt32]]]];
    }
    return self;
}

- (DBTableNode*)readChild:(DBTableNode*)node atIndex:(uint32_t)index
{
	if (node->pointers[index] == nil) {
		uint32_t id = node->pointerIds[index];
		if (!id) return nil;
		NSData *data = [_storage readDataWithName:_name andId:id];
        DBInput *input = [[DBInput alloc] initWithData:data];
		node->pointers[index] = [[DBTableNode alloc] initWithInput:input];
	}
	return (DBTableNode*) node->pointers[index];
}

- (DBTableNode*)searchLeafNode:(DBTableNode*)root id:(uint32_t)id
{
    DBTableNode* node = root;
    if (!node) return node;
    while (!node->is_leaf) {
        int i = 0;
        while (i < node->size) {
            if (node->keys[i] <= id) i++;
            else break;
        }
        node = [self readChild:node atIndex:i];
    }
    return node;
}

- (DBInput*)search:(uint32_t)id
{
    DBTableNode* leafNode = [self searchLeafNode:_root id:id];
    if (!leafNode) return nil;
    int i;
    for (i = 0; i < leafNode->size; i++) {
        if (leafNode->keys[i] == id) break;
    }
    if (i == leafNode->size) return 0;
	DBInput* input = (DBInput*) leafNode->pointers[i];
	[input reset];
	return input;
}

- (NSUInteger)nodeCut:(NSUInteger)length
{
    if (length % 2 == 0) return length / 2;
    else return length / 2 + 1;
}

- (DBTableNode*)insertIntoLeaf:(DBTableNode*)leaf id:(uint32_t)id pointer:(NSObject*)pointer
{
    NSUInteger i, insertion_point = 0;
    while (insertion_point < leaf->size && leaf->keys[insertion_point] < id)
        insertion_point++;
    for (i = leaf->size; i > insertion_point; i--) {
        leaf->keys[i] = leaf->keys[i - 1];
        leaf->pointers[i] = leaf->pointers[i - 1];
    }
    leaf->keys[insertion_point] = id;
    leaf->pointers[insertion_point] = pointer;
    leaf->size++;
    leaf->changed = 1;
    return leaf;
}

- (DBTableNode*)insertIntoLeafAfterSplitting:(DBTableNode*)root leaf:(DBTableNode*)leaf id:(uint32_t)id pointer:(NSObject*)pointer
{
    NSUInteger insertion_index, split, i, j;
    uint32_t temp_keys[DB_ORDER];
    __strong NSObject* temp_pointers[DB_ORDER];
    DBTableNode* new_leaf = [[DBTableNode alloc] initLeafNodeWithSequence:++_sequence];
    if (!new_leaf) return 0;
    insertion_index = 0;
    while (insertion_index < DB_ORDER - 1 && leaf->keys[insertion_index] < id)
        insertion_index++;
    for (i = 0, j = 0; i < leaf->size; i++, j++) {
        if (j == insertion_index) j++;
        temp_keys[j] = leaf->keys[i];
        temp_pointers[j] = leaf->pointers[i];
    }
    temp_keys[insertion_index] = id;
    temp_pointers[insertion_index] = pointer;
    leaf->size = 0;
    split = [self nodeCut:(DB_ORDER - 1)];
    for (i = 0; i < split; i++) {
        leaf->pointers[i] = temp_pointers[i];
        leaf->keys[i] = temp_keys[i];
        leaf->size++;
    }
    for (i = split, j = 0; i < DB_ORDER; i++, j++) {
        new_leaf->pointers[j] = temp_pointers[i];
        new_leaf->keys[j] = temp_keys[i];
        new_leaf->size++;
    }
    new_leaf->pointers[DB_ORDER - 1] = leaf->pointers[DB_ORDER - 1];
    new_leaf->pointerIds[DB_ORDER - 1] = leaf->pointerIds[DB_ORDER - 1];
    leaf->pointers[DB_ORDER - 1] = new_leaf;
    leaf->pointerIds[DB_ORDER - 1] = new_leaf->id;
    new_leaf->parent = leaf->parent;
    new_leaf->parentId = leaf->parentId;
    uint32_t new_key = new_leaf->keys[0];
    leaf->changed = 1;
    new_leaf->changed = 1;
    return [self insertIntoParent:root left:leaf id:new_key right:new_leaf];
}

- (DBTableNode*)insertIntoNode:(DBTableNode*)root node:(DBTableNode*)node leftIndex:(NSUInteger)left_index id:(uint32_t)id right:(DBTableNode*)right
{
    NSUInteger i;
    for (i = node->size; i > left_index; i--) {
        node->pointers[i + 1] = node->pointers[i];
        node->pointerIds[i + 1] = node->pointerIds[i];
        node->keys[i] = node->keys[i - 1];
    }
    node->pointers[left_index + 1] = right;
    node->pointerIds[left_index + 1] = right->id;
    node->keys[left_index] = id;
    node->size++;
    node->changed = 1;
    right->changed = 1;
    return root;
}

- (DBTableNode*)insertIntoNodeAfterSplitting:(DBTableNode*)root oldNode:(DBTableNode*)left leftIndex:(NSUInteger)leftIndex id:(uint32_t)id right:(DBTableNode*)right
{
    NSUInteger i, j;
    NSNull *null = [NSNull null];
    uint32_t temp_keys[DB_ORDER], temp_pointerIds[DB_ORDER+1];
    NSObject *temp_pointers[DB_ORDER+1];
    for (NSUInteger n = 0 ; n < DB_ORDER + 1 ; n++) {
        temp_pointers[n] = null;
    }
    for (i = 0, j = 0; i < left->size + 1; i++, j++) {
        if (j == leftIndex + 1) j++;
        temp_pointers[j] = left->pointers[i];
        temp_pointerIds[j] = left->pointerIds[i];
    }
    for (i = 0, j = 0; i < left->size; i++, j++) {
        if (j == leftIndex) j++;
        temp_keys[j] = left->keys[i];
    }
    temp_pointers[leftIndex + 1] = right;
    temp_pointerIds[leftIndex + 1] = right->id;
    temp_keys[leftIndex] = id;
    NSUInteger split = [self nodeCut:DB_ORDER];
    DBTableNode* new_node = [[DBTableNode alloc] initWithSequence:++_sequence];
    if (!new_node) return 0;
    left->size = 0;
    for (i = 0; i < split - 1; i++) {
        left->pointers[i] = temp_pointers[i];
        left->pointerIds[i] = temp_pointerIds[i];
        left->keys[i] = temp_keys[i];
        left->size++;
    }
    left->pointers[i] = temp_pointers[i];
	left->pointerIds[i] = temp_pointerIds[i];
    uint32_t k_prime = temp_keys[split - 1];
    for (++i, j = 0; i < DB_ORDER; i++, j++) {
        new_node->pointers[j] = temp_pointers[i];
        new_node->pointerIds[j] = temp_pointerIds[i];
        new_node->keys[j] = temp_keys[i];
        new_node->size++;
    }
    new_node->pointers[j] = temp_pointers[i];
    new_node->pointerIds[j] = temp_pointerIds[i];
    new_node->parent = left->parent;
	new_node->parentId = left->parentId;
    for (i = 0; i <= new_node->size; i++) {
        DBTableNode* child = (DBTableNode*) new_node->pointers[i];
        child->parent = new_node;
        child->parentId = new_node->id;
    }
    new_node->changed = 1;
    left->changed = 1;
    right->changed = 1;
    return [self insertIntoParent:root left:left id:k_prime right:new_node];
}

- (DBTableNode*)insertIntoParent:(DBTableNode*)root left:(DBTableNode*)left id:(uint32_t)id right:(DBTableNode*)right
{
    DBTableNode* parent = (DBTableNode*) left->parent;
    if (parent == 0) return [[DBTableNode alloc] initFromNode:left key:id right:right sequence:++_sequence];
    uint32_t left_index = [self leftIndex:parent left:left];
    if (parent->size < DB_ORDER - 1) return [self insertIntoNode:root node:parent leftIndex:left_index id:id right:right];
    return [self insertIntoNodeAfterSplitting:root oldNode:parent leftIndex:left_index id:id right:right];
}

- (uint32_t)leftIndex:(DBTableNode*)parent left:(DBTableNode*)left
{
    int left_index = 0;
    while (left_index <= parent->size && parent->pointers[left_index] != left)
        left_index++;
    return left_index;
}

- (DBTableNode*)insert:(DBTableNode*)root key:(uint32_t)id value:(DBInput*)value
{
    if ([self search:(id)]) return root;
    if (!root) return [[DBTableNode alloc] initFromNode:id value:value sequence:++_sequence];
    DBTableNode* leaf = [self searchLeafNode:root id:id];
    if (leaf->size < DB_ORDER - 1) {
        [self insertIntoLeaf:leaf id:id pointer:value];
        return root;
    }
    return [self insertIntoLeafAfterSplitting:root leaf:leaf id:id pointer:value];
}

- (void)insert:(uint32_t)id value:(DBInput*)value
{
    _root = [self insert:_root key:id value:value];
    _size++;
    _changed = 1;
}

- (void)clear
{
    
}

- (void)commit
{
	if (_changed) {
		{
			DBOutput *output = [[DBOutput alloc] init];
			[output writeUInt32:_size];
			[output writeUInt32:_sequence];
			[output writeUInt32:(!_root ? 0 : _root->id)];
			[_storage writeData:output.data andName:_name andId:0];
		}
		if (_root) [self commit:_root];
	}
}

- (void)commit:(DBTableNode*)node
{
    if (node->changed) {
        DBOutput *output = [[DBOutput alloc] init];
        [output writeUInt32:node->id];
        [output writeBool:node->is_leaf];
        [output writeUInt32:node->parentId];
        [output writeUInt32:node->size];
        for (NSUInteger n = 0 ; n < node->size ; n++) {
            [output writeUInt32:node->keys[n]];
        }
        if (node->is_leaf) {
            for (NSUInteger n = 0 ; n < node->size ; n++) {
                DBInput *input = (DBInput*) node->pointers[n];
                [output writeData:input.data];
            }
        } else {
            for (NSUInteger n = 0 ; n < node->size + 1 ; n++) {
                [output writeUInt32:node->pointerIds[n]];
            }
        }
        [_storage writeData:output.data andName:_name andId:node->id];
    }
    if (!node->is_leaf) {
        for (NSUInteger n = 0 ; n < node->size + 1 ; n++) {
            if (node->pointers[n]) {
                DBTableNode *child = (DBTableNode*) node->pointers[n];
                [self commit:child];
            }
        }
    }
}

- (void)rollback
{
}

@end

@implementation DBTableNode

- (instancetype)initWithSequence:(uint32_t)sequence
{
    if (!(self = [super init])) return nil;
	self->id = sequence;
    self->is_leaf = false;
    self->size = 0;
    self->parent = nil;
    self->changed = 1;
    return self;
}

- (instancetype)initLeafNodeWithSequence:(uint32_t)sequence
{
    if (!(self = [self initWithSequence:sequence])) return nil;
    self->is_leaf = true;
    return self;
}

- (instancetype)initFromNode:(uint32_t)key value:(DBInput*)value sequence:(uint32_t)sequence
{
    if (!(self = [self initLeafNodeWithSequence:sequence])) return nil;
    self->keys[0] = key;
    self->pointers[0] = value;
    self->size++;
    return self;
}

- (instancetype)initFromNode:(DBTableNode*)left key:(uint32_t)key right:(DBTableNode*)right sequence:(uint32_t)sequence
{
    if (!(self = [self initWithSequence:sequence])) return nil;
    self->keys[0] = key;
    self->pointers[0] = left;
	self->pointerIds[0] = left->id;
    self->pointers[1] = right;
	self->pointerIds[1] = right->id;
    self->size++;
    self->parent = 0;
    left->parent = self;
	left->parentId = self->id;
    right->parent = self;
	right->parentId = self->id;
    self->changed = 1;
    left->changed = 1;
    right->changed = 1;
    return self;
}

- (instancetype)initWithInput:(DBInput*)input;
{
    if (!(self = [super init])) return nil;
    self->id = [input readUInt32];
    self->is_leaf = [input readBool];
    self->parentId = [input readUInt32];
    self->size = [input readUInt32];
    for (NSUInteger n = 0 ; n < self->size ; n++) {
        self->keys[n] = [input readUInt32];
    }
    if (self->is_leaf) {
        for (NSUInteger n = 0 ; n < self->size ; n++) {
            NSData *data = [input readData];
            self->pointers[n] = [[DBInput alloc] initWithData:data];
        }
    } else {
        for (NSUInteger n = 0 ; n < self->size + 1 ; n++) {
            self->pointers[n] = nil;
            self->pointerIds[n] = [input readUInt32];
        }
    }
    return self;
}

@end

@interface DBOutput ()

@property (nonatomic, strong) NSMutableData *data;

@end

@implementation DBOutput

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    _data = [[NSMutableData alloc] initWithCapacity:1024];
    return self;
}

- (DBOutput*)writeUInt32:(unsigned int)value
{
    unsigned char bytes[4], *aux = bytes;
    *aux++ = value & 0xFF;
    *aux++ = (value >> 8) & 0xFF;
    *aux++ = (value >> 16) & 0xFF;
    *aux++ = (value >> 24) & 0xFF;
    [_data appendBytes:bytes length:4];
    return self;
}

- (DBOutput*)writeBool:(bool)value
{
    unsigned char bytes[1], *aux = bytes;
    *aux++ = value == true;
    [_data appendBytes:bytes length:1];
    return self;
}

- (DBOutput*)writeString:(NSString*)value
{
    if (value.length > 0xFFFF) return nil;
    unsigned short length = value.length;
    unsigned char bytes[3], *aux = bytes;
    *aux++ = length & 0xFF;
    *aux++ = (length >> 8) & 0xFF;
    [_data appendBytes:bytes length:2];
    for (unsigned short n = 0 ; n < length ; n++) {
        unichar c = [value characterAtIndex:n];
        if (c <= 0x7F) {
            bytes[0] = c;
            [_data appendBytes:bytes length:1];
        }
        else if (c <= 0x7FF) {
            bytes[0] = ((c >> 6) & 0x1F) + 0xC0;
            bytes[1] = (c & 0x3F) + 0x80;
            [_data appendBytes:bytes length:2];
        }
        else {
            bytes[0] = ((c >> 12) & 0xF) + 0xE0;
            bytes[1] = ((c >> 6) & 0x3F) + 0x80;
            bytes[2] = (c & 0x3F) + 0x80;
            [_data appendBytes:bytes length:3];
        }
    }
    return self;
}

- (DBOutput*)writeData:(NSData*)value
{
    [self writeUInt32:(unsigned int) value.length];
    [_data appendData:value];
    return self;
}

- (DBOutput*)open
{
    unsigned char bytes[1], *aux = bytes;
    *aux++ = 0xAA;
    [_data appendBytes:bytes length:1];
    return self;
}

- (DBOutput*)close
{
    unsigned char bytes[1], *aux = bytes;
    *aux++ = 0xFF;
    [_data appendBytes:bytes length:1];
    return self;
}

- (DBInput*)input
{
    return [[DBInput alloc] initWithData:_data];
}

@end

@interface DBInput ()

@property (nonatomic, strong) NSData *data;

@property (nonatomic, assign) unsigned int off;

@end

@implementation DBInput

- (instancetype)initWithData:(NSData*)data
{
    if (!(self = [super init])) return nil;
    _data = data;
    _off = 0;
    return self;
}

- (void)reset
{
	_off = 0;
}

- (void)reset:(NSData*)data
{
    _data = data;
    _off = 0;
}

- (unsigned int)readUInt32
{
    unsigned int result = 0;
    unsigned char *aux = ((unsigned char*)_data.bytes) + _off;
    result += ((*aux++) & 0xFF);
    result += ((*aux++) & 0xFF) << 8;
    result += ((*aux++) & 0xFF) << 16;
    result += ((*aux++) & 0xFF) << 24;
    _off += 4;
    return result;
}

- (bool)readBool
{
    unsigned char *aux = ((unsigned char*)_data.bytes) + _off;
    _off++;
    return (*aux & 0xFF) != 0;
}

- (NSString*)readString
{
    unsigned char *aux = ((unsigned char*)_data.bytes) + _off;
    unsigned short length = 0;
    length += ((*aux++) & 0xFF);
    length += ((*aux++) & 0xFF) << 8;
    _off += 2;
    unichar bytes[length];
    for (unsigned short n = 0 ; n < length ; n++) {
        unichar c = *aux++;
        if (c <= 0x7F) {
            bytes[n] = c;
            _off++;
        }
        else if ((c >> 5) == 0x6) {
            unichar i2 = *aux++;
            bytes[n] = ((c & 0x1F) << 6) + (i2 & 0x3F);
            _off += 2;
        }
        else {
            unichar i2 = *aux++;
            unichar i3 = *aux++;
            bytes[n] = ((c & 0xF) << 12) + ((i2 & 0x3F) << 6) + (i3 & 0x3F);
            _off += 3;
        }
    }
    return [[NSString alloc] initWithCharacters:bytes length:length];
}

- (NSData*)readData
{
    unsigned int length = [self readUInt32];
    unsigned char *aux = ((unsigned char*)_data.bytes) + _off;
    NSData *data = [NSData dataWithBytes:aux length:length];
    _off += length;
    return data;
}

- (bool)eof
{
    unsigned char *aux = ((unsigned char*)_data.bytes) + _off;
    if (((*aux) & 0xFF) == 0xAA) {
        _off++;
        return false;
    }
    return true;
}

@end