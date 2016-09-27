//
//  XTStretchSegment.m
//  XTMultipleTables
//
//  Created by TuTu on 15/12/11.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "XTStretchSegment.h"
#import "Kind.h"

static const float kWordsHeadNailFlexLength = 10.0f ;
static const int   kTopButtonTagBasic = 5438 ;
static const float kTopButtonFontSize = 18.0 ;
static const float kOverlayAnimationDuration = 0.25f ;
static const float kFlexOfTopButtonFontSize = 5.f ;

#define ZoomType_DefaultColor   [UIColor colorWithWhite:.92 alpha:1]
#define ZoomType_SelectedColor  [UIColor whiteColor]

@interface XTStretchSegment ()
{
    CGRect  m_overlayFrame ;
    bool    m_hasSplitLine ;
}
@property (nonatomic,strong) UIImageView *overlayView ;
@property (nonatomic) DisplayType_XTStretchSegment type ;
//@property (nonatomic,strong) UIImageView *bgcImgView ;

@end

@implementation XTStretchSegment

#pragma mark - Initial
- (instancetype)initWithFrame:(CGRect)frame
                     dataList:(NSArray *)dataList
{
    return [self initWithFrame:frame
                      dataList:dataList
                  overlayImage:[UIImage imageNamed:@"btBase"]
                 hasSpliteLine:false
                          type:0] ;
}

- (instancetype)initWithFrame:(CGRect)frame
                     dataList:(NSArray *)dataList
                 overlayImage:(UIImage *)imgOverlay
                hasSpliteLine:(bool)hasSplite
                         type:(DisplayType_XTStretchSegment)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataList = dataList ;
        m_hasSplitLine = hasSplite ;
        self.type = type ;
        self.overlayView.image = type == TypeBaseLine ? imgOverlay : nil ;
        [self setup] ;
    }
    return self;
}

- (CGSize)topButtonMaxSize { return CGSizeMake(1000, self.frame.size.height) ; }

- (CGFloat)getButtonWidth:(NSString *)nameBt
{
    CGFloat wid = [nameBt boundingRectWithSize:[self topButtonMaxSize]
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTopButtonFontSize]}
                                       context:nil].size.width ;
    wid += (kWordsHeadNailFlexLength * 2) ;
    return wid ;
}

- (CGRect)getRectFromWhichButton:(int)index
{
    __block float sumOfPreLength = 0.0 ;
    [self.dataNameList enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        
        sumOfPreLength += [self getButtonWidth:name] ;
        
        if (idx == index - 1) {
            *stop = YES ;
        }
    }] ;
    
    sumOfPreLength = (!index) ? 0 : sumOfPreLength ;
    
    return CGRectMake(sumOfPreLength ,
                      0,
                      [self getButtonWidth:self.dataNameList[index]],
                      self.frame.size.height) ;
}

- (void)drawBaseSpliteLine:(float)length
{
    UIView *baseline = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                self.frame.size.height - 1,
                                                                length,
                                                                1)] ;
    baseline.backgroundColor = [UIColor blackColor] ;
    [self addSubview:baseline] ;
}

#pragma mark - Property
- (void)setDataList:(NSArray *)dataList
{
    _dataList = dataList ;
    
    NSMutableArray *templist = [[NSMutableArray alloc] init] ;
    [dataList enumerateObjectsUsingBlock:^(Kind *akind, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        NSString *name = [[obj allKeys] firstObject] ;
        NSString *name = akind.name ;
        
        [templist addObject:name] ;
        if (idx == dataList.count - 1) {
            self.dataNameList = templist ;
            *stop = YES ;
        }
    }] ;
}

- (void)setDataNameList:(NSArray *)dataNameList
{
    _dataNameList = dataNameList ;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex ;
    
    if (self.type == TypeBaseLine) {
        [self movingOverlay] ;
    }
    else if (self.type == TypeZoomTitle) {
        [self zoomingTitle] ;
    }
    
}

- (UIImageView *)overlayView
{
    if (!_overlayView) {
        _overlayView = [[UIImageView alloc] init] ;
        if (![_overlayView superview]) {
            [self addSubview:_overlayView] ;
        }
    }
    
    return _overlayView ;
}


