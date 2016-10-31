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
@property (nonatomic,strong)UIView *header;
@end
