//
//  WMCustomNavController.h
//  Wemart
//
//  Created by 冯文秀 on 16/6/2.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMCustomNavController : UIViewController
@property (strong, nonatomic) UIView *navigationView;
@property (strong, nonatomic) UIControl *navigationTitleView;
@property (strong, nonatomic) UILabel *navigationTitle;
@property (copy, nonatomic) NSString *navigationTitleText;
@property (strong, nonatomic) UIButton *navigationLeftButton;
@property (strong, nonatomic) UIButton *navigationRightButton;
@property (copy, nonatomic) NSArray<UIButton *> *navigationLeftButtons;
@property (copy, nonatomic) NSArray<UIButton *> *navigationRightButtons;
@property (nonatomic, strong) NSDictionary *headerDic;
@property (nonatomic, strong) UIColor *headTextColor;
@property (nonatomic, assign) CGFloat navRatio;
@property (nonatomic, assign) BOOL hidStatus;

- (void)WMhideStatusBar;

@end
