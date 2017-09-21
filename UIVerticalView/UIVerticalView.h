//
//  UIVerticalView.h
//  iBandeiraSimple
//
//  Created by Bernardo Breder on 11/09/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIVerticalView;

@protocol UIVerticalViewDataSource <NSObject>

@required

- (NSUInteger)verticalViewGetCellCount:(UIVerticalView*)verticalView;

- (UIView*)verticalView:(UIVerticalView*)verticalView getViewAt:(NSUInteger)index withFrame:(CGRect)frame;

- (NSUInteger)verticalView:(UIVerticalView*)verticalView getHeight:(NSUInteger)index;

@end

@interface UIVerticalView : UIScrollView

@property (nonatomic, weak) id<UIVerticalViewDataSource> dataSource;

@property (nonatomic, assign) NSUInteger gapHeight;

- (void)didReceiveMemoryWarning;

@end

@interface UIVerticalViewController : UIViewController <UIVerticalViewDataSource>

@end
