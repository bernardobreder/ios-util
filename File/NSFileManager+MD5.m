//
//  NSFileManager+MD5.m
//  FileList
//
//  Created by Bernardo Breder on 6/7/15.
//  Copyright (c) 2015 Tecgraf. All rights reserved.
//

#import "NSFileManager+MD5.h"
#include <CoreFoundation/CoreFoundation.h>
#include <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

#define CHUNK_SIZE 4096

- (NSString*)fileMD5
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:self];
    if(!handle) return nil;
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done) {
        NSData* fileData = [handle readDataOfLength:CHUNK_SIZE];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

- (NSInteger)fileHash
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:self];
    if(!handle) return 0;
    NSInteger hash = 0;
    for (;;) {
        NSData* data = [handle readDataOfLength:CHUNK_SIZE];
        NSInteger length = data.length;
        unsigned char *bytes = (unsigned char*) data.bytes;
        for (NSInteger n = 0 ; n < length ; n++) {
            hash = 31 * hash + bytes[n];
        }
        if(length == 0) break;
    }
    return hash;
}

@end
