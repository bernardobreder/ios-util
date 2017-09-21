//
//  UIRowTableView.m
//  BandeiraBR
//
//  Created by Bernardo Breder on 23/03/14.
//  Copyright (c) 2014 Tecgraf. All rights reserved.
//

#import "UIRowTableView.h"

@interface UIRowTableView ()

@property (nonatomic, assign) bool needReloadLayout;
@property (nonatomic, assign) bool needReloadData;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) bool indexPressed;
@property (nonatomic, strong) NSMutableArray *cellViewCached;
@property (nonatomic, strong) NSMutableArray *rowViewCached;
@property (nonatomic, strong) NSMutableArray *indexViewCached;
@property (nonatomic, strong) NSMutableArray *cellViewReused;
@property (nonatomic, strong) NSMutableArray *rowViewReused;

@end

@implementation UIRowTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    _needReloadLayout = true;
    _needReloadData = true;
    _cellViewCached = [[NSMutableArray alloc] init];
    _rowViewCached = [[NSMutableArray alloc] init];
    _indexViewCached = [[NSMutableArray alloc] init];
    _cellViewReused = [[NSMutableArray alloc] init];
    _rowViewReused = [[NSMutableArray alloc] init];
    _marginHead = 0;
    _marginTail = 0;
    _rowHeight = 70;
    _cellHeight = 50;
    _indexWidth = 44;
    self.alwaysBounceHorizontal = false;
    self.alwaysBounceVertical = true;
    self.pagingEnabled = false;
    return self;
}

- (CGRect)rectForRow:(NSInteger)row
{
    CGFloat cy = self.contentOffset.y;
    CGFloat y = _marginHead;
    y += row * _rowHeight;
    y += row * _columnCount * _cellHeight;
    y = MIN(MAX(cy, y), _marginHead + row * _rowHeight + (row + 1) * _columnCount * _cellHeight);
    return CGRectMake(0, y, self.frame.size.width, _rowHeight);
}

- (CGRect)rectForRowAndCells:(NSInteger)row
{
    NSInteger y = _marginHead;
    y += row * _rowHeight;
    y += row * _columnCount * _cellHeight;
    NSInteger h = 0;
    h += _rowHeight;
    h += _columnCount * _cellHeight;
    return CGRectMake(0, y, self.frame.size.width, h);
}

- (CGRect)rectForCell:(NSInteger)row at:(NSInteger)column
{
    CGFloat w = self.frame.size.width;
    CGFloat h = _cellHeight;
    NSInteger y = _marginHead;
    y += (row+1) * _rowHeight;
    y += row * _columnCount * _cellHeight;
    y += column * _cellHeight;
    return CGRectMake(0, y, w, h);
}

- (CGRect)rectForIndex
{
    CGFloat w = self.frame.size.width;
    return CGRectMake(w - _indexWidth, 0, _indexWidth, self.frame.size.height);
}

- (CGRect)rectForIndex:(NSInteger)row
{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height / _rowCount;
    CGFloat y = h * row + self.contentOffset.y;
    return CGRectMake(w - _indexWidth, y, _indexWidth, h);
}

- (void)enumerateRowsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    UIView *nullView = (UIView*) [NSNull null];
    BOOL stop = false;
    for (NSInteger row = 0; !stop && row < _rowCount ; row++) {
        UIView *rowView = [_rowViewCached objectAtIndex:row];
        if (rowView != nullView) {
            block(rowView, row, &stop);
        }
    }
}

- (void)enumerateCellsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    UIView *nullView = (UIView*) [NSNull null];
    BOOL stop = false;
    for (NSInteger row = 0; !stop && row < _rowCount ; row++) {
        for (NSInteger col = 0; !stop && col < _columnCount ; col++) {
            NSInteger cellIndex = row * _columnCount + col;
            UIView *cellView = [_cellViewCached objectAtIndex:cellIndex];
            if (cellView != nullView) {
                block(cellView, cellIndex, &stop);
            }
        }
    }
}

- (void)setComponentDelegate:(id<UIRowTableViewDelegate>)componentDelegate
{
    _componentDelegate = componentDelegate;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)]];
}

