//
//  UIMasterViewController.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 24/08/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIMasterViewController.h"
#import "UISlaveViewController.h"

@interface UIMasterViewController ()

@property (nonatomic, strong) NSMutableArray *queue;

@end

@implementation UIMasterViewController

@synthesize queue = _queue;

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    _queue = [[NSMutableArray alloc] init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_queue.count == 0) return;
    CGSize size = self.view.bounds.size;
    UISlaveViewController *viewController = _queue.lastObject;
    viewController.frame = CGRectMake(0, 0, size.width, size.height);
    [viewController loadViewWithSize:size];
    [self.view addSubview:viewController];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_queue.count == 0) return;
    UISlaveViewController *viewController = _queue.lastObject;
    [viewController viewDidAppear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    for (UISlaveViewController *view in _queue) {
        [view didReceiveMemoryWarning];
    }
}

- (void)pushViewController:(UISlaveViewController*)viewController delay:(CGFloat)delay
{
    if (delay == 0.0) {
        [self pushViewController:viewController];
    } else {
        [self performSelector:@selector(pushViewController:) withObject:viewController afterDelay:delay];
    }
}

- (void)pushViewController:(UISlaveViewController*)viewController
{
    viewController.masterViewController = self;
    [_queue addObject:viewController];
    if (self.isViewLoaded) {
        CGSize size = self.view.bounds.size;
        viewController.frame = CGRectMake(0, 0, size.width, size.height);
        [viewController loadViewWithSize:size];
        [self.view addSubview:viewController];
        [viewController viewDidAppear];
    }
}

- (void)popViewControllerAndDisposeAfter:(CGFloat)delay
{
    UISlaveViewController *lastViewController = _queue.lastObject;
    [_queue removeLastObject];
    UISlaveViewController *viewController = _queue.lastObject;
    [viewController viewDidAppear];
    [self performSelector:@selector(disposeViewController:) withObject:lastViewController afterDelay:delay];
}

- (void)disposeViewController:(UISlaveViewController*)lastViewController
{
    [lastViewController removeFromSuperview];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
