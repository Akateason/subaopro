//
//  UserHeadCollectionCell.m
//  SuBaoJiang
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "UserHeadCollectionCell.h"
//#import "XTCornerView.h"
#import "ArticlePraise.h"
#import "UIImageView+WebCache.h"
#import "User.h"

@implementation UserHeadCollectionCell

- (void)awakeFromNib
{
    // Initialization code    
    _img_head.layer.cornerRadius = _img_head.frame.size.width / 2. ;
    _img_head.layer.masksToBounds = YES ;
//    [XTCornerView setRoundHeadPicWithView:_img_head] ;
    _img_head.layer.borderColor = COLOR_USERHEAD_BORDER.CGColor ;
    _img_head.layer.borderWidth = ONE_PIXEL_VALUE ;
}

- (void)dealloc
{
    self.praise = nil ;
}

#pragma mark --
#pragma mark - setter
- (void)setPraise:(ArticlePraise *)praise
{
    _praise = praise ;
    
    [_img_head sd_setImageWithURL:[NSURL URLWithString:_praise.user.u_headpic]
                 placeholderImage:IMG_HEAD_NO] ;
}

@end
