//
//  NSRSASecurity.h
//  iPhoneUtil
//
//  Created by Bernardo Breder on 28/07/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRSAKey : NSObject

@property (nonatomic, assign) SecKeyRef keyRef;

@end

@interface NSRSAPublicKey : NSRSAKey

@end

@interface NSRSAPrivateKey : NSRSAKey

@end

@interface NSRSAKeyPair : NSObject

@property (nonatomic, strong) NSRSAKey *publicKey;

@property (nonatomic, strong) NSRSAKey *privateKey;

@end

@interface NSRSASecurity : NSObject

+ (NSRSAKeyPair*)generateKeyPairWithPublicKey:(NSData*)publicKey withPrivateKey:(NSData*)privateKey;

+ (NSRSAKeyPair*)loadKeyPairFromKeyChain:(NSString*)identifier;

+ (void)storeKeyPairInKeyChain:(NSString*)identifier withKeyPair:(NSRSAKeyPair*)keyPair;

+ (BOOL)removeKeyPairFromKeyChain:(NSString*)identifier;

+ (NSData*)encryptData:(NSData*)plainData withKey:(NSRSAKey*)key;

+ (NSData*)decryptData:(NSData*)encryptData withKey:(NSRSAKey*)key;

+ (BOOL)verifyData:(NSData*)fileData signatureData:(NSData*)signatureData certificateData:(NSData*)certificateData;

+ (BOOL) generateKeyPairWithKeySizeInBits:(int)bits withPublicIdentifier:(NSString*)publicIdentifier andPrivateIdentifier:(NSString *)privateIdentifier;

+ (NSData *)getPublicKeyBits: (NSString*) publicKeyIdentifier;

@end