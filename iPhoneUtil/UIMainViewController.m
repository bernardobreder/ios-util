//
//  UIMainViewController.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 25/02/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIMainViewController.h"
#import "UIInfinitScrollView.h"
#import "UILazyPageView.h"

@interface UIMainViewController () {
    UILazyPageView* lazyPageView;
    int currentPageOffset;
}

@end

@implementation UIMainViewController

- (UIView*)createView:(UIColor*)color
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    return view;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    if (0) {
        UIBorderLayoutView *borderView = [[UIBorderLayoutView alloc] init];
        borderView.northView = [self createView:[UIColor yellowColor]];
        borderView.southView = [self createView:[UIColor redColor]];
        borderView.westView = [self createView:[UIColor greenColor]];
        borderView.eastView = [self createView:[UIColor blueColor]];
        borderView.centerView = [self createView:[UIColor orangeColor]];
        borderView.padding = UIEdgeInsetsMake(1,1,1,1);
        borderView.margin = UIEdgeInsetsMake(1,1,1,1);
        borderView.spaceInside = 1;
        borderView.tintColor = [UIColor whiteColor];
        borderView.backgroundInsideColor = [UIColor blackColor];
        borderView.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:borderView];
        CONSTRAINT4(borderView, self.view, NSLayoutAttributeLeft, 1.0, 0.0, NSLayoutAttributeRight, 1.0, 0.0, NSLayoutAttributeTop, 1.0, 0.0, NSLayoutAttributeBottom, 1.0, 0.0);
    }
    if (0) {
        UIGridLayoutView *gridView = [[UIGridLayoutView alloc] init];
        gridView.rowCount = 2;
        gridView.columnCount = 2;
        [gridView addSubview:[self createView:[UIColor yellowColor]]];
        [gridView addSubview:[self createView:[UIColor redColor]]];
        [gridView addSubview:[self createView:[UIColor greenColor]]];
        [gridView addSubview:[self createView:[UIColor blueColor]]];
        gridView.padding = UIEdgeInsetsMake(1,1,1,1);
        gridView.margin = UIEdgeInsetsMake(1,1,1,1);
        gridView.spaceInside = 1;
        gridView.tintColor = [UIColor whiteColor];
        gridView.backgroundInsideColor = [UIColor blackColor];
        gridView.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:gridView];
        CONSTRAINT4(gridView, self.view, NSLayoutAttributeLeft, 1.0, 0.0, NSLayoutAttributeRight, 1.0, 0.0, NSLayoutAttributeTop, 1.0, 0.0, NSLayoutAttributeBottom, 1.0, 0.0);
    }
    if (0) {
        UIUniqueLayoutView *uniqueView = [[UIUniqueLayoutView alloc] initWithView:[self createView:[UIColor orangeColor]] padding:UIEdgeInsetsMake(1, 1, 1, 1) margin:UIEdgeInsetsMake(1, 1, 1, 1) tintColor:[UIColor whiteColor] spaceInside:1];
        [self.view addSubview:uniqueView];
        CONSTRAINT4(uniqueView, self.view, NSLayoutAttributeLeft, 1.0, 0.0, NSLayoutAttributeRight, 1.0, 0.0, NSLayoutAttributeTop, 1.0, 0.0, NSLayoutAttributeBottom, 1.0, 0.0);
    }
    if (0) {
        UIHorizontalLayoutView *horizontalView = [[UIHorizontalLayoutView alloc] init];
        [horizontalView addSubview:[self createView:[UIColor yellowColor]]];
        [horizontalView addSubview:[self createView:[UIColor redColor]]];
        [horizontalView addSubview:[self createView:[UIColor greenColor]]];
        [horizontalView addSubview:[self createView:[UIColor blueColor]]];
        [horizontalView addSubview:[self createView:[UIColor purpleColor]]];
        [horizontalView addSubview:[self createView:[UIColor brownColor]]];
        [horizontalView addSubview:[self createView:[UIColor cyanColor]]];
        [horizontalView addSubview:[self createView:[UIColor magentaColor]]];
        horizontalView.padding = UIEdgeInsetsMake(1,1,1,1);
        horizontalView.margin = UIEdgeInsetsMake(1,1,1,1);
        horizontalView.spaceInside = 1;
        horizontalView.tintColor = [UIColor whiteColor];
        horizontalView.backgroundInsideColor = [UIColor blackColor];
        horizontalView.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:horizontalView];
        CONSTRAINT4(horizontalView, self.view, NSLayoutAttributeLeft, 1.0, 0.0, NSLayoutAttributeRight, 1.0, 0.0, NSLayoutAttributeTop, 1.0, 0.0, NSLayoutAttributeBottom, 1.0, 0.0);
    }
    if (0) {
        NSArray *colorArray = @[[UIColor yellowColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor brownColor], [UIColor cyanColor], [UIColor orangeColor]];
        UIHorizontalLayoutView *horizontalView = [[UIHorizontalLayoutView alloc] init];
        if (0) {
            UIHorizontalLayoutView *subHorizontalView = [[UIHorizontalLayoutView alloc] init];
            for (NSInteger n = 0 ; n < 50 ; n++) {
                [subHorizontalView addSubview:[self createView:colorArray[n%colorArray.count]]];
            }
            subHorizontalView.padding = UIEdgeInsetsMake(1,1,1,1);
            subHorizontalView.margin = UIEdgeInsetsMake(1,1,1,1);
            subHorizontalView.spaceInside = 1;
            subHorizontalView.tintColor = [UIColor whiteColor];
            subHorizontalView.backgroundInsideColor = [UIColor blackColor];
            subHorizontalView.backgroundColor = [UIColor purpleColor];
            UILayoutScrollView *subLayoutScrollView = [[UILayoutScrollView alloc] initWithLayout:subHorizontalView];
            subLayoutScrollView.frame = CGRectMake(0, 0, 100, 100);
            [horizontalView addSubview:subLayoutScrollView];
        }
        for (NSInteger n = 0 ; n < 100 ; n++) {
            [horizontalView addSubview:[self createView:colorArray[n%colorArray.count]]];
        }
        horizontalView.padding = UIEdgeInsetsMake(1,1,1,1);
        horizontalView.margin = UIEdgeInsetsMake(1,1,1,1);
        horizontalView.spaceInside = 1;
        horizontalView.tintColor = [UIColor whiteColor];
        horizontalView.backgroundInsideColor = [UIColor blackColor];
        horizontalView.backgroundColor = [UIColor purpleColor];
        UILayoutScrollView *layoutScrollView = [[UILayoutScrollView alloc] initWithLayout:horizontalView];
        [self.view addSubview:layoutScrollView];
        CONSTRAINT4(layoutScrollView, self.view, NSLayoutAttributeLeft, 1.0, 0.0, NSLayoutAttributeRight, 1.0, 0.0, NSLayoutAttributeTop, 1.0, 0.0, NSLayoutAttributeBottom, 1.0, 0.0);
    }
    if (1) {
        NSArray *colorArray = @[[UIColor yellowColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor brownColor], [UIColor cyanColor], [UIColor orangeColor]];
        UIVerticalLayoutView *verticalView = [[UIVerticalLayoutView alloc] init];
        if (1) {
            UIHorizontalLayoutView *subHorizontalView = [[UIHorizontalLayoutView alloc] init];
            for (NSInteger n = 0 ; n < 50 ; n++) {
                [subHorizontalView addSubview:[self createView:colorArray[n%colorArray.count]]];
            }
            subHorizontalView.padding = UIEdgeInsetsMake(1,1,1,1);
            subHorizontalView.margin = UIEdgeInsetsMake(1,1,1,1);
            subHorizontalView.spaceInside = 1;
            subHorizontalView.tintColor = [UIColor whiteColor];
            subHorizontalView.backgroundInsideColor = [UIColor blackColor];
            subHorizontalView.backgroundColor = [UIColor purpleColor];
            UILayoutScrollView *subLayoutScrollView = [[UILayoutScrollView alloc] initWithLayout:subHorizontalView];
            subLayoutScrollView.frame = CGRectMake(0, 0, 100, 100);
            [verticalView addSubview:subLayoutScrollView];
        }
        if (1) {
            UIVerticalLayoutView *subVerticalView = [[UIVerticalLayoutView alloc] init];
            for (NSInteger n = 0 ; n < 50 ; n++) {
                [subVerticalView addSubview:[self createView:colorArray[n%colorArray.count]]];
            }
            subVerticalView.padding = UIEdgeInsetsMake(1,1,1,1);
            subVerticalView.margin = UIEdgeInsetsMake(1,1,1,1);
            subVerticalView.spaceInside = 1;
            subVerticalView.tintColor = [UIColor whiteColor];
            subVerticalView.backgroundInsideColor = [UIColor blackColor];
            subVerticalView.backgroundColor = [UIColor purpleColor];
            UILayoutScrollView *subLayoutScrollView = [[UILayoutScrollView alloc] initWithLayout:subVerticalView];
            subLayoutScrollView.frame = CGRectMake(0, 0, 100, 100);
            [verticalView addSubview:subLayoutScrollView];
        }
        if (1) {
            UIView *subView = [self createView:[UIColor orangeColor]];
            subView.frame = CGRectMake(0, 0, 10, 10);
            [verticalView addSubview:[[UIUniqueLayoutView alloc] initWithView:subView padding:UIEdgeInsetsMake(1, 1, 1, 1) margin:UIEdgeInsetsMake(1, 1, 1, 1) tintColor:[UIColor whiteColor] spaceInside:1]];
        }
        if (1) {
            UIBorderLayoutView *borderView = [[UIBorderLayoutView alloc] init];
            borderView.northView = [self createView:[UIColor yellowColor]];
            borderView.southView = [self createView:[UIColor redColor]];
            borderView.westView = [self createView:[UIColor greenColor]];
            borderView.eastView = [self createView:[UIColor blueColor]];
            borderView.centerView = [self createView:[UIColor orangeColor]];
            borderView.padding = UIEdgeInsetsMake(1,1,1,1);
            borderView.margin = UIEdgeInsetsMake(1,1,1,1);
            borderView.spaceInside = 1;
            borderView.tintColor = [UIColor whiteColor];
            borderView.backgroundInsideColor = [UIColor blackColor];
            borderView.backgroundColor = [UIColor purpleColor];
            [verticalView addSubview:borderView];
        }
        if (1) {
            for (NSInteger n = 0 ; n < 100 ; n++) {
                [verticalView addSubview:[self createView:colorArray[n%colorArray.count]]];
            }
        }
        verticalView.padding = UIEdgeInsetsMake(1,1,1,1);
        verticalView.margin = UIEdgeInsetsMake(1,1,1,1);
        verticalView.spaceInside = 1;
        verticalView.tintColor = [UIColor whiteColor];
        verticalView.backgroundInsideColor = [UIColor blackColor];
        verticalView.backgroundColor = [UIColor purpleColor];
        UILayoutScrollView *layoutScrollView = [[UILayoutScrollView alloc] initWithLayout:verticalView];
        [self.view addSubview:layoutScrollView];
        CONSTRAINT4(layoutScrollView, self.view, NSLayoutAttributeLeft, 1.0, 0.0, NSLayoutAttributeRight, 1.0, 0.0, NSLayoutAttributeTop, 1.0, 0.0, NSLayoutAttributeBottom, 1.0, 0.0);
    }
}

