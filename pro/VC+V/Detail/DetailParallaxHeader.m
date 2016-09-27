//
//  DetailParallaxHeader.m
//  pro
//
//  Created by TuTu on 16/8/26.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "DetailParallaxHeader.h"
#import "TagCollectionCell.h"
#import "Content.h"
#import "UIImageView+WebCache.h"
#import "Tag.h"

@interface DetailParallaxHeader () <UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DetailParallaxHeader

- (void)setAContent:(Content *)aContent
{
    _aContent = aContent ;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:aContent.cover]] ;
    [_collectionView reloadData] ;
}

- (void)awakeFromNib
{
    _collectionView.backgroundColor = [UIColor clearColor] ;
    [_collectionView registerNib:[UINib nibWithNibName:identifier_TagCollectionCell bundle:nil] forCellWithReuseIdentifier:identifier_TagCollectionCell] ;
    _collectionView.delegate = self ;
    _collectionView.dataSource = self ;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.aContent.tags.count ;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier_TagCollectionCell forIndexPath:indexPath] ;
    cell.aTag = (Tag *)(self.aContent.tags[indexPath.row]) ;
    return cell ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Tag *atag = (Tag *)(self.aContent.tags[indexPath.row]) ;
    UIFont *font = [UIFont systemFontOfSize:11.0f] ;
    CGSize size = CGSizeMake(APP_WIDTH, 25.) ;
    CGSize labelsize = [atag.name boundingRectWithSize:size
                                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName:font}
                                             context:nil].size ;
    labelsize.width += 10. ;
    
    return labelsize ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagSelected:)]) {
        Tag *atag = (Tag *)(self.aContent.tags[indexPath.row]) ;
        [self.delegate tagSelected:atag] ;
    }
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
