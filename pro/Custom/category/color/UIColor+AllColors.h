//
//  UIColor+AllColors.h
//  XtDemo
//
//  Created by teason on 16/3/21.
//  Copyright © 2016年 teason. All rights reserved.
//

/*
 * COLOR PUBLIC
 */
#define COLOR_MAIN              [UIColor colorWithRed:249.0/255.0 green:75.0/255.0  blue:95.0/255.0 alpha:1]

#define COLOR_BACKGROUND        [UIColor colorWithRed:248.0/255.0 green:248.0/255.0  blue:248.0/255.0 alpha:1]

#define COLOR_BG_POSTCELL       [UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0 alpha:1]

#define COLOR_BLACK_DARK        [UIColor colorWithRed:51.0/255.0 green:51.0/255.0  blue:51.0/255.0 alpha:1]

#define COLOR_GRAY_CONTENT      [UIColor colorWithRed:152.0/255.0 green:152.0/255.0  blue:152.0/255.0 alpha:1]

#define COLOR_HEADER_BACK       [UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0 alpha:1]

#define COLOR_TABLE_SEP         [UIColor colorWithWhite:0.8 alpha:0.6]

#define COLOR_INPUTBORDER       [UIColor colorWithRed:209.0/255.0 green:213.0/255.0  blue:213.0/255.0 alpha:1]

#define COLOR_ALERT_BACK        [UIColor colorWithWhite:0.3 alpha:.7]

#define COLOR_USERHEAD_BORDER   [UIColor colorWithRed:236.0/255.0 green:236.0/255.0  blue:236.0/255.0 alpha:1]

#define COLOR_RED_LINE_NAV      [UIColor colorWithRed:212.0/255.0 green:32.0/255.0  blue:53.0/255.0 alpha:1]



//Home Page
#define COLOR_HOME_CMT_NUMBER   [UIColor colorWithRed:212.0/255.0 green:32.0/255.0  blue:53.0/255.0 alpha:1]

#define COLOR_HOME_LIGHT_WORDS  [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]

//Su Experience
#define COLOR_SEMC_GREEN        [UIColor colorWithRed:147.0/255.0 green:221.0/255.0 blue:63.0/255.0 alpha:1]

#define COLOR_SEMC_RED          [UIColor colorWithRed:253.0/255.0 green:69.0/255.0 blue:59.0/255.0 alpha:1]

#define COLOR_BORDER_GRAY       [UIColor colorWithRed:209.0/255.0 green:209.0/255.0  blue:209.0/255.0 alpha:1]

//Image Editor
#define COLOR_IMG_EDITOR_BG     [UIColor colorWithRed:39.0/255.0 green:39.0/255.0  blue:41.0/255.0 alpha:1]

//Multi Cell Border
#define COLOR_MULTY_CELL_BORD   [UIColor colorWithRed:244.0/255.0 green:156.0/255.0  blue:166.0/255.0 alpha:1]

//note cell background
#define COLOR_NOTE_BACKGROUND   [UIColor colorWithRed:229.0/255.0 green:229.0/255.0  blue:229.0/255.0 alpha:1]

#define COLOR_GRAY_NOTE_WORD    [UIColor colorWithRed:101.0/255.0 green:101.0/255.0  blue:101.0/255.0 alpha:1]

#define COLOR_FLY_BACK          [UIColor colorWithWhite:0.9 alpha:.6]




#import <UIKit/UIKit.h>

@interface UIColor (AllColors)

+ (UIColor *)xt_mainColor ;
+ (UIColor *)xt_cellSeperate ;
+ (UIColor *)xt_w_cell_title ;
+ (UIColor *)xt_w_cell_desc ;
+ (UIColor *)xt_nav ;

+ (UIColor *)xt_fw_red ;
+ (UIColor *)xt_fw_yellow ;
+ (UIColor *)xt_fw_green ;
+ (UIColor *)xt_fw_blue ;
+ (UIColor *)xt_fw_purple ;

@end
