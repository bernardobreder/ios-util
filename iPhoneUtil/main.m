//
//  main.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 22/02/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "AESCrypt.h"
#import "NSSecurity.h"
#import "NSRSASecurity.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

static NSString *serviceName = @"com.mycompany.myAppServiceName";

int main(int argc, char * argv[])
{
    //        NSData *data = [(@"Bernardo") dataUsingEncoding:NSUTF8StringEncoding];
    //        for (;;) {
    //            @autoreleasepool {
    //                NSString *encrypt = [AESCrypt encrypt:@"Bernardo Breder" password:@"abc"];
    //NSLog(@"encrypt: %@", encrypt);
    //NSString *message = [AESCrypt decrypt:encrypt password:@"abc"];
    //NSLog(@"decrypt: %@", message);
    //            }
    //        }
//    {
//        NSLog(@"%@", [NSSecurity deviceId]);
//        NSString *base64 = [[[@"Bernardo Breder" dataUsingEncoding:NSUTF8StringEncoding] MD5Sum] stringByBase64];
//        NSLog(@"%@", base64);
//        base64 = [[base64 dataFromBase64String] stringByBase64];
//        NSLog(@"PlainText Base64 : %@", [[@"Bernardo Breder" dataUsingEncoding:NSUTF8StringEncoding] stringByBase64]);
//        NSData *encryptedData = [[@"Bernardo Breder" dataUsingEncoding:NSUTF8StringEncoding] dataEncrypted:([[@"1234567890123456" dataUsingEncoding:NSASCIIStringEncoding] mutableCopy]) iv:([[@"1234567890123456" dataUsingEncoding:NSASCIIStringEncoding] mutableCopy])];
//        NSLog(@"EncryptText Base64 : %@", [encryptedData stringByBase64]);
//        NSData *plainData = [encryptedData dataDecrypted:([[@"1234567890123456" dataUsingEncoding:NSASCIIStringEncoding] mutableCopy]) iv:([[@"1234567890123456" dataUsingEncoding:NSASCIIStringEncoding] mutableCopy])];
//        NSLog(@"Bernardo Breder = %@", [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding]);
//        {
//            [NSKeychain deleteKeychainValue:@"app"];
//            [NSKeychain createKeychainValue:([@"Bernardo" dataUsingEncoding:NSUTF8StringEncoding]) forIdentifier:@"app"];
//            NSLog(@"Keychain: %@", [[NSString alloc] initWithData:[NSKeychain searchKeychainCopyMatching:@"app"] encoding:NSUTF8StringEncoding]);
//            [NSKeychain updateKeychainValue:([@"Breder" dataUsingEncoding:NSUTF8StringEncoding]) forIdentifier:@"app"];
//            NSLog(@"Keychain: %@", [[NSString alloc] initWithData:[NSKeychain searchKeychainCopyMatching:@"app"] encoding:NSUTF8StringEncoding]);
//            [NSKeychain deleteKeychainValue:@"app"];
//        }
//    }
//    {
//        NSLog(@"Generating KeyPair");
//        NSRSAKeyPair *keyPair = [NSRSASecurity generateKeyPairWithPublicKey:([@"1234567890123456" dataUsingEncoding:NSUTF8StringEncoding]) withPrivateKey:([@"0123456789012345" dataUsingEncoding:NSUTF8StringEncoding])];
//        NSString *plainText = @"Bernardo Breder";
//        NSLog(@"Encrypting");
//        NSData *encryptedData = [NSRSASecurity encryptData:([plainText dataUsingEncoding:NSUTF8StringEncoding]) withKey:keyPair.publicKey];
//        NSLog(@"Decrypting");
//        NSData *plainData = [NSRSASecurity decryptData:encryptedData withKey:keyPair.privateKey];
//        NSLog(@"%@ = %@", plainText, [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding]);
//    }
//    NSString *publicKeyString = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDeWAkBi3J/r2V1RGG7CPsP2rurxpw93GLAgDrsRYEYdDHjeJId5qAFcxkNDorQFW8mbzawHaeNKRKhzNNXxILKRv+xhfcwEDW0NATTWWXK0uXI4smTkVCpEu567AARlMZbbh/vCwbNUwVn1Kz8a8Tq993lFNzIHjnb5J+L3cyp2QIDAQAB";
//    NSString *privateKeyString = @"MIICXAIBAAKBgQDeWAkBi3J/r2V1RGG7CPsP2rurxpw93GLAgDrsRYEYdDHjeJId5qAFcxkNDorQFW8mbzawHaeNKRKhzNNXxILKRv+xhfcwEDW0NATTWWXK0uXI4smTkVCpEu567AARlMZbbh/vCwbNUwVn1Kz8a8Tq993lFNzIHjnb5J+L3cyp2QIDAQABAoGAfpYgioCZ75gsa1dDTPkP9zbRIjsxOQcAMhjPczUfCo0c2iULC3sCIBgnawecgFuzrG4k9J/thLCdqwCyUoXO78ri/8A4R9RnnEN9mmn3OZYjal40iWb2Kl/g/XfAAKiNkuwg0VylTYFApi1gTWcCFShBL7y9oNcvv5J7z3u9GwECQQD8eTkDJx25ICvQ0AZrfNzYWKH9i4te9jPP3+0dxKor2XMwlYt+yBYKI6PoMlQP+hMk0XgljbQZYO/U6SyTgrYXAkEA4XMTtq6k6kyGxkRnOVDBGRcHRMF+IMrAMrtcdKveIUDO0LnUan9qLR74TQnXu2ljK5hWHYsIdZWVGkhctqmFjwJBAKewuG5gp7xTIucRlIIGMAU+cXGfItXS/zzdxXdVLZXsWzb0zO9LZGAdpftOmkj2V4rH2l5PDUUh/onSyfm8AscCQF3XN5pvwWdhKSw35rt9uJKH+leNLsHZgvza7hYGP/SZdDx/TUJy/LABVxtCAJEawdOwmg+8Am5nL+P7wNOrZlMCQF3oeCqNyO1lTZMXbeKfryYLQOpbocYDg3pHZYkp9j5x8azP4yYnxWZYXyRndh+BlK+NE9VEcgBnI2k/J6bbACQ=";
//    {
//        SecCertificateRef cert = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"]]);
//        NSLog(@"Certificate:");
//        NSData *p12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"pem"]];
//        SecKeyRef privateKeyRef = NULL;
//        NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
//        [options setObject:@"24813612" forKey:(__bridge id)kSecImportExportPassphrase];
//        CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
//        OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
//        if (securityError == noErr && CFArrayGetCount(items) > 0) {
//            CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
//            SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
//            securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
//            if (securityError != noErr) {
//                privateKeyRef = NULL;
//            }
//        }
//        CFRelease(items);
//        
//    }
//    {
//        
//        [NSRSASecurity generateKeyPairWithKeySizeInBits:1024 withPublicIdentifier:publicKeyString andPrivateIdentifier:privateKeyString];
//        [NSRSASecurity getPublicKeyBits:publicKeyString];
//    }
//    openssl req -x509 -out public_key.pem -outform pem -new -newkey rsa:2048 -keyout private_key.pem
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
}
