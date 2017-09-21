//
//  UITreeView.m
//  BandeiraBR
//
//  Created by Bernardo Breder on 23/07/14.
//  Copyright (c) 2014 Tecgraf. All rights reserved.
//

#import "UITreeView.h"

@interface UITreeViewNodeState : NSObject

@property (nonatomic, strong) NSObject *object;

@property (nonatomic, assign) BOOL expanded;

@property (nonatomic, assign) NSUInteger level;

@property (nonatomic, strong) UIView *view;

- (id)initWithName:(NSObject*)name andExpanded:(BOOL)expanded andLevel:(NSUInteger)level;

@end

@interface UITreeViewCache : NSObject

@property (nonatomic, strong) NSArray *getChildren;

@property (nonatomic, assign) BOOL hasChildren;

@property (nonatomic, strong) NSString *title;

@end

@interface UITreeView ()

@property (nonatomic, strong) NSMutableArray *nodeArray;

@property (nonatomic, strong) NSMutableDictionary *cache;

@property (nonatomic, strong) NSMutableArray *recusableViews;

@end

@implementation UITreeView

@synthesize nodeArray = _nodeArray;
@synthesize treeDelegate = _treeDelegate;
@synthesize cache = _cache;
@synthesize recusableViews = _recusableViews;
@synthesize rowHeight = _rowHeight;
@synthesize selectedBackgroundColor = _selectedBackgroundColor;
@synthesize offsetY = _offsetY;
@synthesize offsetLevel = _offsetLevel;

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    _nodeArray = [[NSMutableArray alloc] init];
    _cache = [[NSMutableDictionary alloc] init];
    _recusableViews = [[NSMutableArray alloc] init];
    _rowHeight = 44;
    _offsetY = 0;
    _selectedBackgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    _offsetLevel = 50;
    self.delegate = self;
    return self;
}

- (BOOL)hasCachedChildren:(id<NSObject>)node
{
    id<NSCopying> identifier = [_treeDelegate treeView:self getIdentifier:node];
    UITreeViewCache *cache = _cache[identifier];
    if (!cache) {
        cache = [[UITreeViewCache alloc] init];
        cache.getChildren = nil;
        cache.title = nil;
        cache.hasChildren = [_treeDelegate treeView:self hasChildren:node];
        _cache[identifier] = cache;
    }
    return cache.hasChildren;
}

- (NSArray*)getCachedChildren:(id<NSObject>)node
{
    id<NSCopying> identifier = [_treeDelegate treeView:self getIdentifier:node];
    UITreeViewCache *cache = _cache[identifier];
    if (!cache.getChildren) {
        cache.getChildren = [_treeDelegate treeView:self getChildren:node];
    }
    return cache.getChildren;
}

- (NSString*)getCachedTitle:(id<NSObject>)node
{
    id<NSCopying> identifier = [_treeDelegate treeView:self getIdentifier:node];
    UITreeViewCache *cache = _cache[identifier];
    if (!cache.title) {
        cache.title = [_treeDelegate treeView:self getTitle:node];
    }
    return cache.title;
}

- (UIView*)getDefaultView:(id<NSObject>)node withTitle:(NSString*)title hasChildren:(BOOL)hasChildren withExpanded:(BOOL)expanded withFrame:(CGRect)frame
{
    if (_treeDelegate && [_treeDelegate respondsToSelector:@selector(treeView:getViewOfTreeNode:withTitle:hasChildren:withExpanded:withFrame:)]) {
        return [_treeDelegate treeView:self getViewOfTreeNode:node withTitle:title hasChildren:hasChildren withExpanded:expanded withFrame:frame];
    }
    UIView *cell = [self getReusedView];
    if (!cell) {
        cell = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)]];
    }
    UILabel *label = (UILabel*) [cell subviews][0];
    label.text = title;
    return cell;
}

- (UIView*)getDefaultView:(UITreeViewNodeState*)node atIndex:(NSUInteger)index
{
    BOOL hasChildren = [self hasCachedChildren:node.object];
    NSString *title = [self getCachedTitle:node.object];
    CGRect frame = CGRectMake(_offsetLevel * node.level, 0, self.frame.size.width - _offsetLevel * node.level, _rowHeight);
    node.view = [self getDefaultView:node withTitle:title hasChildren:hasChildren withExpanded:node.expanded withFrame:frame];
    node.view.frame = CGRectMake(-frame.size.width, index * _rowHeight, frame.size.width, frame.size.height);
    //    node.view.backgroundColor = [UIColor redColor];
    [node.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGestureRecognizerAction:)]];
    return node.view;
}

