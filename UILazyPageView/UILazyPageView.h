//
//  UILazyPageView.h
//  lazy page view
//
//  Created by Bernardo Breder on 15/02/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UILazyPageView;
@class UILazyPageViewDataSource;

@protocol UILazyPageViewDataSource

@required

- (NSInteger)numberOfPages:(UILazyPageView*)lazyPageView;

- (UIView*)lazyPageView:(UILazyPageView*)lazyPageView pageForIndex:(NSInteger)index;

@optional

@end

@interface UILazyPageView : UIScrollView <UIScrollViewDelegate>

//@property (nonatomic, strong) UIView* reusablePageView;
@property (nonatomic, strong) id<UILazyPageViewDataSource> lazyPageDataSource;

- (id)initWithFrame:(CGRect)frame;

- (id)init;

- (NSInteger)pageIndex;

- (void)reloadData;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end