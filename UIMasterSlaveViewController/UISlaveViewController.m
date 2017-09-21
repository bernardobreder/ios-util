//
//  UISlaveViewController.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 24/08/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UISlaveViewController.h"

@implementation UISlaveViewController

@synthesize masterViewController = _masterViewController;

- (void)loadViewWithSize:(CGSize)size
{
}

- (void)viewDidAppear
{
}

- (void)didReceiveMemoryWarning
{
}

- (void)popViewControllerAndDisposeAfter:(CGFloat)delay
{
    [_masterViewController popViewControllerAndDisposeAfter:delay];
}

@end
