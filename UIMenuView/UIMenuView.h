//
//  UIMenuView.h
//  iPhoneUtil
//
//  Created by Bernardo Breder on 19/08/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIMenuView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *menuView;

@end

@interface UIMenuDemoViewController : UIViewController

@end

