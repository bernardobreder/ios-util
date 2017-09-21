//
//  UILayoutView.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 31/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UILayoutView.h"

@implementation UILayoutView

@synthesize padding;
@synthesize margin;
@synthesize tintColor;
@synthesize spaceInside;
@synthesize backgroundInsideColor;

- (id)init
{
    if (!(self = [super init])) return nil;
    padding = UIEdgeInsetsMake(0, 0, 0, 0);
    margin = UIEdgeInsetsMake(0, 0, 0, 0);
    spaceInside = 0;
    return self;
}

- (CGRect)_rectForTint
{
    CGFloat x = self.padding.left + 0.5;
    CGFloat y = self.padding.top + 0.5;
    CGFloat w = self.frame.size.width - x - self.padding.right - 0.5;
    CGFloat h = self.frame.size.height - y - self.padding.bottom - 0.5;
    return CGRectMake(x, y, w, h);
}

- (CGRect)_rectForBackground
{
    CGFloat x = self.padding.left;
    CGFloat y = self.padding.top;
    CGFloat w = self.frame.size.width - x - self.padding.right;
    CGFloat h = self.frame.size.height - y - self.padding.bottom;
    return CGRectMake(x, y, w, h);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (self.backgroundInsideColor) {
        CGContextSetFillColorWithColor(context, self.backgroundInsideColor.CGColor);
        CGContextFillRect(context, [self _rectForBackground]);
    }
    if (self.tintColor) {
        CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGContextAddRect(context, [self _rectForTint]);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}

- (CGSize)layoutSize
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

@end

@implementation UILayoutScrollView

@synthesize layoutView = _layoutView;

- (id)initWithLayout:(UILayoutView*)layoutView
{
    if (!(self = [super init])) return nil;
    _layoutView = layoutView;
    [self addSubview:layoutView];
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_layoutView) {
        _layoutView.frame = self.frame;
        CGSize size = [_layoutView layoutSize];
        _layoutView.frame = CGRectMake(0, 0, size.width, size.height);
        [_layoutView layoutSubviews];
        self.contentSize = size;
    }
}

@end