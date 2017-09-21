//
//  UIImage+Resize.m
//  iOs
//
//  Created by Bernardo Breder on 16/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage*)scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)scaledProporcionalToSize:(CGSize)newSize
{
    double width = newSize.width;
    double height = newSize.height;
    double imgWidth = self.size.width;
    double imgHeight = self.size.height;
    if (imgWidth > imgHeight) {
        imgHeight = width * imgHeight / imgWidth;
        imgWidth = width;
    } else {
        imgWidth = height * imgWidth / imgHeight;
        imgHeight = height;
    }
    return [self scaledToSize:CGSizeMake(imgWidth, imgHeight)];
}

- (UIImage*)boxToSize:(CGSize)newSize
{
    double width = newSize.width;
    double height = newSize.height;
    double imgWidth = self.size.width;
    double imgHeight = self.size.height;
    double x = 0;
    double y = 0;
    double w = imgWidth * height / imgHeight;
    double h = height;
    if (w > width) {
        w = width;
        h = imgHeight * width / imgWidth;
    }
    if (w == width) {
        x = 0;
        y = (height - h) / 2;
    } else {
        x = (width - w) / 2;
        y = 0;
    }
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(x, y, w, h)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
