//
//  UIColor+AllColors.m
//  XtDemo
//
//  Created by teason on 16/3/21.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "UIColor+AllColors.h"
#import "XTColorFetcher.h"

@implementation UIColor (AllColors)

+ (UIColor *)xt_mainColor
{
    return [[XTColorFetcher class] xt_colorWithKey:@"main"] ;
}

+ (UIColor *)xt_cellSeperate
{
    return [[XTColorFetcher class] xt_colorWithKey:@"cellSeperate"] ;
}

+ (UIColor *)xt_w_cell_title
{
    return [[XTColorFetcher class] xt_colorWithKey:@"w_cell_title"] ;
}

+ (UIColor *)xt_w_cell_desc
{
    return [[XTColorFetcher class] xt_colorWithKey:@"w_cell_desc"] ;
}

+ (UIColor *)xt_nav
{
    return [[XTColorFetcher class] xt_colorWithKey:@"nav"] ;
}

+ (UIColor *)xt_fw_red
{
    return [[XTColorFetcher class] xt_colorWithKey:@"fw_red"] ;
}

+ (UIColor *)xt_fw_yellow
{
    return [[XTColorFetcher class] xt_colorWithKey:@"fw_yellow"] ;
}

+ (UIColor *)xt_fw_green
{
    return [[XTColorFetcher class] xt_colorWithKey:@"fw_green"] ;
}

+ (UIColor *)xt_fw_blue
{
    return [[XTColorFetcher class] xt_colorWithKey:@"fw_blue"] ;
}

+ (UIColor *)xt_fw_purple
{
    return [[XTColorFetcher class] xt_colorWithKey:@"fw_purple"] ;
}


@end
