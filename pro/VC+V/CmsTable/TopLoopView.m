//
//  TopLoopView.m
//  pro
//
//  Created by TuTu on 16/8/11.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "TopLoopView.h"
#import "HWWeakTimer.h"
#import "NSTimer+Addition.h"
#import "LoopInfoView.h"

static int IMAGEVIEW_COUNT = 3 ;

@interface TopLoopView () <UIScrollViewDelegate>
{
    UIScrollView            *_scrollView ;

    LoopInfoView            *_leftView ;
    LoopInfoView            *_centerView ;
    LoopInfoView            *_rightView ;
    
    BOOL                    _bLoop ;
    NSInteger               _durationOfScroll ;
    
    NSTimer                 *_timerLoop ;           // 控制循环
    NSTimer                 *_timerOverflow ;       // 控制手动后的等待时间
    BOOL                    bOpenTimer ;            // 开关
}
@property (nonatomic)         int           currentImageIndex ;
@property (nonatomic)         int           imageCount ;
@property (nonatomic,strong)  UIPageControl *pageControl ;
@property (nonatomic,strong)  NSArray       *datalist ;          //dataSource list , string .
@property (nonatomic)         int           kindID ;

@end

@implementation TopLoopView
@synthesize
color_currentPageControl = _color_currentPageControl ,
color_pageControl = _color_pageControl ;

#pragma mark - Public prop


- (void)setColor_pageControl:(UIColor *)color_pageControl
{
    _color_pageControl = color_pageControl ;
    
    self.pageControl.pageIndicatorTintColor = _color_pageControl ;
}

- (UIColor *)color_pageControl
{
    if (!_color_pageControl) {
        _color_pageControl = [UIColor grayColor] ;
    }
    return _color_pageControl ;
}

- (void)setColor_currentPageControl:(UIColor *)color_currentPageControl
{
    _color_currentPageControl = color_currentPageControl ;
    
    self.pageControl.currentPageIndicatorTintColor = _color_currentPageControl ;
}

- (UIColor *)color_currentPageControl
{
    if (!_color_currentPageControl) {
        _color_currentPageControl = [UIColor darkGrayColor] ;
    }
    return _color_currentPageControl ;
}

#pragma mark - private prop
- (void)setImageCount:(int)imageCount
{
    _imageCount = imageCount ;
    
    if (imageCount <= 1) {
        self.pageControl.hidden = YES ;
        _scrollView.scrollEnabled = NO ;
        return ;
    }
    _scrollView.scrollEnabled = YES ;
    self.pageControl.hidden = NO ;
    self.pageControl.numberOfPages = imageCount ;
    CGSize size = [self.pageControl sizeForNumberOfPages:imageCount] ;
    self.pageControl.bounds = CGRectMake(0, 0, size.width, size.height) ;
    self.pageControl.center = CGPointMake(APP_WIDTH - size.width , self.frame.size.height - 12.) ;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init] ;
        _pageControl.pageIndicatorTintColor = self.color_pageControl ;
        _pageControl.currentPageIndicatorTintColor = self.color_currentPageControl ;
        if (!_pageControl.superview) {
            [self addSubview:_pageControl];
        }
    }
    
    return _pageControl ;
}

#pragma - life

- (void)dealloc
{
    [_timerLoop invalidate] ;
    [_timerOverflow invalidate] ;
    
    _timerLoop = nil ;
    _timerOverflow = nil ;
    
    [self removeObserver:self
              forKeyPath:@"kindID"
                 context:&self->_kindID] ;
}


