#import "UIInfinitScrollView.h"

@interface UIInfinitScrollView ()

@end

@implementation UIInfinitScrollView

@synthesize view1;
@synthesize view2;
@synthesize view3;
//@synthesize view4;
//@synthesize view5;
@synthesize model;

- (id)initWithCoder:(NSCoder *)inCoder
{
    self = [super initWithCoder:inCoder];
    return self;
}

- (id)initWithModel:(id<UIInfinitScrollViewDelegate>)aModel
{
    self = [super init];
    self.model = aModel;
//    self.backgroundColor = [UIColor orangeColor];
    {
        view1 = [aModel createView];
//        view1.backgroundColor = [UIColor redColor];
        [self addSubview:view1];
        [view1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    }
    {
        view2 = [aModel createView];
//        view2.backgroundColor = [UIColor greenColor];
        view2.accessibilityLabel = @"InfinitView";
        [self addSubview:view2];
        [view2 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    }
    {
        view3 = [aModel createView];
//        view3.backgroundColor = [UIColor blueColor];
        [self addSubview:view3];
        [view3 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    }
//    {
//        view4 = [aModel createView];
////        view4.backgroundColor = [UIColor yellowColor];
//        [self addSubview:view4];
//        [view4 setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view4 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view3 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
//    }
//    {
//        view5 = [aModel createView];
////        view5.backgroundColor = [UIColor grayColor];
//        [self addSubview:view5];
//        [view5 setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view5 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view4 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view5 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view5 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:view5 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
//    }
    self.delegate = self;
    self.contentSize = CGSizeMake(10000, 100);
    self.pagingEnabled = true;
    self.showsHorizontalScrollIndicator = true;
    self.showsVerticalScrollIndicator = false;
    [self fireDataChanged];
    return self;
}

-(void)awakeFromNib
{
    
}

- (UIView*)page
{
    return view2;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"DidScroll");
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    int x = self.contentOffset.x;
    int size = self.frame.size.width * 1;
    if (x != size) {
        if(x > size) {
            self._page++;
            self.contentOffset = CGPointMake(self.contentOffset.x - view2.frame.size.width, 0);
        } else if(x < size) {
            self._page--;
            self.contentOffset = CGPointMake(self.contentOffset.x + view2.frame.size.width, 0);
        }
        [self fireDataChanged];
    }
}

- (void)fireDataChanged
{
//    [model changeView:view1 atPage:self._page - 2];
    [model changeView:view1 atPage:self._page - 1];
    [model changeView:view2 atPage:self._page];
    [model changeView:view3 atPage:self._page + 1];
//    [model changeView:view5 atPage:self._page + 2];
}

- (void)layoutSubviews
{
    CGRect rect = [UIScreen mainScreen].bounds;
    if (view1.frame.size.width != 0) {
        rect = view1.frame;
    }
    if (self.contentSize.width != rect.size.width * 3) {
        self.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
        self.contentOffset = CGPointMake(self.frame.size.width * 1, 0);
    }
    [super layoutSubviews];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self scrollRectToVisible:view2.frame animated:NO];
}



@end