#pragma mark - Setup
- (void)setup
{
    
    [self setupButtonsAndSpilteLine] ;
    [self setupDefaultOverlay] ;
//    [self bgcImgView] ;
    
    self.currentIndex = 0 ;
    self.showsHorizontalScrollIndicator = NO ;
    self.backgroundColor = [UIColor clearColor] ;
//    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2] ;
}

- (void)setupButtonsAndSpilteLine
{
    __block CGFloat sumOflatestButtonsWidth = 0.0 ;
    
    [_dataNameList enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *bt = [[UIButton alloc] init] ;
        [bt setTitle:name forState:0] ;
        
        if (self.type == TypeBaseLine) {
            bt.titleLabel.font = [UIFont systemFontOfSize:kTopButtonFontSize] ;
            [bt setTitleColor:[UIColor whiteColor] forState:0] ;
        }
        else if (self.type == TypeZoomTitle) {
            bt.titleLabel.font = [UIFont systemFontOfSize:kTopButtonFontSize - kFlexOfTopButtonFontSize] ;
            [bt setTitleColor:ZoomType_DefaultColor forState:0] ;
        }
        
        bt.tag = kTopButtonTagBasic + idx ;
        [bt addTarget:self action:@selector(clickOnWhichButton:) forControlEvents:UIControlEventTouchUpInside] ;
        CGRect btFrame = CGRectZero ;
        btFrame.origin.x = sumOflatestButtonsWidth ;
        btFrame.size.width = [self getButtonWidth:name] ;
        btFrame.size.height = self.frame.size.height ;
        bt.frame = btFrame ;
        [self addSubview:bt] ;
        sumOflatestButtonsWidth += btFrame.size.width ;
        if (_dataNameList.count - 1 == idx) {
            self.contentSize = CGSizeMake(sumOflatestButtonsWidth, self.frame.size.height) ;
            if (m_hasSplitLine) {
                [self drawBaseSpliteLine:sumOflatestButtonsWidth] ;
            }
            *stop = YES ;
        }
    }] ;
}

- (void)setupDefaultOverlay
{
    m_overlayFrame = [self getRectFromWhichButton:0] ;
}

- (void)clickOnWhichButton:(UIButton *)button
{
//    NSLog(@"tag : %ld is selected",(long)button.tag) ;
    int selectedIndex = (int)button.tag - kTopButtonTagBasic ;
    NSLog(@"selectedIndex : %d",selectedIndex) ;
    if (_currentIndex == selectedIndex) return ;
    
    self.currentIndex = selectedIndex ;
    [self.xtDelegate xtStretchSegmentMoveToTheIndex:selectedIndex
                                           dataItem:_dataList[selectedIndex]] ;
}

- (void)movingOverlay
{
    CGRect rectShouldMove = [self getRectFromWhichButton:(int)_currentIndex] ;
    if (CGRectEqualToRect(rectShouldMove, self.overlayView.frame)) return ;
    
    [UIView animateWithDuration:kOverlayAnimationDuration
                     animations:^{
                         self.overlayView.frame = rectShouldMove ;
                         [self scrollRectToVisible:self.overlayView.frame animated:YES] ;
                     }
                     completion:nil] ;
}


- (void)zoomingTitle
{
    [UIView animateWithDuration:kOverlayAnimationDuration
                     animations:^{
                         [self resetButtonSizeAndColor] ;
                     }] ;
    
    [self movingOverlay] ;
}

- (void)resetButtonSizeAndColor
{
    for (UIView *sub in self.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)sub ;
            if (button.tag == kTopButtonTagBasic + _currentIndex) {
                button.titleLabel.font = [UIFont systemFontOfSize:kTopButtonFontSize] ;
                [button setTitleColor:ZoomType_SelectedColor forState:0] ;
            }
            else {
                button.titleLabel.font = [UIFont systemFontOfSize:kTopButtonFontSize - kFlexOfTopButtonFontSize] ;
                [button setTitleColor:ZoomType_DefaultColor forState:0] ;
            }
        }
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
