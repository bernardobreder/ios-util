//
//  UISlaveViewController.h
//  iPhoneUtil
//
//  Created by Bernardo Breder on 24/08/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMasterViewController.h"

@interface UISlaveViewController : UIView

@property (nonatomic, strong) UIMasterViewController *masterViewController;

- (void)loadViewWithSize:(CGSize)size;

- (void)viewDidAppear;

- (void)didReceiveMemoryWarning;

- (void)popViewControllerAndDisposeAfter:(CGFloat)delay;

@end
