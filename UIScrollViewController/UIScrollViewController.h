//
//  UIScrollViewController.h
//  iDynamic
//
//  Created by Bernardo Breder on 02/09/14.
//  Copyright (c) 2014 Breder Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) UIView *navigatorView;

@property (nonatomic, strong) UIView *menuView;

@property (nonatomic, assign) CGFloat menuMinHeight;

@property (nonatomic, assign) CGFloat navigatorMinAlpha;

@property (nonatomic, assign) CGFloat menuMinAlpha;

@end