- (void)onTapAction:(UITapGestureRecognizer*)recognizer
{
    if (_componentDelegate) {
        CGPoint point = [recognizer locationInView:self];
        for (NSUInteger r = 0 ; r < _rowCount ; r++) {
            CGRect rowCellsRect = [self rectForRowAndCells:r];
            if (CGRectContainsPoint(rowCellsRect, point)) {
                CGRect rowRect = [self rectForRow:r];
                if (CGRectContainsPoint(rowRect, point)) {
                    if ([_componentDelegate respondsToSelector:@selector(rowTableView:didSelectedRow:)]) {
                        {
                            UIView *view = [_dataSource rowTableViewGetRowView:self atRow:r reusedRowView:nil withFrame:rowRect isSelected:true];
                            [self addSubview:view];
                            [UIView animateWithDuration:0.2 animations:^() {
                                view.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                view.alpha = 0.0;
                            } completion:^(BOOL finished) {
                                [view removeFromSuperview];
                            }];
                        }
                        [_componentDelegate rowTableView:self didSelectedRow:r];
                    }
                } else {
                    for (NSUInteger c = 0 ; c < _columnCount ; c++) {
                        CGRect cellRect = [self rectForCell:r at:c];
                        if (CGRectContainsPoint(cellRect, point)) {
                            if ([_componentDelegate respondsToSelector:@selector(rowTableView:didSelectedRow:andColumn:)]) {
                                {
                                    UIView *view = [_dataSource rowTableViewGetCellView:self atRow:r atColumn:c reusedCellView:nil withFrame:cellRect isSelected:true];
                                    [self addSubview:view];
                                    [UIView animateWithDuration:0.2 animations:^() {
                                        view.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                        view.alpha = 0.0;
                                    } completion:^(BOOL finished) {
                                        [view removeFromSuperview];
                                    }];
                                }
                                [_componentDelegate rowTableView:self didSelectedRow:r andColumn:c];
                            }
                            break;
                        }
                    }
                }
                break;
            }
        }
    }
}

- (void)_updateLayout
{
    _needReloadLayout = NO;
    _rowCount = _dataSource ? ([_dataSource respondsToSelector:@selector(rowTableViewGetRowCount:)] ? [_dataSource rowTableViewGetRowCount:self] : 0) : 0;
    for (UIView *indexView in _indexViewCached) {
        [indexView removeFromSuperview];
    }
    [_indexViewCached removeAllObjects];
    for (NSInteger index = 0; index < _rowCount ; index++) {
        [_indexViewCached addObject:[NSNull null]];
    }
    self.contentSize = CGSizeMake(self.frame.size.width, _marginHead + _rowCount * _rowHeight + _rowCount * _columnCount * _cellHeight + _marginTail);
}

- (void)_updateData
{
    _needReloadData = NO;
    UIView *nullValue = (UIView*) [NSNull null];
    for (UIView *rowView in _rowViewCached) {
        if (rowView != nullValue) {
            [rowView removeFromSuperview];
        }
    }
    [_rowViewCached removeAllObjects];
    for (UIView *cellView in _cellViewCached) {
        if (cellView != nullValue) {
            [cellView removeFromSuperview];
        }
    }
    [_cellViewCached removeAllObjects];
    _rowCount = _dataSource ? [_dataSource rowTableViewGetRowCount:self] : 0;
    _columnCount = _dataSource ? [_dataSource rowTableViewGetColumnCount:self] : 0;
    for (NSInteger row = 0; row < _rowCount ; row++) {
        [_rowViewCached addObject:nullValue];
        for (NSInteger col = 0; col < _columnCount ; col++) {
            [_cellViewCached addObject:nullValue];
        }
    }
    self.contentSize = CGSizeMake(self.frame.size.width, _marginHead + _rowCount * _rowHeight + _rowCount * _columnCount * _cellHeight + _marginTail);
}