- (UIView*)createDefaultView:(UITreeViewNodeState*)node withFrame:(CGRect)frame
{
    BOOL hasChildren = [self hasCachedChildren:node.object];
    NSString *title = [self getCachedTitle:node.object];
    UIView *view = [self getDefaultView:node.object withTitle:title hasChildren:hasChildren withExpanded:node.expanded withFrame:frame];
//    view.frame = frame;
    //    view.backgroundColor = [UIColor redColor];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGestureRecognizerAction:)]];
    [self addSubview:view];
    return view;
}

- (void)removeTreeNodeView:(UIView*)view
{
    [view removeFromSuperview];
    [view removeGestureRecognizer:view.gestureRecognizers[0]];
}

- (UIView*)getReusedView
{
    if (_recusableViews.count == 0) return nil;
    UIView *view = _recusableViews.lastObject;
    [_recusableViews removeLastObject];
    return view;
}

- (void)setRoot:(id<NSObject>)root
{
    _root = root;
    if ([self hasCachedChildren:_root]) {
        NSArray *children = [self getCachedChildren:_root];
        _nodeArray = [[NSMutableArray alloc] initWithCapacity:children.count];
        for (NSUInteger n = 0; n < children.count ; n++) {
            _nodeArray[n] = [[UITreeViewNodeState alloc] initWithName:children[n] andExpanded:false andLevel:0];
        }
    }
}

- (void)expandTreeNodeAtIndex:(NSUInteger)row
{
    @autoreleasepool {
        UITreeViewNodeState *node = _nodeArray[row];
//        CGRect nodeFrame = node.view.frame;
        if ([self hasCachedChildren:node.object]) {
            if (!node.expanded) {
                NSArray *children = [self getCachedChildren:node.object];
                node.expanded = true;
                {
                    UIView *newView = [self createDefaultView:node withFrame:node.view.frame];
                    UIView *oldView = node.view;
                    newView.frame = oldView.frame;
                    newView.alpha = 0.0;
                    node.view = newView;
                    [UIView animateWithDuration:0.2 animations:^() {
                        oldView.alpha = 0.0;
                        newView.alpha = 1.0;
                    }];
                }
                {
                    [UIView animateWithDuration:0.2 animations:^() {
                        for (NSUInteger n = row + 1 ; n < _nodeArray.count ; n++) {
                            UITreeViewNodeState *childNode = _nodeArray[n];
                            if (childNode.view) {
                                childNode.view.frame = CGRectMake(childNode.view.frame.origin.x, _offsetY + (n + children.count) * _rowHeight, self.frame.size.width - childNode.level * _offsetLevel, _rowHeight);
                            }
                        }
                    }];
                }
                {
                    for (NSUInteger n = 0 ; n < children.count ; n++) {
                        id<NSObject> child = children[n];
                        NSUInteger index = row + n + 1;
                        UITreeViewNodeState *childNode = [[UITreeViewNodeState alloc] initWithName:child andExpanded:false andLevel:(node.level + 1)];
                        [_nodeArray insertObject:childNode atIndex:index];
                        CGRect frame = CGRectMake(childNode.level * _offsetLevel, _offsetY + index * _rowHeight, self.frame.size.width - childNode.level * _offsetLevel, _rowHeight);
                        if (CGRectIntersectsRect(self.bounds, frame)) {
                            childNode.view = [self createDefaultView:childNode withFrame:frame];
                            childNode.view.alpha = 0.0;
                        }
                    }
                    [UIView animateWithDuration:0.2 animations:^() {
                        for (NSUInteger n = 0 ; n < children.count ; n++) {
                            NSUInteger index = row + n + 1;
                            UITreeViewNodeState *childNode = _nodeArray[index];
                            if (childNode.view) {
                                childNode.view.alpha = 1.0;
                            }
                        }
                    }];
                }
            }
        }
    }
}

