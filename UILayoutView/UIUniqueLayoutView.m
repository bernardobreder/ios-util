//
//  UIUniqueLayoutView.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 31/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIUniqueLayoutView.h"

@implementation UIUniqueLayoutView

@synthesize contentView;

- (id)initWithView:(UIView*)view
{
    if (!(self = [super init])) return nil;
    self.contentView = view;
    return self;
}

- (id)initWithView:(UIView*)view padding:(UIEdgeInsets)padding margin:(UIEdgeInsets)margin tintColor:(UIColor*)tintColor spaceInside:(CGFloat)spaceInside
{
    if (!(self = [self initWithView:view])) return nil;
    self.padding = padding;
    self.margin = margin;
    self.tintColor = tintColor;
    self.spaceInside = spaceInside;
    return self;
}

- (CGRect)_rectForCenter
{
    NSInteger tintSize = (self.tintColor?1:0);
    CGFloat x = self.padding.left + tintSize + self.margin.left;
    CGFloat y = self.padding.top + tintSize + self.margin.top;
    CGFloat w = self.frame.size.width - x - self.margin.right - tintSize - self.padding.right;
    CGFloat h = self.frame.size.height - y - self.margin.bottom - tintSize - self.padding.bottom;
    return CGRectMake(x, y, w, h);
}

- (void)layoutSubviews
{
    if (contentView) {
        CGRect rect = [self _rectForCenter];
        if (!CGRectEqualToRect(rect, contentView.frame)) {
            contentView.frame = rect;
            [contentView layoutSubviews];
            [contentView setNeedsDisplay];
            [self setNeedsDisplay];
        }
        if(![contentView isDescendantOfView:self]) {
            [self addSubview:contentView];
        }
    }
}

@end