- (void)layoutSubviewsFromRect:(CGRect)fromRect toRect:(CGRect)toRect;
{
    //    self.view.frame = toRect;
    [self.view layoutSubviews];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    //    [lazyPageView willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

#pragma mark - UIInfinitScrollViewDelegate

- (UIView *)createView
{
    UILabel* label = [[UILabel alloc] init];
    label.text = @"#";
    return label;
}

- (void)changeView:(UIView*)view atPage:(int)pageIndex
{
    UILabel* label = (UILabel*)view;
    label.text = [NSString stringWithFormat:@"%d", pageIndex];
}

- (UIView *)pageView:(id)infinitScrollView atPage:(int)pageIndex withRect:(CGRect)rect
{
    UILabel* label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%d", pageIndex];
    return label;
}

#pragma mark - UILazyPageScrollViewDelegate

- (NSInteger)numberOfPages:(UILazyPageView*)lazyPageView
{
    return 1000;
}

- (UIView*)lazyPageView:(UILazyPageView*)lazyPageView pageForIndex:(NSInteger)index
{
    UIView* pageView = [[UIView alloc] init];
    {
        UILabel* label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"Page %ld", (unsigned long) (index+1)];
        label.textAlignment = NSTextAlignmentCenter;
        [pageView addSubview:label];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [pageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:pageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        [pageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:pageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [pageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:pageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [pageView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:pageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
    return pageView;
}

@end
