//
//  UIUniqueLayoutView.h
//  iPhoneUtil
//
//  Created by Bernardo Breder on 31/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UILayoutView.h"

@interface UIUniqueLayoutView : UILayoutView

@property (nonatomic, strong) UIView *contentView;

- (id)initWithView:(UIView*)view;

- (id)initWithView:(UIView*)view padding:(UIEdgeInsets)padding margin:(UIEdgeInsets)margin tintColor:(UIColor*)tintColor spaceInside:(CGFloat)spaceInside;

@end
