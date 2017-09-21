//
//  UIMasterViewController.h
//  iPhoneUtil
//
//  Created by Bernardo Breder on 24/08/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UISlaveViewController;

@interface UIMasterViewController : UIViewController

- (void)pushViewController:(UISlaveViewController*)viewController delay:(CGFloat)delay;

- (void)popViewControllerAndDisposeAfter:(CGFloat)delay;

@end
