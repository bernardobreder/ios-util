//
//  UIImage+Extras.m
//  iOs
//
//  Created by Bernardo Breder on 18/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Extras)

- (UIImage*)imageByBestFitForSize:(CGSize)targetSize;

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
