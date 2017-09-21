//
//  UITreeView.h
//  BandeiraBR
//
//  Created by Bernardo Breder on 23/07/14.
//  Copyright (c) 2014 Tecgraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITreeView;

@protocol UITreeViewDelegate <NSObject>

@required

- (BOOL)treeView:(UITreeView*)treeView hasChildren:(id<NSObject>)node;

- (NSArray*)treeView:(UITreeView*)treeView getChildren:(id<NSObject>)node;

- (id<NSCopying>)treeView:(UITreeView*)treeView getIdentifier:(id<NSObject>)node;

- (NSString*)treeView:(UITreeView*)treeView getTitle:(id<NSObject>)node;

@optional

- (UIView*)treeView:(UITreeView*)treeView getViewOfTreeNode:(id<NSObject>)node withTitle:(NSString*)title hasChildren:(BOOL)hasChildren withExpanded:(BOOL)expanded withFrame:(CGRect)frame;

- (void)treeView:(UITreeView*)treeView didSelectRowAtIndexPath:(id<NSObject>)node;

@end

@interface UITreeView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) id<NSObject> root;

@property (nonatomic, weak) id<UITreeViewDelegate> treeDelegate;

@property (nonatomic, assign) NSUInteger rowHeight;

@property (nonatomic, strong) UIColor *selectedBackgroundColor;

@property (nonatomic, assign) NSUInteger offsetY;

@property (nonatomic, assign) NSUInteger offsetLevel;

- (id)initWithFrame:(CGRect)frame;

- (void)expandTreeNodeAtIndex:(NSUInteger)row;

- (void)collapseTreeNode:(NSUInteger)row;

- (id<NSObject>)treeNodeAtRow:(NSUInteger)row;

- (UIView*)getReusedView;

@end

@interface UITreeViewDemoViewController : UIViewController <UITreeViewDelegate>

@end