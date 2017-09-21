//
//  UIBlurView.m
//  iBandeiraSimple
//
//  Created by Bernardo Breder on 28/07/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIBlurView.h"

@implementation UIDarkBlurView

@synthesize contentView = _contentView;

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
#ifdef __IPHONE_8_0
        CGSize size = frame.size;
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [blurEffectView setFrame:CGRectMake(0, 0, size.width, size.height)];
        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
        UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        [vibrancyEffectView setFrame:CGRectMake(0, 0, size.width, size.height)];
        [[blurEffectView contentView] addSubview:vibrancyEffectView];
        [self addSubview:blurEffectView];
        _contentView = vibrancyEffectView.contentView;
#endif
    } else {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
        _contentView = self;
    }
    return self;
}

@end
