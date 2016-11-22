//
//  HomeNavViewController.h
//  Wemart
//
//  Created by 冯文秀 on 16/6/1.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMCustomNavController.h"

@interface WemartViewController : WMCustomNavController
@property (nonatomic, copy) NSString *appScheme;
@property (nonatomic, copy) NSString *wechatAppId;
@property (nonatomic, copy) NSString *shopUrl;
// 分享信息
@property (nonatomic, copy) NSString *topic;
@property (nonatomic, copy) NSString *describle;
@property (nonatomic, copy) NSString *thumbUrl;


// YES隐藏返回按钮  NO显示返回按钮
@property (nonatomic, assign) BOOL WMHidden;

@end
