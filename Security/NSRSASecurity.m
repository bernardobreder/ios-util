//
//  NSRSASecurity.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 28/07/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "NSRSASecurity.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSRSASecurity

const size_t kSecAttrKeySizeInBitsLength = 2024;

+ (NSRSAKeyPair*)generateKeyPairWithPublicKey:(NSData*)publicKey withPrivateKey:(NSData*)privateKey
{
    NSMutableDictionary * privateKeyAttr = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary * publicKeyAttr = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary * keyPairAttr = [NSMutableDictionary dictionaryWithCapacity:0];
    [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:kSecAttrKeySizeInBitsLength] forKey:(__bridge id)kSecAttrKeySizeInBits];
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [privateKeyAttr setObject:privateKey forKey:(__bridge id)kSecAttrApplicationTag];
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [publicKeyAttr setObject:publicKey forKey:(__bridge id)kSecAttrApplicationTag];
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
    SecKeyRef _publicKeyRef, _privateKeyRef;
    if (SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &_publicKeyRef, &_privateKeyRef) != noErr) return nil;
    NSRSAKey *publicKeyRef = [[NSRSAKey alloc] init];
    NSRSAKey *privateKeyRef = [[NSRSAKey alloc] init];
    publicKeyRef.keyRef = _publicKeyRef;
    privateKeyRef.keyRef = _privateKeyRef;
    NSRSAKeyPair *keyPair = [[NSRSAKeyPair alloc] init];
    keyPair.publicKey = publicKeyRef;
    keyPair.privateKey = privateKeyRef;
    return keyPair;
}

+ (NSRSAKeyPair*)loadKeyPairFromKeyChain:(NSString*)identifier
{
//    OSStatus resultCode = noErr;
//    SecKeyRef publicKeyReference;
//    NSMutableDictionary * queryPublicKey = [NSMutableDictionary dictionaryWithCapacity:0];
//    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
//    [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
//    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
//    [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
//    if(SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyReference) != noErr) return nil;
    return nil;
}

+ (void)storeKeyPairInKeyChain:(NSString*)identifier withKeyPair:(NSRSAKeyPair*)keyPair
{
    
}

+ (BOOL)removeKeyPairFromKeyChain:(NSString*)identifier
{
    NSMutableDictionary * queryPublicKey = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary * queryPrivateKey = [NSMutableDictionary dictionaryWithCapacity:0];
    // Set the public key query dictionary.
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:([[identifier stringByAppendingString:@".public"] dataUsingEncoding:NSUTF8StringEncoding]) forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    // Set the private key query dictionary.
    [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPrivateKey setObject:([[identifier stringByAppendingString:@".private"] dataUsingEncoding:NSUTF8StringEncoding]) forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    // Delete the private key.
    SecItemDelete((__bridge CFDictionaryRef)queryPrivateKey);
    // Delete the public key.
    SecItemDelete((__bridge CFDictionaryRef)queryPublicKey);
    return true;
}

+ (NSData*)encryptData:(NSData*)plainData withKey:(NSRSAKey*)key
{
    if (!plainData || !key) return nil;
    size_t cipherBufferSize = SecKeyGetBlockSize(key.keyRef);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    NSData *plainTextBytes = plainData;
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [NSMutableData dataWithCapacity:0];
    for (NSUInteger i = 0 ; i < blockCount ; i++) {
        NSUInteger bufferSize = MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        if (SecKeyEncrypt(key.keyRef, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes], [buffer length], cipherBuffer, &cipherBufferSize) != noErr){
            if (cipherBuffer) free(cipherBuffer);
            return nil;
        }
        NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
        [encryptedData appendData:encryptedBytes];
    }
    if (cipherBuffer) free(cipherBuffer);
    return encryptedData;
}

+ (NSData*)decryptData:(NSData*)encryptData withKey:(NSRSAKey*)key
{
    if (!encryptData || !key) return nil;
    NSData *wrappedSymmetricKey = encryptData;
    size_t cipherBufferSize = SecKeyGetBlockSize(key.keyRef);
    size_t keyBufferSize = [wrappedSymmetricKey length];
    NSMutableData *bits = [NSMutableData dataWithLength:keyBufferSize];
    if (SecKeyDecrypt(key.keyRef, kSecPaddingPKCS1, (const uint8_t *) [wrappedSymmetricKey bytes], cipherBufferSize, [bits mutableBytes], &keyBufferSize) != noErr) {
        return nil;
    }
    [bits setLength:keyBufferSize];
    return bits;
}

