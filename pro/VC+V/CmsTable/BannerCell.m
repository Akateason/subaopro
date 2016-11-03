//
//  BannerCell.m
//  pro
//
//  Created by TuTu on 16/8/12.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "BannerCell.h"
#import "CenterTableView.h"
#import "Content.h"

@interface BannerCell () <TopLoopViewDelegate>


@end

#define kDefaultHeaderFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

@implementation BannerCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ;
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        self.frame = CGRectMake(0, 0, APP_WIDTH, [[self class] getHeight]) ;
        [self addSubview:self.loopScroll] ;
        self.backgroundColor = [UIColor clearColor] ;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


#pragma mark - TopLoopViewDelegate
- (void)tapingCurrentIndex:(NSInteger)currentIndex
{
    NSLog(@"TopLoopViewDelegate tapingCurrentIndex : %@", @(currentIndex)) ;
    Content *content = (Content *)[self.loopScroll getCenterImageInfo] ;
    [self.delegate selectContentInBanner:content] ;
}

#pragma mark - prop
- (TopLoopView *)loopScroll
{
    if (!_loopScroll) {
        CGRect rect = CGRectZero ;
        rect.size.width = APP_WIDTH ;
        rect.size.height = [[self class] getHeight] ;
        
        _loopScroll = [[TopLoopView alloc] initWithFrame:rect
                                                 canLoop:YES
                                                duration:8.0] ;
        
        _loopScroll.delegate = self ;
        _loopScroll.color_pageControl        = [UIColor lightGrayColor] ;
        _loopScroll.color_currentPageControl = [UIColor xt_mainColor] ;
    }
    return _loopScroll ;
}

- (void)setupLoopInfo:(NSArray *)loopInfoList kindID:(int)kindId
{
    [self.loopScroll setupWithKindID:kindId changingDatalist:loopInfoList] ;
}

- (void)showCenterLoopImageHide:(BOOL)hidden
{
    [self.loopScroll makeCenterImageHide:hidden] ;
}

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset scrollView:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[CenterTableView class]]) return ;

    NSLog(@"offset.y : %@",@(offset.y)) ;
    if (offset.y >= 0)
    {
        // 上拉 , 显示loop中间的图片
        CenterTableView *table = (CenterTableView *)scrollView ;
        if (![table.mj_header isRefreshing]) {
            [self.loopScroll makeCenterImageHide:FALSE] ;
        }
    }
    else
    {
        //2 隐藏, loop中间的图片 .
        [self.loopScroll makeCenterImageHide:TRUE] ;
    }
}

- (NSString *)fetchCenterImageStr
{
    // 获取, 中间的图片
    Content *content = (Content *)[self.loopScroll getCenterImageInfo] ;
    return content.cover ;
}

- (void)start
{
    [self.loopScroll startLoop] ;
}

- (void)stop
{
    [self.loopScroll stopLoop] ;
}

+ (float)getHeight
{
    return 666. * APPFRAME.size.width / 750. ;
}


@end
