#import "UILazyPageView.h"

@interface UILazyPageView ()

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray* pageArray;

@end

@implementation UILazyPageView

//@synthesize reusablePageView;
@synthesize lazyPageDataSource;
@synthesize pageCount;
@synthesize pageArray;

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    self.pageCount = -1;
    return self;
}

- (id)init
{
    if (!(self = [super init])) return nil;
    self.pageCount = -1;
    return self;
}

- (NSInteger)pageIndex
{
    return MIN(pageCount-1,MAX(0,floor(self.contentOffset.x / self.frame.size.width)));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    @autoreleasepool {
        if (pageCount < 0) {
            pageArray = [[NSMutableArray alloc] init];
            if (lazyPageDataSource) {
                pageCount = [lazyPageDataSource numberOfPages:self];
            } else {
                pageCount = 0;
            }
            for (int n = 0; n < pageCount ; n++) {
                [pageArray addObject:[NSNull null]];
            }
        }
        self.contentSize = CGSizeMake(self.frame.size.width * pageCount, self.frame.size.height);
        NSInteger currentPageIndex = [self pageIndex];
        NSInteger minPageIndex = MAX(0, currentPageIndex-1);
        NSInteger maxPageIndex = MIN(pageCount-1, currentPageIndex+1);
        for (NSInteger n = 0; n < pageCount ; n++) {
            if (pageArray[n] != [NSNull null]) {
                if (n < minPageIndex || n > maxPageIndex) {
                    UIView* view = pageArray[n];
                    [view removeFromSuperview];
                    pageArray[n] = [NSNull null];
                    //                NSLog(@"Remove %d index", n);
                }
            }
        }
        for (NSInteger n = minPageIndex; n <= maxPageIndex ; n++) {
            if (pageArray[n] == [NSNull null]) {
                UIView* pageView = [lazyPageDataSource lazyPageView:self pageForIndex:n];
                if (pageView) {
                    pageArray[n] = pageView;
                    pageView.frame = CGRectMake(n*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                    [self addSubview:pageView];
                    //                NSLog(@"Add %d index", n);
                }
            }
        }
        //    NSLog(@"%@ %@", NSStringFromCGPoint(self.contentOffset), NSStringFromCGSize(self.contentSize));
    }
}

- (void)reloadData
{
    @autoreleasepool {
        if (lazyPageDataSource) {
            pageCount = [lazyPageDataSource numberOfPages:self];
        } else {
            pageCount = 0;
        }
        pageArray = [[NSMutableArray alloc] init];
        for (NSInteger n = 0; n < pageCount ; n++) {
            [pageArray addObject:[NSNull null]];
        }
        [self layoutSubviews];
        [self setNeedsDisplay];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGSize size = UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? CGSizeMake(MIN(self.frame.size.width,self.frame.size.height), MAX(self.frame.size.width,self.frame.size.height)) : CGSizeMake(MAX(self.frame.size.width,self.frame.size.height), MIN(self.frame.size.width,self.frame.size.height));
    CGSize oldSize = UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? CGSizeMake(MAX(self.frame.size.width,self.frame.size.height), MIN(self.frame.size.width,self.frame.size.height)) : CGSizeMake(MIN(self.frame.size.width,self.frame.size.height), MAX(self.frame.size.width,self.frame.size.height));
    NSInteger currentPageIndex = MIN(pageCount-1,MAX(0,floor(self.contentOffset.x / oldSize.width)));
    [self scrollRectToVisible:CGRectMake(currentPageIndex * size.width, 0, size.width, size.height) animated:YES];
    NSInteger minPageIndex = MAX(0, currentPageIndex-1);
    NSInteger maxPageIndex = MIN(pageCount-1, currentPageIndex+1);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:duration];
    for (NSInteger n = minPageIndex; n <= maxPageIndex ; n++) {
        if (pageArray[n] != [NSNull null]) {
            UIView* pageView = pageArray[n];
            pageView.frame = CGRectMake(n*size.width, 0, size.width, size.height);
            //            NSLog(@"Resize index:%d to:%@", n, NSStringFromCGSize(size));
        }
    }
    [UIView commitAnimations];
}

@end