- (void)_updateViews
{
    const CGSize boundsSize = self.bounds.size;
    const CGFloat contentOffset = MIN(MAX(0, self.contentOffset.y),self.contentSize.height);
    const CGRect contentView = CGRectMake(0, contentOffset, boundsSize.width - boundsSize.width * 0.1, boundsSize.height);
    UIView *nullView = (UIView*) [NSNull null];
    for (NSInteger row = 0; row < _rowCount ; row++) {
        CGRect rowCellsRect = [self rectForRowAndCells:row];
        if (CGRectIntersectsRect(rowCellsRect, contentView)) {
            {
                UIView *rowView = [_rowViewCached objectAtIndex:row];
                if (rowView == nullView) {
                    CGRect rowRect = [self rectForRow:row];
                    UIView *reusedView = [self getRowViewReused];
                    rowView = [_dataSource rowTableViewGetRowView:self atRow:row reusedRowView:reusedView withFrame:rowRect isSelected:false];
                    if (reusedView == nil) {
                        [self addSubview:rowView];
                    }
                    rowView.frame = rowRect;
                    _rowViewCached[row] = rowView;
                } else {
                    CGRect frame = [self rectForRow:row];
                    rowView.frame = frame;
                }
                [self bringSubviewToFront:rowView];
            }
            for (NSInteger col = 0; col < _columnCount ; col++) {
                NSInteger cellIndex = row * _columnCount + col;
                CGRect colRect = [self rectForCell:row at:col];
                if (CGRectIntersectsRect(colRect, contentView)) {
                    UIView *cellView = [_cellViewCached objectAtIndex:cellIndex];
                    if (cellView == nullView) {
                        UIView *reusedView = [self getCellViewReused];
                        UIView* cellView = [_dataSource rowTableViewGetCellView:self atRow:row atColumn:col reusedCellView:reusedView withFrame:colRect isSelected:false];
                        if (reusedView == nil) {
                            [self addSubview:cellView];
                        } else {
                            reusedView.alpha = 1.0;
                            cellView.frame = colRect;
                        }
                        _cellViewCached[cellIndex] = cellView;
                    }
                } else {
                    UIView *cellView = [_cellViewCached objectAtIndex:cellIndex];
                    if (cellView != nullView) {
                        cellView.alpha = 0.0;
                        _cellViewCached[cellIndex] = nullView;
                        [_cellViewReused addObject:cellView];
                    }
                }
            }
        } else {
            UIView *rowView = [_rowViewCached objectAtIndex:row];
            if (rowView != nullView) {
                _rowViewCached[row] = nullView;
                [_rowViewReused addObject:rowView];
            }
            for (NSInteger col = 0; col < _columnCount ; col++) {
                NSInteger cellIndex = row * _columnCount + col;
                UIView *cellView = [_cellViewCached objectAtIndex:cellIndex];
                if (cellView != nullView) {
                    cellView.alpha = 0.0;
                    _cellViewCached[cellIndex] = nullView;
                    [_cellViewReused addObject:cellView];
                }
            }
        }
    }
	for (NSInteger row = 0; row < _rowCount ; row++) {
		UILabel *label;
		if (row >= _indexViewCached.count || _indexViewCached[row] == nullView) {
			NSString *text = [self.dataSource rowTableViewGetIndexText:self atRow:row];
			label = [[UILabel alloc] init];
			label.text = text;
			label.textAlignment = NSTextAlignmentCenter;
			label.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
			label.font = [UIFont fontWithName:@"Futura" size:12.0];
			label.userInteractionEnabled = true;
			[label addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_onIndexPan:)]];
			[label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onIndexTap:)]];
			[self addSubview:label];
			_indexViewCached[row] = label;
		} else {
			label = _indexViewCached[row];
			label.text = [self.dataSource rowTableViewGetIndexText:self atRow:row];
		}
		label.frame = [self rectForIndex:row];
		[self bringSubviewToFront:label];
	}
}

- (UIView*)getRowViewReused
{
    if (_rowViewReused.count == 0) {
        return nil;
    }
    UIView *view = _rowViewReused.lastObject;
    [_rowViewReused removeLastObject];
    return view;
}

- (UIView*)getCellViewReused
{
    if (_cellViewReused.count == 0) {
        return nil;
    }
    UIView *view = _cellViewReused.lastObject;
    [_cellViewReused removeLastObject];
    return view;
}

- (void)reloadData
{
    _needReloadLayout = true;
    _needReloadData = true;
    [self layoutSubviews];
}

