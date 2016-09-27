//
//  TopLoopView.h
//  pro
//
//  Created by TuTu on 16/8/11.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopLoopViewDelegate <NSObject>

- (void)tapingCurrentIndex:(NSInteger)currentIndex ;

@end

@interface TopLoopView : UIView

- (void)setupWithKindID:(int)kindID
       changingDatalist:(NSArray *)datalist ;

@property (nonatomic,weak) id <TopLoopViewDelegate> delegate ;
@property (nonatomic) UIColor *color_pageControl ;
@property (nonatomic) UIColor *color_currentPageControl ;

- (instancetype)initWithFrame:(CGRect)frame
                      canLoop:(BOOL)canLoop
                     duration:(NSInteger)duration ;

- (void)startLoop ;
- (void)stopLoop ;

- (void)makeCenterImageHide:(BOOL)hidden ;
// 返回image或str . 待议
- (id)getCenterImageInfo ;

@end
