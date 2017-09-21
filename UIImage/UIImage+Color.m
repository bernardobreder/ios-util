//
//  UIImage+Color.m
//  iBandeiraSimple
//
//  Created by Bernardo Breder on 29/08/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (UIImage_Color)

- (UIImage *)imageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextDrawImage(context, rect, self.CGImage);
    
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,  kCGPathFillStroke);
    
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

@end