- (void)collapseTreeNode:(NSUInteger)row
{
    @autoreleasepool {
        UITreeViewNodeState *node = _nodeArray[row];
        CGRect nodeFrame = node.view.frame;
        if ([self hasCachedChildren:node.object]) {
            if (node.expanded) {
                CGSize size = self.frame.size;
                NSUInteger childrenCount = 0;
                for (NSUInteger n = row + 1 ; n < _nodeArray.count ; n++) {
                    UITreeViewNodeState *child = _nodeArray[n];
                    if (child.level == node.level) {
                        break;
                    }
                    childrenCount++;
                }
                node.expanded = false;
                {
                    UIView *oldView = node.view;
                    node.view = [self createDefaultView:node withFrame:node.view.frame];
                    node.view.alpha = 0.0;
                    [UIView animateWithDuration:0.2 animations:^() {
                        oldView.alpha = 0.0;
                        node.view.alpha = 1.0;
                    }];
                }
                {
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^() {
                        for (NSUInteger n = 0 ; n < childrenCount ; n++) {
                            UITreeViewNodeState *childNode = _nodeArray[row + n + 1];
                            if (childNode.view) {
                                childNode.view.frame = CGRectMake(childNode.view.frame.origin.x, nodeFrame.origin.y, childNode.view.frame.size.width, _rowHeight);
                                childNode.view.alpha = 0.0;
                            }
                        }
                    } completion:^(BOOL finished) {
                        for (NSUInteger n = 0 ; n < childrenCount ; n++) {
                            UITreeViewNodeState *childNode = _nodeArray[row + 1];
                            if (childNode.view) [self removeTreeNodeView:childNode.view];
                            [_nodeArray removeObjectAtIndex:(row + 1)];
                        }
                    }];
                }
                {
                    for (NSUInteger n = row + childrenCount + 1 ; n < _nodeArray.count ; n++) {
                        UITreeViewNodeState *childNode = _nodeArray[n];
                        CGRect frame = CGRectMake(_offsetLevel * childNode.level, _offsetY + (n - childrenCount) * _rowHeight, size.width - _offsetLevel * childNode.level, _rowHeight);
                        if (CGRectIntersectsRect(self.bounds, frame)) {
                            if (!childNode.view) {
                                childNode.view = [self createDefaultView:childNode withFrame:frame];
                                [self addSubview:childNode.view];
                            }
                        }
                    }
                    [UIView animateWithDuration:0.2 animations:^() {
                        for (NSUInteger n = row + childrenCount + 1 ; n < _nodeArray.count ; n++) {
                            UITreeViewNodeState *childNode = _nodeArray[n];
                            if (CGRectIntersectsRect(self.bounds, CGRectMake(0, _offsetY + (n - childrenCount) * _rowHeight, size.width, _rowHeight))) {
                                if (childNode.view) {
                                    childNode.view.frame = CGRectMake(_offsetLevel * childNode.level, _offsetY + (n - childrenCount) * _rowHeight, childNode.view.frame.size.width, _rowHeight);
                                }
                            }
                        }
                    }];
                }
            }
        }
    }
}

- (id<NSObject>)treeNodeAtRow:(NSUInteger)row
{
    return _nodeArray[row];
}

- (void)layoutSubviews
{
    @autoreleasepool {
        [super layoutSubviews];
        CGRect frame = CGRectMake(0, self.contentOffset.y, self.frame.size.width, self.frame.size.height);
        [_nodeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UITreeViewNodeState *node = obj;
            NSUInteger y = _offsetY + idx * _rowHeight;
            CGRect nodeFrame = CGRectMake(node.level * _offsetLevel, y, self.frame.size.width - node.level * _offsetLevel, _rowHeight);
            if (CGRectIntersectsRect(frame, nodeFrame)) {
                if (!node.view) {
                    node.view = [self createDefaultView:node withFrame:nodeFrame];
                }
            } else if (node.view) {
                [node.view removeFromSuperview];
                [node.view removeGestureRecognizer:node.view.gestureRecognizers[0]];
                [_recusableViews addObject:node.view];
                node.view = nil;
            }
        }];
        self.contentSize = CGSizeMake(self.frame.size.width, _offsetY + _nodeArray.count * _rowHeight);
    }
}

- (BOOL)isExpanded:(NSUInteger)row
{
    return ((UITreeViewNodeState*)_nodeArray[row]).expanded;
}

- (BOOL)isCollapse:(NSUInteger)row
{
    return !((UITreeViewNodeState*)_nodeArray[row]).expanded;
}

- (void)onTapGestureRecognizerAction:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    NSUInteger row = (point.y - _offsetY) / _rowHeight;
    UITreeViewNodeState *node = (UITreeViewNodeState*) _nodeArray[row];
    if ([self hasCachedChildren:node.object]) {
        if ([self isExpanded:row]) {
            [self collapseTreeNode:row];
        } else {
            [self expandTreeNodeAtIndex:row];
        }
    } else if ([_treeDelegate respondsToSelector:@selector(treeView:didSelectRowAtIndexPath:)]) {
        [_treeDelegate treeView:self didSelectRowAtIndexPath:node.object];
    }
    UIColor *backgroundColor = node.view.backgroundColor;
    [UIView animateWithDuration:0.1 animations:^(){
        node.view.backgroundColor = _selectedBackgroundColor;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^(){
            node.view.backgroundColor = backgroundColor;
        }];
    }];
}

@end

@implementation UITreeViewNodeState

@synthesize object = _object;
@synthesize expanded = _expanded;
@synthesize level = _level;

- (id)initWithName:(NSObject*)name andExpanded:(BOOL)expanded andLevel:(NSUInteger)level
{
    if (!(self = [super init])) return self;
    _object = name;
    _expanded = expanded;
    _level = level;
    return self;
}

@end

@implementation UITreeViewCache

@synthesize hasChildren = _hasChildren;
@synthesize getChildren = _getChildren;
@synthesize title = _title;

