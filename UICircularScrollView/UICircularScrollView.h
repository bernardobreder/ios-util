//
//  UICircularScrollView.h
//  BandeiraBR
//
//  Created by Bernardo Breder on 24/03/14.
//  Copyright (c) 2014 Tecgraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICircularScrollView;

@protocol UICircularScrollViewDataSource

@required

- (NSInteger)numberOfPages:(UICircularScrollView*)circularScrollView;

- (UIView*)circularScrollView:(UICircularScrollView*)circularScrollView pageForIndex:(NSInteger)index withFrame:(CGRect)frame;

@optional

@end

@interface UICircularScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<UICircularScrollViewDataSource> dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL pagingEnabled;
@property (nonatomic, weak) UIPageControl *pageControl;

- (void)enumerateObjectsUsingBlock:(void (^)(UIView *view, NSUInteger pageIndex, BOOL *stop))block;

- (void)didReceiveMemoryWarning;

@end

@interface UICircularScrollViewController : UIViewController <UICircularScrollViewDataSource>

@end

