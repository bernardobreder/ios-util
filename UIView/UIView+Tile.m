//
//  UIView+Tile.m
//  iPhoneUtil
//
//  Created by Bernardo Breder on 27/07/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIView+Tile.h"

@implementation UIView (UIViewTile)

- (instancetype)initWithFrame:(CGRect)frame withColor:(UIColor*)color
{
    if (!(self = [self initWithFrame:frame])) return nil;
    self.backgroundColor = color;
    return self;
}

@end