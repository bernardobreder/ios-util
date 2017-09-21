//
//  UIColorRowTableView.m
//  iBandeiraBR
//
//  Created by Bernardo Breder on 29/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIColorRowTableView.h"

@interface UIColorRowTableView ()

@property (strong) UIView *cornerHeaderView;
@property (strong) NSMutableArray *rowViewArray;
@property (strong) NSMutableArray *colViewArray;
@property (strong) NSMutableArray *cellViewArray;
@property (assign) NSInteger rowCount;
@property (assign) NSInteger colCount;
@property (assign) NSInteger rowDragging, colDragging;

@end

@implementation UIColorRowTableView

@synthesize dataSource;
@synthesize rowWidth;
@synthesize rowHeight;
@synthesize columnWidth;
@synthesize columnHeight;
@synthesize insect;
@synthesize rowVisible;
@synthesize columnVisible;
@synthesize delegate;

@synthesize cornerHeaderView = _cornerHeaderView;
@synthesize rowCount = _rowCount;
@synthesize colCount = _colCount;
@synthesize rowViewArray = _rowViewArray;
@synthesize colViewArray = _colViewArray;
@synthesize cellViewArray = _cellViewArray;
@synthesize rowDragging = _rowDragging;
@synthesize colDragging = _colDragging;

- (id)init
{
    if (!(self = [super init])) return nil;
    rowWidth = 50;
    rowHeight = 50;
    columnWidth = 100;
    columnHeight = 50;
    insect = 1;
    rowVisible = true;
    columnVisible = true;
    _rowCount = -1;
    _colCount = -1;
    super.delegate = self;
    [self setShowsHorizontalScrollIndicator:false];
    [self setShowsVerticalScrollIndicator:false];
    return self;
}

- (CGRect)_rectForCorner
{
    CGFloat x = self.contentOffset.x;
    CGFloat y = self.contentOffset.y;
    return CGRectMake(x, y, rowWidth, columnHeight);
}

- (CGRect)_rectForRow:(NSInteger)index
{
    CGFloat x = self.contentOffset.x;
    CGFloat y = index * (rowHeight + insect);
    if (columnVisible) {
        y += (columnHeight + insect);
    }
    return CGRectMake(x, y, rowWidth, rowHeight);
}

- (CGRect)_rectForColumn:(NSInteger)index
{
    CGFloat x = index * (columnWidth + insect);
    CGFloat y = self.contentOffset.y;
    if (rowVisible) {
        x += (rowWidth + insect);
    }
    return CGRectMake(x, y, columnWidth, columnHeight);
}

- (CGRect)_rectForCell:(NSInteger)rowIndex column:(NSInteger)columnIndex
{
    CGFloat x = columnIndex * (columnWidth + insect);
    if (rowVisible) {
        x += (rowWidth + insect);
    }
    CGFloat y = rowIndex * (rowHeight + insect);
    if (columnVisible) {
        y += (columnHeight + insect);
    }
    return CGRectMake(x, y, columnWidth, rowHeight);
}