@end

@implementation UITreeViewDemoViewController

- (void)viewDidLoad
{
    CGSize size = self.view.bounds.size;
    UITreeView *treeView = [[UITreeView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    treeView.treeDelegate = self;
    //    treeView.root = NSHomeDirectory();
    //	treeView.root = @"/Users/bernardobreder/breder";
    treeView.root = @"/";
    [self.view addSubview:treeView];
}

- (BOOL)treeView:(UITreeView*)treeView hasChildren:(id<NSObject>)node
{
    NSString *item = (NSString*)node;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:item error:nil];
    return attrs[NSFileType] == NSFileTypeDirectory;
}

- (NSArray*)treeView:(UITreeView*)treeView getChildren:(id<NSObject>)node
{
    NSString *path = (NSString*) node;
    NSMutableArray *result = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] mutableCopy];
    if ([path isEqualToString:@"/"]) {
        path = @"";
    }
    for (NSUInteger n = 0 ; n < result.count ; n++) {
        result[n] = [[path stringByAppendingString:@"/"] stringByAppendingString:result[n]];
    }
    return result;
}

- (NSString*)treeView:(UITreeView*)treeView getTitle:(id<NSObject>)node
{
    NSString *path = (NSString*) node;
    return [path lastPathComponent];
}

- (id<NSCopying>)treeView:(UITreeView*)treeView getIdentifier:(id<NSObject>)node
{
    NSString *path = (NSString*) node;
    return path;
}

- (UIView*)treeView:(UITreeView*)treeView getViewOfTreeNode:(id<NSObject>)node withTitle:(NSString*)title hasChildren:(BOOL)hasChildren withExpanded:(BOOL)expanded withFrame:(CGRect)frame
{
    static UIImage *infoImage = 0, *expandedImage = 0, *collapsedImage = 0;
    if (!infoImage) infoImage = [UITreeViewDemoViewController createInfoImage:64];
    if (!expandedImage) expandedImage = [UITreeViewDemoViewController createExpandImage:64];
    if (!collapsedImage) collapsedImage = [UITreeViewDemoViewController createCollapseImage:64];
    UIView *cell = [treeView getReusedView];
    if (!cell) {
        cell = [[UIView alloc] initWithFrame:frame];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        imageView.tag = 1;
        [cell addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height)];
        label.tag = 2;
        [cell addSubview:label];
    }
    UIImageView *imageView = (UIImageView*) [cell viewWithTag:1];
    UILabel *label = (UILabel*) [cell viewWithTag:2];
    label.text = title;
    imageView.image = hasChildren ? (expanded ? expandedImage : collapsedImage) : infoImage;
    imageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5 animations:^() {
        imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }];
    return cell;
}

- (void)treeView:(UITreeView *)treeView didSelectRowAtIndexPath:(id<NSObject>)node
{
	NSString *path = (NSString*) node;
	NSString *title = [path lastPathComponent];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Click" message:title delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
}

+ (UIImage*)createInfoImage:(double)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size, size));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    double x = (double) size / 5;
    double y = (double) size / 5;
    double xx = x * 0.25;
    double yy = y * 0.25;
    double lw = (size/10);
    UIColor *lightColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    UIColor *darkColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    CGContextSetLineWidth(context, lw);
    CGContextSetStrokeColorWithColor(context, lightColor.CGColor);
    CGContextStrokeEllipseInRect(context, CGRectMake(xx, y, size-2*xx, size-2*y));
    CGContextSetFillColorWithColor(context, darkColor.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(x+3*xx, y+3*yy, size-2*(x+3*xx), size-2*(y+3*yy)));
    UIGraphicsPopContext();
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)createExpandImage:(double)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size, size));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    double x = (double) size / 5;
    double y = (double) size / 5;
    double lw = (size/10);
    UIColor *darkColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    CGContextSetLineWidth(context, lw);
    //
    CGContextSetFillColorWithColor(context, darkColor.CGColor);
    CGContextMoveToPoint(context, x, 2*y);
    CGContextAddLineToPoint(context, 2.5*x, 4*y);
    CGContextAddLineToPoint(context, 4*x, 2*y);
    CGContextFillPath(context);
    //
    UIGraphicsPopContext();
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)createCollapseImage:(double)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size, size));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    double x = (double) size / 5;
    double y = (double) size / 5;
    double lw = (size/10);
    UIColor *darkColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    CGContextSetLineWidth(context, lw);
    //
    CGContextSetFillColorWithColor(context, darkColor.CGColor);
    CGContextMoveToPoint(context, 2.5*x, y);
    CGContextAddLineToPoint(context, 4*x, 2.5*y);
    CGContextAddLineToPoint(context, 2.5*x, 4*y);
    CGContextFillPath(context);
    //
    UIGraphicsPopContext();
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end