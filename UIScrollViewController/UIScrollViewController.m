//
//  UIScrollViewController.m
//  iDynamic
//
//  Created by Bernardo Breder on 02/09/14.
//  Copyright (c) 2014 Breder Organization. All rights reserved.
//

#import "UIScrollViewController.h"

@interface UIScrollViewController ()

@property (nonatomic, strong) UIView *menuDragView;
@property (nonatomic, assign) BOOL menuShowing;

@end

@implementation UIScrollViewController

@synthesize contentView = _contentView;
@synthesize navigatorView = _navigatorView;
@synthesize menuDragView = _menuDragView;
@synthesize menuView = _menuView;
@synthesize menuMinHeight = _menuMinHeight;
@synthesize menuShowing = _menuShowing;
@synthesize navigatorMinAlpha = _navigatorMinAlpha;
@synthesize menuMinAlpha = _menuMinAlpha;

- (instancetype)init
{
    if (!(self = [super init])) return nil;
	_menuMinHeight = 0;
	_navigatorMinAlpha = 0.2;
	_menuMinAlpha = 0.2;
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	CGSize size = self.view.bounds.size;
	{
		_navigatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 70)];
		_navigatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		[_navigatorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapNavigatorGestureRecognizer:)]];
		[self.view addSubview:_navigatorView];
	}
	{
		_menuDragView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height, size.width, size.height)];
		[_menuDragView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanMenuDragGestureRecognizer:)]];
		[self.view addSubview:_menuDragView];
		{
			_menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, size.width, size.height)];
			_menuView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
			_menuView.alpha = _menuMinAlpha;
			[_menuDragView addSubview:_menuView];
		}
	}
}

- (void)viewWillRotate:(CGRect)frame duration:(NSTimeInterval)duration
{
	[UIView animateWithDuration:duration animations:^() {
		_contentView.frame = CGRectMake(0, 20, frame.size.width, frame.size.height);
		_navigatorView.frame = CGRectMake(0, 0, frame.size.width, 70);
		if (_menuShowing) {
			_menuDragView.frame = CGRectMake(0, 1, frame.size.width, frame.size.height);
			_menuView.frame = CGRectMake(0, 70, frame.size.width, frame.size.height);
		} else {
			_menuDragView.frame = CGRectMake(0, frame.size.height - 70 - _menuMinHeight, frame.size.width, 70);
			_menuView.frame = CGRectMake(0, 70, frame.size.width, frame.size.height);
		}
	}];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	CGSize size = self.view.bounds.size;
	if (size.width < size.height && UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
		[self viewWillRotate:CGRectMake(0, 0, size.height, size.width) duration:duration];
	} else if (size.width > size.height && UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
		[self viewWillRotate:CGRectMake(0, 0, size.height, size.width) duration:duration];
	}
}

- (void)setContentView:(UIScrollView *)contentView
{
	if (_contentView) {
		[_contentView removeFromSuperview];
	}
	_contentView = contentView;
    _contentView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
	_contentView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
	_contentView.delegate = self;
	[self.view addSubview:_contentView];
	[self.view bringSubviewToFront:_navigatorView];
	[self.view bringSubviewToFront:_menuDragView];
}

- (void)setMenuMinHeight:(CGFloat)menuHeight
{
	_menuMinHeight = menuHeight;
	CGSize size = self.view.bounds.size;
	_menuDragView.frame = CGRectMake(0, size.height - 70 - menuHeight, size.width, size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat y = scrollView.contentOffset.y;
	CGSize size = self.view.bounds.size;
	_navigatorView.frame = CGRectMake(0, MAX(-50,MIN(0,-(y + 50))), size.width, 70);
	_navigatorView.alpha = 1 - (1 - _navigatorMinAlpha) * (ABS(_navigatorView.frame.origin.y) / 50);
}

- (void)onTapNavigatorGestureRecognizer:(UITapGestureRecognizer*)recognizer
{
	[UIView animateWithDuration:0.5 animations:^() {
		_contentView.contentOffset = CGPointMake(0, -50);
	}];
}

- (void)onMenuMoveToTop
{
	_menuShowing = true;
	CGSize size = self.view.bounds.size;
	NSInteger y = 1 + _navigatorView.frame.origin.y;
	[UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^() {
		_menuDragView.frame = CGRectMake(0, y, size.width, size.height);
		_menuView.alpha = 1.0;
	} completion:nil];
}

- (void)onMenuMoveToBottom
{
	_menuShowing = false;
	CGSize size = self.view.bounds.size;
	[UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^() {
		_menuDragView.frame = CGRectMake(0, size.height - 70 - _menuMinHeight, size.width, size.height);
		_menuView.alpha = _menuMinAlpha;
	} completion:nil];
}

- (void)onPanMenuDragGestureRecognizer:(UIPanGestureRecognizer*)recognizer
{
    CGFloat translation = [recognizer translationInView:self.view].y;
	CGFloat velocity = [recognizer velocityInView:self.view].y;
	CGFloat menuY = _menuDragView.frame.origin.y;
	CGSize size = self.view.bounds.size;
	if (!_menuShowing) {
		if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
			_menuDragView.frame = CGRectMake(0, size.height - 70 - _menuMinHeight + translation, size.width, size.height);
			_menuView.alpha = _menuMinAlpha + (1 - _menuMinAlpha) * (-translation / (size.height - 70));
		} else if (recognizer.state == UIGestureRecognizerStateEnded && (menuY + 70 < size.height / 2 || velocity < -500)) {
			[self onMenuMoveToTop];
		} else {
			[self onMenuMoveToBottom];
		}
	} else {
		if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
			_menuDragView.frame = CGRectMake(0, 1 + _navigatorView.frame.origin.y + translation, size.width, size.height);
			_menuView.alpha = 1.0 - (1 - _menuMinAlpha) * (translation / (size.height - 70));
		} else if (recognizer.state == UIGestureRecognizerStateEnded && (menuY + 70 > size.height / 2 || velocity > 500)) {
			[self onMenuMoveToBottom];
		} else {
			[self onMenuMoveToTop];
		}
	}
}

@end
