//
//  UILayoutView.h
//  iPhoneUtil
//
//  Created by Bernardo Breder on 31/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILayoutView : UIView

@property (nonatomic, assign) UIEdgeInsets padding;

@property (nonatomic, assign) UIEdgeInsets margin;

@property (nonatomic, assign) CGFloat spaceInside;

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIColor *backgroundInsideColor;

- (CGSize)layoutSize;

@end

@interface UILayoutScrollView : UIScrollView

@property (nonatomic, strong) UILayoutView *layoutView;

- (id)initWithLayout:(UILayoutView*)layoutView;

@end