- (instancetype)initWithFrame:(CGRect)frame
                      canLoop:(BOOL)canLoop
                     duration:(NSInteger)duration
{
    self = [super init];
    if (self)
    {
        _kindID = - 1 ;
        // KVO
        [self addObserver:self
               forKeyPath:@"kindID"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:&self->_kindID] ;
        
        self.frame = frame ;
        _bLoop = canLoop ;
        _durationOfScroll = duration ;
        self.backgroundColor = [UIColor clearColor] ;
        [self setup] ;
        
        if (_bLoop) [self loopStart] ;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if (context == &self->_kindID)
    {
        assert([NSThread isMainThread]);
//        NSLog(@"chage : %@",change) ;
        
        id old = change[@"old"] ;
        id new = change[@"new"] ;
        if (![old isKindOfClass:[NSNull class]] && [old intValue] == [new intValue]) {
            return ;
        }
        
        [self refreshUIs] ;
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context] ;
    }
}


#pragma mark -

- (void)setupWithKindID:(int)kindID
       changingDatalist:(NSArray *)datalist
{
    self.datalist = datalist ;
    self.kindID = kindID ;
}

- (void)refreshUIs
{
    // do it in KVO. value changed .
    self.imageCount = (int)self.datalist.count ;
    [self setDefaultImage] ;
}

- (void)startLoop
{
    [self stopLoop] ;
    
    if (!_timerLoop.isValid || !_timerLoop) {
        [self loopStart] ;
    }
}

- (void)stopLoop
{
    _currentImageIndex = 0 ;
    [self setViewInDefault] ;
    
    [_timerLoop invalidate] ;
    _timerLoop = nil ;
    
    if ([_timerOverflow isValid]) [_timerOverflow invalidate] ;
}

- (void)makeCenterImageHide:(BOOL)hidden
{
//    self.backgroundColor = [UIColor clearColor] ;
    [_centerView makeImageHidden:hidden] ;
}

- (id)getCenterImageInfo
{
//    NSLog(@"%@",self.datalist) ;
    // 返回info
    return self.datalist.count == 0 ? nil : self.datalist[self.currentImageIndex] ;
}

#pragma mark -

- (void)setup
{
    //添加滚动控件
    [self addScrollView];
    //添加图片控件
    [self addImageViews];
}

- (void)loopStart
{
    if (_timerLoop == nil) {
        _timerLoop = [HWWeakTimer scheduledTimerWithTimeInterval:_durationOfScroll
                                                          target:self
                                                        selector:@selector(loopAction)
                                                        userInfo:nil
                                                         repeats:YES] ;
    }
}

- (void)loopAction
{
    if (_imageCount <= 1) return ;
    
    int leftImageIndex , rightImageIndex ;
    _currentImageIndex = (_currentImageIndex + 1) % _imageCount ;
    _centerView.info = _datalist[_currentImageIndex] ;
    
    leftImageIndex  = (_currentImageIndex + _imageCount - 1) % _imageCount ;
    rightImageIndex = (_currentImageIndex + 1) % _imageCount ;
    
    _leftView.info = _datalist[leftImageIndex] ;
    _rightView.info = _datalist[rightImageIndex] ;
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width , 0) animated:NO] ;
    
    CATransition *animation = [CATransition animation] ;
    [animation setDuration:0.3f] ;
    [animation setType:kCATransitionPush] ;
    [animation setSubtype:kCATransitionFromRight] ;
    [animation setFillMode:kCAFillModeForwards] ;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]] ;
    [_centerView.layer addAnimation:animation forKey:nil] ;
    
    _pageControl.currentPage = _currentImageIndex ;
}

#pragma mark 添加控件
- (void)addScrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init] ;
    }
    CGRect rect = CGRectZero ;
    rect.size = self.frame.size ;
    _scrollView.frame = rect ;
    _scrollView.bounces = false ;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(IMAGEVIEW_COUNT * _scrollView.frame.size.width, _scrollView.frame.size.height) ;
    //设置当前显示的位置为中间图片
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    
    if (![_scrollView superview]) {
        [self addSubview:_scrollView] ;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollView)] ;
    [_scrollView addGestureRecognizer:tapGesture] ;
}

- (void)tapScrollView
{
    NSLog(@"tap in xtloopscroll : %d",_currentImageIndex) ;
    [self.delegate tapingCurrentIndex:_currentImageIndex] ;
}

