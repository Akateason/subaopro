//
//  DetailParallaxHeader.h
//  pro
//
//  Created by TuTu on 16/8/26.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Content,Tag ;

@protocol DetailParallaxHeaderDelegate <NSObject>

- (void)tagSelected:(Tag *)atag ;

@end

@interface DetailParallaxHeader : UIView

@property (nonatomic,strong) Content *aContent ;
@property (weak,nonatomic) id <DetailParallaxHeaderDelegate> delegate ;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
