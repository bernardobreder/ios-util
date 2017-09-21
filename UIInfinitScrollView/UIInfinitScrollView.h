//
//  InfinitScrollView.h
//  scroll
//
//  Created by Bernardo Breder on 15/02/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIInfinitScrollView.h"

@protocol UIInfinitScrollViewDelegate

@required

- (UIView *)createView;

- (void)changeView:(UIView*)view atPage:(int)pageIndex;

@optional

@end

@interface UIInfinitScrollView : UIScrollView <UIScrollViewDelegate>

@property(nonatomic, assign) int _page;
@property(nonatomic, strong) UIView* view1;
@property(nonatomic, strong) UIView* view2;
@property(nonatomic, strong) UIView* view3;
//@property(nonatomic, strong) UIView* view4;
//@property(nonatomic, strong) UIView* view5;

@property(nonatomic, strong) IBOutlet id<UIInfinitScrollViewDelegate> model;

- (id)initWithCoder:(NSCoder *)inCoder;

- (id)initWithModel:(id<UIInfinitScrollViewDelegate>)model;

- (UIView*)page;

- (void)fireDataChanged;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;

@end