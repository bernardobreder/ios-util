//
//  UIImage+Resize.h
//  iOs
//
//  Created by Bernardo Breder on 16/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage*)scaledToSize:(CGSize)newSize;

- (UIImage*)scaledProporcionalToSize:(CGSize)newSize;

- (UIImage*)boxToSize:(CGSize)newSize;

@end