#pragma mark 添加图片三个控件
- (void)addImageViews
{
    _leftView = [[[NSBundle mainBundle] loadNibNamed:@"LoopInfoView" owner:self options:nil] lastObject] ;
    _leftView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) ;
//    _leftView = [[LoopInfoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] ;
    _leftView.contentMode = UIViewContentModeScaleAspectFill;
    _leftView.layer.masksToBounds = YES ;
    [_scrollView addSubview:_leftView] ;
    
    _centerView = [[[NSBundle mainBundle] loadNibNamed:@"LoopInfoView" owner:self options:nil] lastObject] ;
    _centerView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) ;
//    _centerView = [[LoopInfoView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)] ;
    _centerView.contentMode = UIViewContentModeScaleAspectFill;
    _centerView.layer.masksToBounds = YES ;
    [_scrollView addSubview:_centerView] ;
    
    _rightView = [[[NSBundle mainBundle] loadNibNamed:@"LoopInfoView" owner:self options:nil] lastObject] ;
    _rightView.frame = CGRectMake(2 * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) ;
//    _rightView = [[LoopInfoView alloc] initWithFrame:CGRectMake(2 * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)] ;
    _rightView.contentMode = UIViewContentModeScaleAspectFill;
    _rightView.layer.masksToBounds = YES ;
    [_scrollView addSubview:_rightView] ;
}

#pragma mark 设置默认显示图片
- (void)setDefaultImage
{
    if (!_datalist || !_datalist.count) {
        return ;
    }
    
    _centerView.info = _datalist[0] ;
    
    if (_imageCount > 1)
    {
        _leftView.info = _datalist[_imageCount - 1] ;
        _rightView.info = _datalist[1] ;
    }
    // current index
    _currentImageIndex = 0 ;
    _pageControl.currentPage = 0 ;
}

#pragma mark 滚动停止事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //重新加载图片
    [self reloadImage];
    //移动到中间
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0) ;
//    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
    //设置分页
    self.pageControl.currentPage = _currentImageIndex;
}

- (void)setViewInDefault
{
    //重新加载图片
    [self reloadImage];
    //移动到中间
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0) ;
//    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
    //设置分页
    self.pageControl.currentPage = _currentImageIndex;
}

#pragma mark 重新加载图片
- (void)reloadImage
{
    if (_imageCount == 0) {
        return ;
    }
    
    [self resumeTimerWithDelay] ;
    
    int leftImageIndex,rightImageIndex ;
    CGPoint offset = [_scrollView contentOffset] ;
    
    if (offset.x > self.frame.size.width)
    { //  向右滑动
        _currentImageIndex = (_currentImageIndex + 1) % _imageCount ;
    }
    else if(offset.x < self.frame.size.width)
    { //  向左滑动
        _currentImageIndex = (_currentImageIndex + _imageCount - 1) % _imageCount ;
    }

    _centerView.info = _datalist[_currentImageIndex] ;
    
    //  重新设置左右图片
    leftImageIndex  = (_currentImageIndex + _imageCount - 1) % _imageCount ;
    rightImageIndex = (_currentImageIndex + 1) % _imageCount ;
    
    _leftView.info = _datalist[leftImageIndex] ;
    _rightView.info = _datalist[rightImageIndex] ;
    
}

- (void)resumeTimerWithDelay
{
    [_timerLoop pause] ;
    
    if (!bOpenTimer)
    {
        if ([_timerOverflow isValid])
        {
            [_timerOverflow invalidate] ;
        }
        
        _timerOverflow = [HWWeakTimer scheduledTimerWithTimeInterval:_durationOfScroll
                                                              target:self
                                                            selector:@selector(timerIsOverflow)
                                                            userInfo:nil
                                                             repeats:NO] ;
    }
}

- (void)timerIsOverflow
{
    bOpenTimer = YES ;
    
    if (bOpenTimer)
    {
        [_timerLoop resume] ;
        bOpenTimer = NO ;
        
        [_timerOverflow invalidate] ;
        _timerOverflow = nil ;
    }
}





@end
