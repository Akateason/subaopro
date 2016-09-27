//
//  TagCollectionCell.h
//  pro
//
//  Created by TuTu on 16/8/29.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Tag ;

static NSString *identifier_TagCollectionCell = @"TagCollectionCell" ;

@interface TagCollectionCell : UICollectionViewCell

@property (nonatomic,strong) Tag *aTag ;

@end
