//
//  SinglePicCollectCell.m
//  pro
//
//  Created by TuTu on 16/8/17.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "SinglePicCollectCell.h"
#import "UIImageView+WebCache.h"
#import "Images.h"

@interface SinglePicCollectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SinglePicCollectCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    _imageView.layer.masksToBounds = YES ;
}

- (void)setImages:(Images *)images
{
    _images = images ;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:images.img]] ;

}

@end
