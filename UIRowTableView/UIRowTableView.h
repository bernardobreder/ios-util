//
//  UIRowTableView.h
//  BandeiraBR
//
//  Created by Bernardo Breder on 23/03/14.
//  Copyright (c) 2014 Tecgraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIRowTableView;
@class UIRowTableViewCell;

@protocol UIRowTableViewDataSource <NSObject>

@required

- (NSInteger)rowTableViewGetRowCount:(UIRowTableView*)rowTableView;

- (NSInteger)rowTableViewGetColumnCount:(UIRowTableView*)rowTableView;

- (UIView*)rowTableViewGetRowView:(UIRowTableView*)rowTableView atRow:(NSInteger)rowIndex reusedRowView:(UIView*)reusedRowView withFrame:(CGRect)frame isSelected:(BOOL)selected;

- (UIView*)rowTableViewGetCellView:(UIRowTableView*)rowTableView atRow:(NSInteger)rowIndex atColumn:(NSInteger)columnIndex reusedCellView:(UIView*)reusedCellView withFrame:(CGRect)frame isSelected:(BOOL)selected;

- (NSString*)rowTableViewGetIndexText:(UIRowTableView*)rowTableView atRow:(NSInteger)rowIndex;

@end

@protocol UIRowTableViewDelegate <NSObject>

@optional

- (void)rowTableView:(UIRowTableView*)rowTableView didSelectedRow:(NSUInteger)rowIndex;

- (void)rowTableView:(UIRowTableView*)rowTableView didSelectedRow:(NSUInteger)rowIndex andColumn:(NSUInteger)columnIndex;

@end

@interface UIRowTableViewCell : UIView

@end

@interface UIRowTableView : UIScrollView

@property (nonatomic, weak) id<UIRowTableViewDataSource> dataSource;
@property (nonatomic, weak) id<UIRowTableViewDelegate> componentDelegate;
@property (nonatomic, assign) NSUInteger marginHead;
@property (nonatomic, assign) NSUInteger marginTail;
@property (nonatomic, assign) NSInteger rowHeight;
@property (nonatomic, assign) NSInteger cellHeight;
@property (nonatomic, assign) NSInteger indexWidth;

- (void)enumerateRowsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (void)enumerateCellsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (UIView*)getRowViewReused;

- (UIView*)getCellViewReused;

- (void)reloadData;

- (CGRect)rectForRow:(NSInteger)row;

- (CGRect)rectForRowAndCells:(NSInteger)row;

- (CGRect)rectForCell:(NSInteger)row at:(NSInteger)column;

- (CGRect)rectForIndex;

- (CGRect)rectForIndex:(NSInteger)row;

@end

@interface UIRowTableViewController : UIViewController <UIRowTableViewDataSource, UIRowTableViewDelegate>

@end
