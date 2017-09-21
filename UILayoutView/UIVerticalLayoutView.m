//
//  UIVerticalLayoutView.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 31/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIVerticalLayoutView.h"

@interface UIVerticalLayoutView ()

@property (nonatomic, strong) NSMutableArray *cellViewArray;

@end

@implementation UIVerticalLayoutView

@synthesize cellViewArray = _cellViewArray;

- (CGRect)_rectForCell:(NSInteger)index
{
    UIView *view = _cellViewArray[index];
    NSInteger tintSize = (self.tintColor?1:0);
    CGFloat x = self.padding.left + tintSize + self.margin.left;
    CGFloat y = self.padding.top + tintSize + self.margin.top;
    CGFloat w = self.frame.size.width - self.padding.left - self.margin.left - self.margin.right - self.padding.right - 2 * tintSize;
    CGFloat h = MAX(10, view.frame.size.height);
    for (NSInteger n = 0 ; n < index ; n++) {
        UIView *childView = _cellViewArray[n];
        y += MAX(10, childView.frame.size.height) + self.spaceInside;
    }
    return CGRectMake(x, y, w, h);
}

- (void)addSubview:(UIView *)view
{
    if (!_cellViewArray) {
        _cellViewArray = [[NSMutableArray alloc] init];
    }
    NSInteger index = _cellViewArray.count;
    [_cellViewArray addObject:view];
    view.frame = [self _rectForCell:index];
    [super addSubview:view];
}

- (void)layoutSubviews
{
    for (NSInteger n = 0 ; n < _cellViewArray.count ; n++) {
        CGRect frame = [self _rectForCell:n];
        UIView *view = _cellViewArray[n];
        if (!CGRectEqualToRect(frame, view.frame)) {
            view.frame = frame;
            [view layoutSubviews];
            [view setNeedsDisplay];
            [self setNeedsDisplay];
        }
    }
}

- (CGSize)layoutSize
{
    NSInteger tintSize = (self.tintColor?1:0);
    CGFloat w = self.frame.size.width;
    CGFloat h = self.padding.top + self.margin.top + self.padding.bottom + self.margin.bottom + 2 * tintSize;
    for (NSInteger n = 0 ; n < _cellViewArray.count ; n++) {
        UIView *childView = _cellViewArray[n];
        h += MAX(10, childView.frame.size.height);
        if (n != _cellViewArray.count - 1) {
            h += self.spaceInside;
        }
    }
    return CGSizeMake(w, h);
}

@end
