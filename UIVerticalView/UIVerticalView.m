//
//  UIVerticalView.m
//  iBandeiraSimple
//
//  Created by Bernardo Breder on 11/09/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIVerticalView.h"

@interface UIVerticalView ()

@property (nonatomic, strong) NSMutableArray *viewLoadedArray;
@property (nonatomic, assign) NSUInteger viewCount;

@end

@implementation UIVerticalView

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSNull *null = [NSNull null];
    if (_viewCount == 0) _viewCount = [_dataSource verticalViewGetCellCount:self];
    if (!_viewLoadedArray) {
        _viewLoadedArray = [[NSMutableArray alloc] init];
        for (NSUInteger n = 0 ; n < _viewCount ; n++) {
            _viewLoadedArray[n] = null;
        }
    }
    CGRect contentRect = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.frame.size.width, self.frame.size.height);
    CGFloat y = 0, w = self.frame.size.width;
    for (NSUInteger n = 0 ; n < _viewCount ; n++) {
        CGFloat h = [_dataSource verticalView:self getHeight:n];
        CGRect viewRect = CGRectMake(0, y, w, h);
        if (CGRectIntersectsRect(contentRect, viewRect)) {
            if (_viewLoadedArray[n] == null) {
                UIView *view = [_dataSource verticalView:self getViewAt:n withFrame:viewRect];
                _viewLoadedArray[n] = view;
                [self addSubview:view];
            }
        }
        y += h + _gapHeight;
    }
    self.contentSize = CGSizeMake(self.frame.size.width, y);
}

- (void)didReceiveMemoryWarning
{
    NSNull *null = [NSNull null];
    CGRect contentRect = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.frame.size.width, self.frame.size.height);
    CGFloat y = 0, w = self.frame.size.width;
    for (NSUInteger n = 0 ; n < _viewCount ; n++) {
        CGFloat h = [_dataSource verticalView:self getHeight:n];
        CGRect viewRect = CGRectMake(0, y, w, h);
        if (!CGRectIntersectsRect(contentRect, viewRect)) {
            if (_viewLoadedArray[n] != null) {
                UIView *view = _viewLoadedArray[n];
                _viewLoadedArray[n] = null;
                [view removeFromSuperview];
            }
        }
    }
}

@end

@implementation UIVerticalViewController

- (void)viewDidLoad
{
    CGSize size = self.view.bounds.size;
    UIVerticalView *view = [[UIVerticalView alloc] initWithFrame:CGRectMake(0, 20, size.width, size.height - 20)];
    view.dataSource = self;
    [self.view addSubview:view];
}


- (NSUInteger)verticalViewGetCellCount:(UIVerticalView*)verticalView
{
    return 50;
}

- (NSUInteger)verticalView:(UIVerticalView*)verticalView getHeight:(NSUInteger)index
{
    return 40;
}

- (UIView*)verticalView:(UIVerticalView*)verticalView getViewAt:(NSUInteger)index withFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = [NSString stringWithFormat:@"Line %d", (int)index];
    return label;
}

@end