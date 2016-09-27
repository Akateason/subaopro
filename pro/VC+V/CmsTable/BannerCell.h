//
//  BannerCell.h
//  pro
//
//  Created by TuTu on 16/8/12.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *identifier_bannercell = @"BannerCell" ;

@class Content ;

@protocol BannerCellDelegate <NSObject>

- (void)selectContentInBanner:(Content *)content ;

@end


@interface BannerCell : UITableViewCell

@property (weak,nonatomic) id <BannerCellDelegate> delegate ;
// prop .
- (void)setupLoopInfo:(NSArray *)loopInfoList kindID:(int)kindId ;
+ (float)getHeight ;

// in scroll view did scroll delegate .
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
                                 scrollView:(UIScrollView *)scrollView ;
// img in center .
- (NSString *)fetchCenterImageStr ;

// show center image .
- (void)showCenterLoopImageHide:(BOOL)hidden ;

// start and stop the loop .
- (void)start ;
- (void)stop ;

@end
