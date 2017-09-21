//
//  UIMenuView.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 19/08/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIMenuView.h"

@implementation UIMenuView

@synthesize scrollView = _scrollView;
@synthesize menuView = _menuView;
@synthesize contentView = _contentView;

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.contentSize = CGSizeMake(2 * frame.size.width, frame.size.height);
        _scrollView.contentOffset = CGPointMake(frame.size.width, 0);
        _scrollView.decelerationRate = 0.0;
        _scrollView.pagingEnabled = true;
        _scrollView.delegate = self;
    }
    {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2 * frame.size.width, frame.size.height)];
        _menuView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
        [_scrollView addSubview:_menuView];
    }
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectOffset(frame, frame.size.width, 0)];
        _contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        [_scrollView addSubview:_contentView];
    }
    [self addSubview:_scrollView];
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat progress = (_scrollView.frame.size.width - _scrollView.contentOffset.x) / _scrollView.frame.size.width;
    _contentView.transform = CGAffineTransformIdentity;
    _contentView.transform = CGAffineTransformScale(_contentView.transform, 1.0 - (progress * 0.2), 1.0 - (progress * 0.1));
    _contentView.transform = CGAffineTransformTranslate(_contentView.transform, 0.0 - (progress * 100.0), 0.0);
}

@end

@implementation UIMenuDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIMenuView *menuView = [[UIMenuView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:menuView];
}

@end