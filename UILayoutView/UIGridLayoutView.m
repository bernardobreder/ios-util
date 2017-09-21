//
//  UIGridLayoutView.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 31/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIGridLayoutView.h"

@interface UIGridLayoutView ()

@property (nonatomic, strong) NSMutableArray *cellViewArray;

@end

@implementation UIGridLayoutView

@synthesize rowCount;
@synthesize columnCount;
@synthesize cellViewArray = _cellViewArray;

- (CGRect)_rectForCellAtRow:(NSInteger)row atColumn:(NSInteger)column
{
    NSInteger tintSize = (self.tintColor?1:0);
    CGFloat x = self.padding.left + tintSize + self.margin.left;
    CGFloat y = self.padding.top + tintSize + self.margin.top;
    CGFloat w = (self.frame.size.width - self.padding.left - self.margin.left - self.margin.right - self.padding.right - 2 * tintSize - (columnCount - 1) * self.spaceInside) / columnCount;
    CGFloat h = (self.frame.size.height - self.padding.top - self.margin.top - self.margin.bottom - self.padding.bottom - 2 * tintSize - (rowCount - 1) * self.spaceInside) / rowCount;
    x += column * (w + self.spaceInside);
    y += row * (h + self.spaceInside);
    return CGRectMake(x, y, w, h);
}

- (void)addSubview:(UIView *)view
{
    if (!_cellViewArray) {
        _cellViewArray = [[NSMutableArray alloc] init];
    }
    NSInteger index = _cellViewArray.count;
    if (index >= rowCount * columnCount) {
        NSLog(@"[WARNING] UIGridLayoutView: adding subview more than supported");
        return;
    }
    NSInteger row = index / columnCount;
    NSInteger col = index % columnCount;
    CGRect frame = [self _rectForCellAtRow:row atColumn:col];
    [_cellViewArray addObject:view];
    view.frame = frame;
    [super addSubview:view];
}

- (void)layoutSubviews
{
    for (NSInteger r = 0 ; r < rowCount ; r++) {
        for (NSInteger c = 0 ; c < columnCount ; c++) {
            NSInteger index = r * columnCount + c;
            if (index >= _cellViewArray.count) {
                break;
            }
            CGRect frame = [self _rectForCellAtRow:r atColumn:c];
            UIView *view = _cellViewArray[index];
            if (!CGRectEqualToRect(frame, view.frame)) {
                view.frame = frame;
                [view layoutSubviews];
                [view setNeedsDisplay];
                [self setNeedsDisplay];
            }
        }
    }
}

@end
