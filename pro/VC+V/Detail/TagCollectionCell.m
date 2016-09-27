//
//  TagCollectionCell.m
//  pro
//
//  Created by TuTu on 16/8/29.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "TagCollectionCell.h"
#import "Tag.h"

@interface TagCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelTag;

@end

@implementation TagCollectionCell

- (void)setATag:(Tag *)aTag
{
    _aTag = aTag ;
    
    self.labelTag.text = aTag.name ;
}

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    // Initialization code
    _labelTag.backgroundColor = [UIColor xt_mainColor] ;
    _labelTag.textColor = [UIColor whiteColor] ;
    _labelTag.layer.cornerRadius = 5. ;
    _labelTag.layer.masksToBounds = YES ;
}

@end
