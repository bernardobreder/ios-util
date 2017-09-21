//
//  NSFileManager+MD5.h
//  FileList
//
//  Created by Bernardo Breder on 6/7/15.
//  Copyright (c) 2015 Tecgraf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSString*)fileMD5;

- (NSInteger)fileHash;

@end
