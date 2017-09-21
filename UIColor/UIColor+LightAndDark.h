//
//  UIColor+LightDark.h
//  iPhoneUtil
//
//  Created by Bernardo Breder on 13/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Light)

- (UIColor *)colorLighter;

- (UIColor *)colorDarker;

- (UIColor *)colorMedium:(UIColor*)color;

@end