- (void)_updateLayoutIfNeeded
{
    if (_needReloadLayout || CGSizeEqualToSize(_size, self.frame.size)) {
        [self _updateLayout];
    }
}

- (void)_updateDataIfNeeded
{
    if (_needReloadData) {
        [self _updateData];
    }
}

- (void)layoutSubviews
{
    @autoreleasepool {
        [self _updateLayoutIfNeeded];
        [self _updateDataIfNeeded];
        [self _updateViews];
    }
}

- (void)_onIndexGestureRecognizer:(UIGestureRecognizer*)recognizer
{
    @autoreleasepool {
        CGPoint location = [recognizer locationInView:self];
        for (NSInteger index = 0; index < _rowCount ; index++) {
            CGRect indexRect = [self rectForIndex:index];
            if (CGRectContainsPoint(indexRect, location)) {
                CGRect rectForRowAndCells = [self rectForRowAndCells:index];
                if (self.contentOffset.y != rectForRowAndCells.origin.y) {
                    self.contentOffset = CGPointMake(0, rectForRowAndCells.origin.y);
                    UILabel *label = _indexViewCached[index];
                    [UIView animateWithDuration:0.2 animations:^() {
                        label.layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.1 animations:^() {
                            label.layer.backgroundColor = [UIColor clearColor].CGColor;
                        }];
                    }];
                }
                break;
            }
        }
    }
}

- (void)_onIndexTap:(UIPanGestureRecognizer*)recognizer
{
    [self _onIndexGestureRecognizer:recognizer];
}

- (void)_onIndexPan:(UIPanGestureRecognizer*)recognizer
{
    [self _onIndexGestureRecognizer:recognizer];
}

@end

@implementation UIRowTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize size = self.view.bounds.size;
    UIRowTableView *tableView = [[UIRowTableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    tableView.marginHead = 50;
    tableView.marginTail = 50;
    tableView.dataSource = self;
    tableView.componentDelegate = self;
    tableView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:tableView];
}

- (NSInteger)rowTableViewGetRowCount:(UIRowTableView*)rowTableView
{
    return 5;
}

- (NSInteger)rowTableViewGetColumnCount:(UIRowTableView*)rowTableView
{
    return 5;
}

- (UIView*)rowTableViewGetRowView:(UIRowTableView*)rowTableView atRow:(NSInteger)rowIndex reusedRowView:(UIView*)reusedRowView withFrame:(CGRect)frame isSelected:(BOOL)selected
{
    UILabel *label = (UILabel*) reusedRowView;
    if (!label) label = [[UILabel alloc] initWithFrame:frame];
    label.text = [NSString stringWithFormat:@"Row %ld", (unsigned long) rowIndex];
    label.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    return label;
}

- (UIView*)rowTableViewGetCellView:(UIRowTableView*)rowTableView atRow:(NSInteger)rowIndex atColumn:(NSInteger)columnIndex reusedCellView:(UIView*)reusedCellView withFrame:(CGRect)frame isSelected:(BOOL)selected
{
    UIView *view = reusedCellView;
    if (!view){
        view = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.tag = 1;
        label.layer.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.1].CGColor;
        [view addSubview:label];
    }
    view.frame = frame;
    UILabel *label = (UILabel*) [view viewWithTag:1];
    label.text = [NSString stringWithFormat:@"Col %ld", (unsigned long) columnIndex];
    return view;
}

- (NSString*)rowTableViewGetIndexText:(UIRowTableView*)rowTableView atRow:(NSInteger)rowIndex
{
    return [NSString stringWithFormat:@"%ld", (unsigned long) rowIndex];
}

- (void)rowTableView:(UIRowTableView *)rowTableView didSelectedRow:(NSUInteger)rowIndex
{
//    NSString *message = [NSString stringWithFormat:@"Click Row %d", rowIndex];
//    [[[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void)rowTableView:(UIRowTableView *)rowTableView didSelectedRow:(NSUInteger)rowIndex andColumn:(NSUInteger)columnIndex
{
//    NSString *message = [NSString stringWithFormat:@"Click Cell %d %d", rowIndex, columnIndex];
//    [[[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

@end