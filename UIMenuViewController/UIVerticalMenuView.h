//
//  UIMenuViewController.h
//  iBandeiraSimple
//
//  Created by Bernardo Breder on 27/07/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIVerticalMenuView : UIView

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, weak) UIView *topView;

@property (nonatomic, assign) NSInteger topViewMargin;

@property (nonatomic, assign) NSInteger bottomViewMargin;

@property (nonatomic, assign) BOOL topViewEnable;

@property (nonatomic, assign) BOOL bottomViewEnable;

@property (nonatomic, assign) CGFloat minAlpha;

@property (nonatomic, assign) CGRect bottomDragRect;

@end

@interface UIVerticalMenuViewController : UIViewController

@end