+ (BOOL)verifyData:(NSData*)fileData signatureData:(NSData*)signatureData certificateData:(NSData*)certificateData
{
    SecCertificateRef certificateFromFile = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData);
    
    SecPolicyRef secPolicy = SecPolicyCreateBasicX509();
    
    SecTrustRef trust;
    if (SecTrustCreateWithCertificates(certificateFromFile, secPolicy, &trust) != noErr) return false;
    SecTrustResultType resultType;
    if (SecTrustEvaluate(trust, &resultType) != noErr) return false;
    SecKeyRef publicKey = SecTrustCopyPublicKey(trust);
    
    uint8_t sha1HashDigest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([fileData bytes], (CC_LONG)[fileData length], sha1HashDigest);
    
    OSStatus verficationResult = SecKeyRawVerify(publicKey, kSecPaddingPKCS1SHA1, sha1HashDigest, CC_SHA1_DIGEST_LENGTH, signatureData.bytes, signatureData.length);
    CFRelease(publicKey);
    CFRelease(trust);
    CFRelease(secPolicy);
    CFRelease(certificateFromFile);
    return verficationResult == errSecSuccess;
}

NSData* PKCSSignBytesSHA256withRSA(NSData* plainData, SecKeyRef privateKey)
{
    size_t signedHashBytesSize = SecKeyGetBlockSize(privateKey);
    uint8_t* signedHashBytes = malloc(signedHashBytesSize);
    memset(signedHashBytes, 0x0, signedHashBytesSize);
    
    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return nil;
    }
    
    SecKeyRawSign(privateKey,
                  kSecPaddingPKCS1SHA256,
                  hashBytes,
                  hashBytesSize,
                  signedHashBytes,
                  &signedHashBytesSize);
    
    NSData* signedHash = [NSData dataWithBytes:signedHashBytes
                                        length:(NSUInteger)signedHashBytesSize];
    
    if (hashBytes)
        free(hashBytes);
    if (signedHashBytes)
        free(signedHashBytes);
    
    return signedHash;
}

BOOL PKCSVerifyBytesSHA256withRSA(NSData* plainData, NSData* signature, SecKeyRef publicKey)
{
    size_t signedHashBytesSize = SecKeyGetBlockSize(publicKey);
    const void* signedHashBytes = [signature bytes];
    
    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return false;
    }
    
    OSStatus status = SecKeyRawVerify(publicKey,
                                      kSecPaddingPKCS1SHA256,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;
}

+ (BOOL) generateKeyPairWithKeySizeInBits:(int)bits withPublicIdentifier:(NSString*)publicIdentifier andPrivateIdentifier:(NSString *)privateIdentifier
{
    NSMutableDictionary* privateKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* publicKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* keyPairAttr = [[NSMutableDictionary alloc] init];
    
    NSData* publicTag = [publicIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    NSData* privateTag = [privateIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    
    SecKeyRef publicKey = NULL;
    SecKeyRef privateKey = NULL;
    
    [keyPairAttr setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id) kSecAttrKeyType];
    [keyPairAttr setObject:[NSNumber numberWithInt:bits] forKey:(__bridge id) kSecAttrKeySizeInBits];
    
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id) kSecAttrIsPermanent];
    [privateKeyAttr setObject:privateTag forKey:(__bridge id) kSecAttrApplicationTag];
    
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [publicKeyAttr setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
    
    SecItemDelete((__bridge CFDictionaryRef)keyPairAttr);
    
    return SecKeyGeneratePair((__bridge CFDictionaryRef) keyPairAttr, &publicKey, &privateKey) == noErr;
}


+ (NSData *)getPublicKeyBits: (NSString*) publicKeyIdentifier {
    NSData * publicKeyBits = nil;
    CFTypeRef pk;
    NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
    
    NSData* publicTag = [publicKeyIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    
    // Set the public key query dictionary.
    [queryPublicKey setObject:(__bridge_transfer id)kSecClassKey forKey:(__bridge_transfer id)kSecClass];
    
    [queryPublicKey setObject:publicTag forKey:(__bridge_transfer id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge_transfer id)kSecAttrKeyTypeRSA forKey:(__bridge_transfer id)kSecAttrKeyType];
    [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge_transfer id)kSecReturnData];
    
    // Get the key bits.
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)queryPublicKey, &pk) != noErr) return nil;
    publicKeyBits = (__bridge_transfer NSData*)pk;
    NSLog(@"public bits %@",publicKeyBits);
    
    return publicKeyBits;
}

@end

@implementation NSRSAKey

@synthesize keyRef = _keyRef;

@end

@implementation NSRSAPublicKey

@end

@implementation NSRSAPrivateKey

@end

@implementation NSRSAKeyPair

@synthesize publicKey = _publicKey;
@synthesize privateKey = _privateKey;

@end