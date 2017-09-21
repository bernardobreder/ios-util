//
//  UIMenuViewController.m
//  iBandeiraSimple
//
//  Created by Bernardo Breder on 27/07/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIVerticalMenuView.h"

@interface UIVerticalMenuView ()

@property (nonatomic, strong) UIView *bottomDragView;

@property (nonatomic, strong) UIView *topRecognizerView;

@end

@implementation UIVerticalMenuView

@synthesize contentView = _contentView;
@synthesize bottomView = _bottomView;
@synthesize bottomDragView = _bottomDragView;
@synthesize topView = _topView;
@synthesize topViewMargin = _topViewMargin;
@synthesize bottomViewMargin = _bottomViewMargin;
@synthesize topViewEnable = _topViewEnable;
@synthesize bottomViewEnable = _bottomViewEnable;
@synthesize minAlpha = _minAlpha;
@synthesize bottomDragRect = _bottomDragRect;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    CGSize size = frame.size;
    _topViewMargin = 0;
    _bottomViewMargin = 0;
    _topViewEnable = true;
    _bottomViewEnable = true;
    _minAlpha = 0.2;
    _bottomDragRect = CGRectMake(0, size.height - 75, size.width, 75);
    {
        _bottomDragView = [[UIView alloc] initWithFrame:_bottomDragRect];
//        _bottomDragView.backgroundColor = [UIColor redColor];
        [self addSubview:_bottomDragView];
        [_bottomDragView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bottomPanGestureRecognizerAction:)]];
    }
    return self;
}

- (void)setContentView:(UIView *)contentView
{
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    CGSize size = self.frame.size;
    _contentView.frame = CGRectMake(0, 0, size.width, size.height);
    [self addSubview:_contentView];
    [self bringSubviewToFront:_bottomDragView];
    [self bringSubviewToFront:_bottomView];
}

- (void)setBottomView:(UIView *)bottomView
{
    if (_bottomView) {
        [_bottomView removeFromSuperview];
    }
    _bottomView = bottomView;
    CGSize size = self.frame.size;
    _bottomView.frame = CGRectMake(0, size.height - _bottomViewMargin, size.width, size.height - 70);
    _bottomView.alpha = _minAlpha;
    _bottomView.userInteractionEnabled = false;
    [self addSubview:_bottomView];
    [_bottomView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bottomPanGestureRecognizerAction:)]];
    //    _bottomView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
}

- (void)setBottomDragRect:(CGRect)bottomTouchRect
{
    _bottomDragRect = bottomTouchRect;
    _bottomDragView.frame = bottomTouchRect;
}

- (void)bottomViewShow
{
    if (_bottomViewEnable) {
        CGSize size = self.frame.size;
        [UIView animateWithDuration:1.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^() {
            _bottomView.frame = CGRectMake(0, 71, size.width, size.height - 71);
            _bottomView.alpha = 1.0;
            _bottomView.userInteractionEnabled = true;
            _bottomDragView.userInteractionEnabled = false;
        } completion:nil];
    }
}

- (void)bottomViewHide
{
    if (_bottomViewEnable) {
        CGSize size = self.frame.size;
        [UIView animateWithDuration:1.0 animations:^() {
            _bottomView.frame = CGRectMake(0, size.height - _bottomViewMargin, size.width, _bottomViewMargin);
            _bottomView.alpha = _minAlpha;
            _bottomView.userInteractionEnabled = false;
            _bottomDragView.userInteractionEnabled = true;
        }];
    }
}

- (void)topViewShow
{
    if (_topViewEnable) {
        CGSize size = self.frame.size;
        [UIView animateWithDuration:1.0 animations:^() {
            _topView.frame = CGRectMake(0, 0, size.width, 70);
            _topView.alpha = 1.0;
        }];
    }
}

- (void)topViewHide
{
    if (_topViewEnable) {
        CGSize size = self.frame.size;
        [UIView animateWithDuration:1.0 animations:^() {
            _topView.frame = CGRectMake(0, _topViewMargin - 70, size.width, 70);
            _topView.alpha = _minAlpha;
        }];
    }
}

- (void)setMinAlpha:(CGFloat)minAlpha
{
    _minAlpha = minAlpha;
    _bottomView.alpha = minAlpha;
}

- (void)setBottomViewEnable:(BOOL)bottomViewEnable
{
    _bottomViewEnable = bottomViewEnable;
    if (bottomViewEnable) {
        [self bottomViewHide];
    }
}

- (void)setTopViewEnable:(BOOL)topViewEnable
{
    _topViewEnable = topViewEnable;
    if (topViewEnable) {
        [self topViewHide];
    }
}

- (void)setBottomViewMargin:(NSInteger)bottomViewMargin
{
    _bottomViewMargin = bottomViewMargin;
    [self bottomViewHide];
}

- (void)setTopViewMargin:(NSInteger)topViewMargin
{
    _topViewMargin = topViewMargin;
    [self topViewHide];
}

- (void)bottomPanGestureRecognizerAction:(UIPanGestureRecognizer*)recognizer
{
    CGSize size = self.frame.size;
    CGPoint velocity = [recognizer velocityInView:_contentView];
    CGPoint location = [recognizer locationInView:_contentView];
    if (recognizer.view == _bottomDragView) {
        CGFloat delta = MIN(1, MAX(0, (CGFloat)(size.height - location.y) / (size.height - 70)));
        if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
            _bottomView.frame = CGRectMake(0, location.y, _bottomView.frame.size.width, size.height - location.y);
            _bottomView.alpha = _minAlpha + (delta) * (1.0 - _minAlpha);
        } else if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (delta > 0.3 || ABS(velocity.y) > 500) {
                [self bottomViewShow];
            } else {
                [self bottomViewHide];
            }
        }
    } else if (recognizer.view == _bottomView) {
        CGPoint translation = [recognizer translationInView:_bottomView];
        CGFloat delta = MIN(1, MAX(0, 1 - ((CGFloat)(translation.y) / (size.height - 70))));
        if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
            _bottomView.frame = CGRectMake(0, 70 + translation.y, _bottomView.frame.size.width, size.height - 70 - translation.y);
            _bottomView.alpha = delta;
        } else if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (velocity.y > 500) {
                [self bottomViewHide];
            } else if (delta > 0.7) {
                [self bottomViewShow];
            } else {
                [self bottomViewHide];
            }
        }
    }
}

@end

@implementation UIVerticalMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize size = self.view.bounds.size;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    contentView.backgroundColor = [UIColor greenColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height - 70)];
    //    view.backgroundColor = [UIColor redColor];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomAction)]];
    
    UIVerticalMenuView *menuView = [[UIVerticalMenuView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    menuView.contentView = contentView;
    menuView.bottomView = view;
    menuView.bottomViewMargin = 5.0;
    menuView.bottomViewEnable = true;
    menuView.bottomDragRect = CGRectMake(40, size.height - 40, size.width - 80, 40);
    
    
    [self.view addSubview:menuView];
}

- (void)bottomAction
{
    NSLog(@"Bottom Action");
}

@end