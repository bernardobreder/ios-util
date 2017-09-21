//
//  NSString+toAscii.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 13/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "NSString+toAscii.h"

@implementation NSString (ToAscii)

- (NSString*)toAscii
{
    NSInteger asciiLimit = 126;
    NSString *aChar = @"áäàãâÁÄÀÃÂ";
    NSString *eChar = @"éëèêÉËÈÊ";
    NSString *iChar = @"íïìîÍÏÌÎ";
    NSString *oChar = @"óöòõôÓÖÒÕÔ";
    NSString *uChar = @"úüùûÚÜÙÛ";
    NSString *cChar = @"çÇ";
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:self.length];
    for (NSInteger n = 0; n < self.length ; n++) {
        unichar c = [self characterAtIndex:n];
        if (c > asciiLimit) {
            if (c >asciiLimit) {
                for (NSInteger m = 0; m < aChar.length ; m++) {
                    if (c == [aChar characterAtIndex:m]) {
                        c = 'a';
                        break;
                    }
                }
            }
            if (c >asciiLimit) {
                for (NSInteger m = 0; m < eChar.length ; m++) {
                    if (c == [eChar characterAtIndex:m]) {
                        c = 'e';
                        break;
                    }
                }
            }
            if (c >asciiLimit) {
                for (NSInteger m = 0; m < iChar.length ; m++) {
                    if (c == [iChar characterAtIndex:m]) {
                        c = 'i';
                        break;
                    }
                }
            }
            if (c >asciiLimit) {
                for (NSInteger m = 0; m < oChar.length ; m++) {
                    if (c == [oChar characterAtIndex:m]) {
                        c = 'o';
                        break;
                    }
                }
            }
            if (c >asciiLimit) {
                for (NSInteger m = 0; m < uChar.length ; m++) {
                    if (c == [uChar characterAtIndex:m]) {
                        c = 'u';
                        break;
                    }
                }
            }
            if (c >asciiLimit) {
                for (NSInteger m = 0; m < cChar.length ; m++) {
                    if (c == [cChar characterAtIndex:m]) {
                        c = 'c';
                        break;
                    }
                }
            }
        }
        if (c < 32 && c > 126) {
            c = ' ';
        }
        [result appendString:[NSString stringWithCharacters:&c length:1]];
    }
    return result;
}

@end
