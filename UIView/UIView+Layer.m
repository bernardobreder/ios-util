//
//  UIView+Layer.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 27/07/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIView+Layer.h"

@implementation UIView (UIViewLayer)

+ (void)addLinearGradientWithTopColor:(UIColor*)topColor bottomColor:(UIColor*)bottomColor
{
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5,1);
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
    [self.layer addSublayer:gradientLayer];
}

@end