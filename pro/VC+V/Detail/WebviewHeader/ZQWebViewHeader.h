//
//  ZQWebViewHeader.h
//  ZQWebViewHeader
//
//  Created by zhang on 16/6/27.
//  Copyright © 2016年 zhangqq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Content ;

@protocol ZQWebViewHeaderDelegate <NSObject>

- (void)displayNavigationBar:(BOOL)bShow ;

@end

@interface ZQWebViewHeader : UIWebView

@property (nonatomic,strong) Content *content ;

@property (nonatomic,weak) id <ZQWebViewHeaderDelegate> xtDelegate ;

@property (strong, nonatomic) UIImageView *headerImageView;
//webview头
@property (nonatomic,strong)UIView *header;
//调整头区高度
- (void)setHeaderHight:(CGFloat)hight animate:(BOOL)animate;
@end
