//
//  UIBorderLayoutView.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 31/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIBorderLayoutView.h"

@interface UIBorderLayoutView ()

@end

@implementation UIBorderLayoutView

@synthesize centerView;
@synthesize northView;
@synthesize southView;
@synthesize eastView;
@synthesize westView;

- (CGRect)_rectForNorth
{
    NSInteger tintSize = (self.tintColor?1:0);
    CGFloat height = northView ? (MAX(10, northView.frame.size.height)) : 0;
    CGFloat x = self.padding.left + tintSize + self.margin.left;
    CGFloat y = self.padding.top + tintSize + self.margin.top;
    CGFloat w = self.frame.size.width - self.padding.left - self.padding.right - 2 * tintSize - self.margin.left - self.margin.right;
    CGFloat h = height;
    return CGRectMake(x, y, w, h);
}

- (CGRect)_rectForSouth
{
    NSInteger tintSize = (self.tintColor?1:0);
    CGFloat height = southView ? (MAX(10, southView.frame.size.height)) : 0;
    CGFloat x = self.padding.left + tintSize + self.margin.left;
    CGFloat y = self.frame.size.height - height - self.padding.bottom - tintSize - self.margin.bottom;
    CGFloat w = self.frame.size.width - self.padding.left - self.padding.right - 2 * tintSize - self.margin.left - self.margin.right;
    CGFloat h = height;
    return CGRectMake(x, y, w, h);
}

- (CGRect)_rectForWest
{
    CGRect northRect = [self _rectForNorth];
    CGRect southRect = [self _rectForSouth];
    NSInteger tintSize = (self.tintColor?1:0);
    CGFloat width = westView ? (MAX(10, westView.frame.size.width)) : 0;
    CGFloat x = self.padding.left + tintSize + self.margin.left;
    CGFloat y;
    if (northRect.size.height > 0) {
        y = northRect.origin.y + northRect.size.height + self.spaceInside;
    } else {
        y = self.padding.top + tintSize + self.margin.top;
    }
    CGFloat w = width;
    CGFloat h = self.frame.size.height - northRect.size.height - southRect.size.height - self.padding.top - self.margin.top - self.padding.bottom - self.margin.bottom - 2 * tintSize;
    if (northView) {
        h -= self.spaceInside;
    }
    if (southView) {
        h -= self.spaceInside;
    }
    return CGRectMake(x, y, w, h);
}

- (CGRect)_rectForEast
{
    CGRect northRect = [self _rectForNorth];
    CGRect southRect = [self _rectForSouth];
    NSInteger tintSize = (self.tintColor?1:0);
    CGFloat width = eastView ? (MAX(10, eastView.frame.size.width)) : 0;
    CGFloat x = self.frame.size.width - self.padding.right - tintSize - self.margin.right - width;
    CGFloat y;
    if (northRect.size.height > 0) {
        y = northRect.origin.y + northRect.size.height + self.spaceInside;
    } else {
        y = self.padding.top + tintSize + self.margin.top;
    }
    CGFloat w = width;
    CGFloat h = self.frame.size.height - northRect.size.height - southRect.size.height - self.padding.top - self.margin.top - self.padding.bottom - self.margin.bottom - 2 * tintSize;
    if (northView) {
        h -= self.spaceInside;
    }
    if (southView) {
        h -= self.spaceInside;
    }
    return CGRectMake(x, y, w, h);
}

- (CGRect)_rectForCenter
{
    CGRect northRect = [self _rectForNorth];
    CGRect southRect = [self _rectForSouth];
    CGRect westRect = [self _rectForWest];
    CGRect eastRect = [self _rectForEast];
    NSInteger tintSize = (self.tintColor?1:0);
    CGFloat x = self.padding.left + tintSize + self.margin.left;
    if (westView) {
        x += westRect.size.width + self.spaceInside;
    }
    CGFloat y = self.padding.top + tintSize + self.margin.top;
    if (northView) {
        y += northRect.size.height + self.spaceInside;
    }
    CGFloat w = self.frame.size.width - x - self.margin.right - tintSize - self.padding.right;
    if (eastView) {
        w -= self.spaceInside + eastRect.size.width;
    }
    CGFloat h = self.frame.size.height - y - self.margin.bottom - tintSize - self.padding.bottom;
    if (southView) {
        h -= self.spaceInside + southRect.size.height;
    }
    return CGRectMake(x, y, w, h);
}

- (void)layoutSubviews
{
    if (northView) {
        CGRect rect = [self _rectForNorth];
        if (!CGRectEqualToRect(rect, northView.frame)) {
            northView.frame = rect;
            [northView layoutSubviews];
            [northView setNeedsDisplay];
            [self setNeedsDisplay];
        }
        if(![northView isDescendantOfView:self]) {
            [self addSubview:northView];
        }
    }
    if (southView) {
        CGRect rect = [self _rectForSouth];
        if (!CGRectEqualToRect(rect, southView.frame)) {
            southView.frame = rect;
            [southView layoutSubviews];
            [southView setNeedsDisplay];
            [self setNeedsDisplay];
        }
        if(![southView isDescendantOfView:self]) {
            [self addSubview:southView];
        }
    }
    if (westView) {
        CGRect rect = [self _rectForWest];
        if (!CGRectEqualToRect(rect, westView.frame)) {
            westView.frame = rect;
            [westView layoutSubviews];
            [westView setNeedsDisplay];
            [self setNeedsDisplay];
        }
        if(![westView isDescendantOfView:self]) {
            [self addSubview:westView];
        }
    }
    if (eastView) {
        CGRect rect = [self _rectForEast];
        if (!CGRectEqualToRect(rect, eastView.frame)) {
            eastView.frame = rect;
            [eastView layoutSubviews];
            [eastView setNeedsDisplay];
            [self setNeedsDisplay];
        }
        if(![eastView isDescendantOfView:self]) {
            [self addSubview:eastView];
        }
    }
    if (centerView) {
        CGRect rect = [self _rectForCenter];
        if (!CGRectEqualToRect(rect, centerView.frame)) {
            centerView.frame = rect;
            [centerView layoutSubviews];
            [centerView setNeedsDisplay];
            [self setNeedsDisplay];
        }
        if(![centerView isDescendantOfView:self]) {
            [self addSubview:centerView];
        }
    }
}

@end
