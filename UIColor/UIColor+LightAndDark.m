//
//  UIColor+LightDark.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 13/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIColor+LightAndDark.h"

@implementation UIColor (LightAndDark)

- (UIColor *)colorLighter
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.3, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)colorDarker
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.75
                               alpha:a];
    return nil;
}

- (UIColor *)colorMedium:(UIColor*)color
{
    CGFloat r1, g1, b1, a1;
    CGFloat r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [self getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    return [UIColor colorWithRed:(r1+r2)/2 green:(g1+g2)/2 blue:(b1+b2)/2 alpha:(a1+a2)/2];
    return nil;
}

@end
