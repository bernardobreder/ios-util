//
//  NSSecurity.h
//  iPhoneUtil
//
//  Created by Bernardo Breder on 27/07/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSecurity : NSObject

+ (NSString*)deviceId;

+ (BOOL)checkJailbreak;

@end

@interface NSData (NSSecurityData)

- (NSData*)MD2Sum;

- (NSData*)MD4Sum;

- (NSData*)MD5Sum;

- (NSData*)SHA1Hash;

- (NSData*)SHA224Hash;

- (NSData*)SHA256Hash;

- (NSData*)SHA384Hash;

- (NSData*)SHA512Hash;

- (NSString *)stringByBase64;

- (NSData*)dataEncrypted:(NSMutableData*)keyData iv:(NSMutableData*)ivData;

- (NSData*)dataDecrypted:(NSMutableData*)keyData iv:(NSMutableData*)ivData;

@end

@interface NSString (NSSecurityString)

- (NSData*)dataFromBase64String;

@end

@interface NSKeychain : NSObject

+ (NSData*)searchKeychainCopyMatching:(NSString *)identifier;

+ (BOOL)createKeychainValue:(NSData*)data forIdentifier:(NSString *)identifier;

+ (BOOL)updateKeychainValue:(NSData*)data forIdentifier:(NSString *)identifier;

+ (void)deleteKeychainValue:(NSString *)identifier;

@end