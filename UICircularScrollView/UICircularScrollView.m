//
//  UICircularScrollView.m
//  BandeiraBR
//
//  Created by Bernardo Breder on 24/03/14.
//  Copyright (c) 2014 Tecgraf. All rights reserved.
//

#import "UICircularScrollView.h"

@interface UICircularScrollView ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray *viewLoadedArray;
@property (nonatomic, assign) NSInteger viewShift;

@end

@implementation UICircularScrollView

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
	scrollView.showsHorizontalScrollIndicator = false;
	scrollView.showsVerticalScrollIndicator = false;
    scrollView.delegate = self;
	_scrollView = scrollView;
	[self addSubview:scrollView];
	UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 30, frame.size.width, 30)];
	pageControl.defersCurrentPageDisplay = true;
	pageControl.hidesForSinglePage = true;
	pageControl.userInteractionEnabled = false;
	_pageControl = pageControl;
	[self addSubview:pageControl];
    _pageCount = -1;
    _pageIndex = 0;
	_viewLoadedArray = [[NSMutableArray alloc] init];
    return self;
}

- (void)enumerateObjectsUsingBlock:(void (^)(UIView *view, NSUInteger pageIndex, BOOL *stop))block
{
	BOOL stop = false;
	for (NSUInteger n = 0 ; !stop && n < _pageCount ; n++) {
		if (_viewLoadedArray[n] != [NSNull null]) {
			UIView *view = _viewLoadedArray[n];
			block(view, n, &stop);
		}
	}
}

- (CGRect)getViewRect:(NSInteger)index
{
	CGFloat w = self.frame.size.width;
	CGFloat cx = _scrollView.contentOffset.x;
	NSInteger level = ABS(_viewShift) % _pageCount;
	NSInteger off = index;
	if (_viewShift >= 0) {
		off = (index + level) % _pageCount;
	} else {
		off = (index + level * (_pageCount - 1)) % _pageCount;
	}
	if (cx < w && off - _pageCount + 1 == 0) {
		off -= _pageCount;
	}
	else if (cx > _scrollView.contentSize.width - 2 * w && off == 0) {
		off += _pageCount;
	}
	CGFloat x = (off + 1) * w;
	CGRect rect = CGRectMake(x, 0, w, self.frame.size.height);
	return rect;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_dataSource && _pageCount >= 1) {
		@autoreleasepool {
			CGSize size = self.frame.size;
			CGFloat x = _scrollView.contentOffset.x;
			CGFloat w = size.width;
			int pageRounded = roundf(x / w);
			if (_viewShift > 0) {
				_pageControl.currentPage = (pageRounded + _viewShift * (_pageCount - 1) - 1) % _pageCount;
			} else {
				_pageControl.currentPage = (pageRounded + -_viewShift - 1) % _pageCount;
			}
			// Se ele estiver completamente na end page
			if (pageRounded == _pageCount + 1) {
				_viewShift--;
				_scrollView.contentOffset = CGPointMake(x - size.width, 0);
			}
			// Se ele estiver completamente na end page
			else if (pageRounded == 0) {
				_viewShift++;
				_scrollView.contentOffset = CGPointMake(x + size.width, 0);
			}
			CGRect contentRect = CGRectMake(x, 0, w, size.height);
			for (NSUInteger n = 0 ; n < _pageCount ; n++) {
				CGRect viewRect = [self getViewRect:n];
				if (CGRectIntersectsRect(contentRect, viewRect) && _viewLoadedArray[n] == [NSNull null]) {
					UIView *view = [_dataSource circularScrollView:self pageForIndex:n withFrame:viewRect];
					_viewLoadedArray[n] = view;
					[_scrollView addSubview:view];
				}
				if (_viewLoadedArray[n] != [NSNull null]) {
					UIView *view = _viewLoadedArray[n];
					view.frame = viewRect;
				}
			}
		}
	}
}

- (void)setDataSource:(id<UICircularScrollViewDataSource>)dataSource
{
	_dataSource = dataSource;
	CGSize size = self.frame.size;
	_pageCount = [dataSource numberOfPages:self];
	[_viewLoadedArray removeAllObjects];
	for (NSUInteger n = 0 ; n < _pageCount ; n++) {
		[_viewLoadedArray addObject:[NSNull null]];
	}
	if (_pageCount > 1) {
		_scrollView.contentSize = CGSizeMake(size.width * (_pageCount + 2), size.height);
		_scrollView.contentOffset = CGPointMake((_pageIndex + 1) * size.width, 0);
		_pageControl.numberOfPages = _pageCount;
		_pageControl.alpha = 1.0;
	} else {
		_scrollView.contentSize = CGSizeMake(size.width, size.height);
		_scrollView.contentOffset = CGPointMake((_pageIndex + 1) * size.width, 0);
		_pageControl.alpha = 0.0;
	}
}

- (void)setPagingEnabled:(BOOL)pagingEnabled
{
	_scrollView.pagingEnabled = pagingEnabled;
}

- (BOOL)pagingEnabled
{
	return _scrollView.pagingEnabled;
}

- (void)setPageIndex:(NSInteger)pageIndex
{
	if (pageIndex >= _pageCount) return;
	_pageIndex = pageIndex;
	_pageControl.currentPage = pageIndex;
	_scrollView.contentOffset = CGPointMake((pageIndex + 1) * self.frame.size.width, 0);
}

- (void)didReceiveMemoryWarning
{
	@autoreleasepool {
		CGSize size = self.frame.size;
		CGRect contentRect = CGRectMake(_scrollView.contentOffset.x, 0, size.width, size.height);
		for (NSUInteger n = 0 ; n < _pageCount ; n++) {
			CGRect viewRect = CGRectMake((n + 1) * size.width, 0, size.width, size.height);
			if (_viewLoadedArray[n] != [NSNull null] && !CGRectIntersectsRect(contentRect, viewRect)) {
				[_viewLoadedArray[n] removeFromSuperview];
			}
		}
    }
}

@end

@implementation UICircularScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	CGSize size = self.view.frame.size;
	UICircularScrollView *view = [[UICircularScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	view.dataSource = self;
	view.pageIndex = 0;
//	view.pagingEnabled = true;
	[self.view addSubview:view];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[view didReceiveMemoryWarning];
	});
}

- (NSInteger)numberOfPages:(UICircularScrollView*)circularScrollView
{
    return 3;
}

- (UIView*)circularScrollView:(UICircularScrollView*)circularScrollView pageForIndex:(NSInteger)index withFrame:(CGRect)frame
{
	static NSArray *colors = 0;
	if (!colors) colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor], [UIColor brownColor], [UIColor orangeColor], [UIColor magentaColor]];
	UIColor *color = colors[index];
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = [NSString stringWithFormat:@"Line %ld", (long)index+1];
	label.layer.backgroundColor = color.CGColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	UICircularScrollView *view = (UICircularScrollView*) self.view.subviews[0];
	[view didReceiveMemoryWarning];
}

@end