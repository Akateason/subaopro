//
//  PinkButton.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-27.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "PinkButton.h"

#define FONT_SIZE_PINKBUTTON    14.0f

@implementation PinkButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder] ;
    if (self)
    {
        [self setup] ;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup] ;
    }
    return self;
}

- (void)setup
{
//    self.backgroundColor = COLOR_MAIN ;
    self.layer.cornerRadius = CORNER_RADIUS_ALL ;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_PINKBUTTON] ;

}

@end