- (CGSize)_contentSize
{
    CGFloat w = (rowWidth + insect) + _colCount * (columnWidth + insect);
    CGFloat h = columnHeight + insect + _rowCount * (rowHeight + insect) - insect;
    return CGSizeMake(w, h);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_rowCount < 0) {
        _rowCount = dataSource ? [dataSource rowCount:self] : 0;
    }
    if (_colCount < 0) {
        _colCount = dataSource ? [dataSource columnCount:self] : 0;
    }
    if (!_rowViewArray) {
        _rowViewArray = [[NSMutableArray alloc] init];
        for (NSInteger n = 0 ; n < _rowCount ; n++) {
            [_rowViewArray addObject:[NSNull null]];
        }
    }
    if (!_colViewArray) {
        _colViewArray = [[NSMutableArray alloc] init];
        for (NSInteger n = 0 ; n < _colCount ; n++) {
            [_colViewArray addObject:[NSNull null]];
        }
    }
    if (!_cellViewArray) {
        _cellViewArray = [[NSMutableArray alloc] init];
        for (NSInteger n = 0 ; n < _rowCount * _colCount ; n++) {
            [_cellViewArray addObject:[NSNull null]];
        }
    }
    NSInteger minRow = MAX(0, floor(self.contentOffset.y / (rowHeight + insect)) - 1);
    NSInteger maxRow = MIN(_rowCount - 1, floor(((self.contentOffset.y + columnHeight + insect) + self.frame.size.height) / (rowHeight + insect)));
    NSInteger minCol = MAX(0, floor(self.contentOffset.x / (columnWidth + insect)) - 1);
    NSInteger maxCol = MIN(_colCount - 1, floor((self.contentOffset.x + rowWidth + insect + self.frame.size.width) / (columnWidth + insect)));
    {
        CGRect viewRect = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.frame.size.width, self.frame.size.height);
        //                NSLog(@"Cell Row[%d,%d] Col[%d,%d]", minRow, maxRow, minCol, maxCol);
        for (NSInteger r = minRow ; r <= maxRow ; r++) {
            for (NSInteger c = minCol ; c <= maxCol ; c++) {
                NSInteger index = r * _colCount + c;
                CGRect cellRect = [self _rectForCell:r column:c];
                if (CGRectIntersectsRect(viewRect, cellRect)) {
                    if (_cellViewArray[index] == [NSNull null]) {
                        UIView *cellView = (dataSource && [dataSource respondsToSelector:@selector(dataViewAt:atRow:atColumn:withSize:)]) ? ([dataSource dataViewAt:self atRow:r atColumn:c withSize:cellRect.size]) : ([[UIView alloc] init]);
                        cellView.frame = cellRect;
                        _cellViewArray[index] = cellView;
                        [self addSubview:cellView];
                    }
                } else {
                    if (_cellViewArray[index] != [NSNull null]) {
                        UIView *cellView = _cellViewArray[index];
                        [cellView removeFromSuperview];
                        _cellViewArray[index] = [NSNull null];
                        //                        NSLog(@"Remove [%d,%d]", r, c);
                    }
                }
            }
        }
    }
    if (rowVisible) {
        CGRect viewRect = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.frame.size.width, self.frame.size.height);
        for (NSInteger n = minRow ; n <= maxRow ; n++) {
            CGRect rowRect = [self _rectForRow:n];
            if (CGRectIntersectsRect(viewRect, rowRect)) {
                if (_rowViewArray[n] == [NSNull null]) {
                    UIView *rowView = (dataSource && [dataSource respondsToSelector:@selector(rowViewAt:atRow:withSize:)]) ? ([dataSource rowViewAt:self atRow:n withSize:rowRect.size]) : ([[UIView alloc] init]);
                    rowView.frame = rowRect;
                    _rowViewArray[n] = rowView;
                    [self addSubview:rowView];
                } else {
                    UIView *rowView = _rowViewArray[n];
                    rowView.frame = rowRect;
                    [self bringSubviewToFront:rowView];
                }
            } else {
                if (_rowViewArray[n] != [NSNull null]) {
                    UIView *rowView = _rowViewArray[n];
                    [rowView removeFromSuperview];
                    _rowViewArray[n] = [NSNull null];
                }
            }
        }
    }
    if (columnVisible) {
        CGRect viewRect = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.frame.size.width, self.frame.size.height);
        for (NSInteger n = minCol ; n <= maxCol ; n++) {
            CGRect colRect = [self _rectForColumn:n];
            if (CGRectIntersectsRect(viewRect, colRect)) {
                if (_colViewArray[n] == [NSNull null]) {
                    UIView *colView = (dataSource && [dataSource respondsToSelector:@selector(columnViewAt:atColumn:withSize:)]) ? ([dataSource columnViewAt:self atColumn:n withSize:colRect.size]) : ([[UIView alloc] init]);
                    colView.frame = colRect;
                    _colViewArray[n] = colView;
                    [self addSubview:colView];
                } else {
                    UIView *colView = _colViewArray[n];
                    colView.frame = colRect;
                    [self bringSubviewToFront:colView];
                }
            } else {
                if (_colViewArray[n] != [NSNull null]) {
                    UIView *colView = _colViewArray[n];
                    [colView removeFromSuperview];
                    _colViewArray[n] = [NSNull null];
                }
            }
        }
    }
    if (rowVisible && columnVisible) {
        CGRect cornerRect = [self _rectForCorner];
        if (!_cornerHeaderView) {
            _cornerHeaderView = (dataSource && [dataSource respondsToSelector:@selector(cornerViewAt:withSize:)]) ? ([dataSource cornerViewAt:self withSize:cornerRect.size]) : ([[UIView alloc] init]);
            [self addSubview:_cornerHeaderView];
        }
        _cornerHeaderView.frame = cornerRect;
        [self bringSubviewToFront:_cornerHeaderView];
    }
    self.contentSize = [self _contentSize];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSInteger minRow = MAX(0, floor(self.contentOffset.y / (rowHeight + insect)) - 1);
    NSInteger minCol = MAX(0, floor(self.contentOffset.x / (columnWidth + insect)) - 1);
    _rowDragging = minRow;
    _colDragging = minCol;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self _clearRecicle];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self _clearRecicle];
}

