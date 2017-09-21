//
//  UIColorRowTableView.h
//  iBandeiraBR
//
//  Created by Bernardo Breder on 29/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIColorRowTableView;

@protocol UIColorRowTableViewDataSource <NSObject>

@required

- (NSInteger)rowCount:(UIColorRowTableView*)colorRowTableView;

- (NSInteger)columnCount:(UIColorRowTableView*)colorRowTableView;

@optional

- (UIView*)dataViewAt:(UIColorRowTableView*)colorRowTableView atRow:(NSInteger)rowIndex atColumn:(NSInteger)columnIndex withSize:(CGSize)size;

- (UIView*)cornerViewAt:(UIColorRowTableView*)colorRowTableView withSize:(CGSize)size;

- (UIView*)rowViewAt:(UIColorRowTableView*)colorRowTableView atRow:(NSInteger)rowIndex withSize:(CGSize)size;

- (UIView*)columnViewAt:(UIColorRowTableView*)colorRowTableView atColumn:(NSInteger)columnIndex withSize:(CGSize)size;

@end

@interface UIColorRowTableView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) id<UIColorRowTableViewDataSource> dataSource;
@property (nonatomic, assign) NSInteger rowWidth, rowHeight;
@property (nonatomic, assign) NSInteger columnWidth, columnHeight;
@property (nonatomic, assign) NSInteger insect;
@property (nonatomic, assign) bool rowVisible, columnVisible;
@property (nonatomic, assign) id<UIScrollViewDelegate> delegate;

@end

@interface DemoColorRowTableViewDataSource : NSObject <UIColorRowTableViewDataSource>

@end
