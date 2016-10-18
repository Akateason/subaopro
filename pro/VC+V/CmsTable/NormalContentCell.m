//
//  NormalContentCell.m
//  pro
//
//  Created by TuTu on 16/8/8.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "NormalContentCell.h"
#import "Content.h"
#import "UIImageView+QNExtention.h"

@interface NormalContentCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgMain;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;

@property (weak, nonatomic) IBOutlet UIView *topline;
@property (weak, nonatomic) IBOutlet UIView *leftline;
@property (weak, nonatomic) IBOutlet UIView *rightline;
@property (weak, nonatomic) IBOutlet UIImageView *OnTopImage;

@end

@implementation NormalContentCell

- (void)setAContent:(Content *)aContent
{
    _aContent = aContent ;
    
    _titleLabel.text = aContent.title ;
    _kindLabel.text = aContent.kindName ;
    
    [_imgMain photoFromQiNiu:aContent.cover] ;    
    
    _readLabel.text = [NSString stringWithFormat:@"阅 %d",aContent.readNum] ;
    _OnTopImage.hidden = !aContent.isTop ;
}

+ (float)getHeight
{
    return APP_WIDTH * 280. / 750. ;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    _OnTopImage.hidden = YES ;
    _imgMain.layer.masksToBounds = YES ;
    _titleLabel.backgroundColor = [UIColor whiteColor] ;
    _titleLabel.textColor = [UIColor xt_w_cell_title] ;
    _kindLabel.backgroundColor = [UIColor clearColor] ;
    
    _kindLabel.textColor = [UIColor xt_w_cell_desc] ;
    _readLabel.textColor = [UIColor xt_w_cell_desc] ;
    
    _topline.backgroundColor = [UIColor xt_cellSeperate] ;
    _leftline.backgroundColor = [UIColor xt_cellSeperate] ;
    _rightline.backgroundColor = [UIColor xt_cellSeperate] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