- (void)_clearRecicle
{
    NSNull *nullValue = [NSNull null];
    NSInteger minRow = MAX(0, floor(self.contentOffset.y / (rowHeight + insect)) - 1);
    NSInteger maxRow = MIN(_rowCount - 1, floor(((self.contentOffset.y + columnHeight + insect) + self.frame.size.height) / (rowHeight + insect)));
    NSInteger minCol = MAX(0, floor(self.contentOffset.x / (columnWidth + insect)) - 1);
    NSInteger maxCol = MIN(_colCount - 1, floor((self.contentOffset.x + rowWidth + insect + self.frame.size.width) / (columnWidth + insect)));
    for (NSInteger r = 0 ; r < _rowCount ; r++) {
        if (r < minRow || r > maxRow) {
            for (NSInteger c = 0 ; c < _colCount ; c++) {
                NSInteger index = r * _colCount + c;
                if (_cellViewArray[index] != nullValue) {
                    UIView *cellView = _cellViewArray[index];
                    [cellView removeFromSuperview];
                    _cellViewArray[index] = nullValue;
                    //                        NSLog(@"Remove [%d,%d]", r, c);
                }
            }
        } else {
            for (NSInteger c = 0 ; c < _colCount ; c++) {
                if (c < minCol || c > maxCol) {
                    NSInteger index = r * _colCount + c;
                    if (_cellViewArray[index] != nullValue) {
                        UIView *cellView = _cellViewArray[index];
                        [cellView removeFromSuperview];
                        _cellViewArray[index] = nullValue;
                        //                            NSLog(@"Remove [%d,%d]", r, c);
                    }
                }
            }
        }
    }
    if (rowVisible) {
        for (NSInteger n = 0 ; n < _rowCount ; n++) {
            if (n < minRow || n > maxRow) {
                if (_rowViewArray[n] != nullValue) {
                    UIView *rowView = _rowViewArray[n];
                    [rowView removeFromSuperview];
                    _rowViewArray[n] = nullValue;
                    //                        NSLog(@"Remove [%d,%d]", r, c);
                }
            }
        }
    }
    if (columnVisible) {
        for (NSInteger n = 0 ; n < _colCount ; n++) {
            if (n < minCol || n > maxCol) {
                if (_colViewArray[n] != nullValue) {
                    UIView *colView = _colViewArray[n];
                    [colView removeFromSuperview];
                    _colViewArray[n] = nullValue;
                    //                        NSLog(@"Remove [%d,%d]", r, c);
                }
            }
        }
    }
}

@end

@interface DemoColorRowTableViewDataSource ()

@property (nonatomic, strong) NSArray *rowArray;
@property (nonatomic, strong) NSArray *colArray;

@end

@implementation DemoColorRowTableViewDataSource

@synthesize rowArray;
@synthesize colArray;

- (id)init
{
    if (!(self = [super init])) return nil;
    rowArray = @[@"EA",@"ET",@"FI",@"Ps",@"Pd",@"Mv",@"Ex",@"Im",@"Fc",@"EM"];
    colArray = @[@"GLP ENERG", @"NAFTA", @"DIESEL"];
    return self;
}

- (NSInteger)rowCount:(UIColorRowTableView*)colorRowTableView
{
    return 1000;
}

- (NSInteger)columnCount:(UIColorRowTableView*)colorRowTableView
{
    return 2000;
}

- (UIView*)dataViewAt:(UIColorRowTableView*)colorRowTableView atRow:(NSInteger)rowIndex atColumn:(NSInteger)columnIndex withSize:(CGSize)size
{
    //    NSLog(@"Cell %d,%d", rowIndex, columnIndex);
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    return view;
}

- (UIView*)cornerViewAt:(UIColorRowTableView*)colorRowTableView withSize:(CGSize)size
{
    //    NSLog(@"Corner");
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    return view;
}

- (UIView*)rowViewAt:(UIColorRowTableView*)colorRowTableView atRow:(NSInteger)rowIndex withSize:(CGSize)size
{
    //    NSLog(@"row %d", rowIndex);
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"CourierNewPSMT" size:18];
    label.text = [NSString stringWithFormat:@"%@%ld", rowArray[rowIndex%rowArray.count], (long)rowIndex];
    return label;
}

- (UIView*)columnViewAt:(UIColorRowTableView*)colorRowTableView atColumn:(NSInteger)columnIndex withSize:(CGSize)size
{
    //    NSLog(@"Column %d", columnIndex);
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"CourierNewPSMT" size:12];
    label.text = [NSString stringWithFormat:@"%@%ld", colArray[columnIndex%colArray.count], (long)columnIndex];
    return label;
}

@end