//
//  CenterTableView.m
//  pro
//
//  Created by TuTu on 16/8/18.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "CenterTableView.h"
#import "UIImageView+WebCache.h"

@interface CenterTableView ()

@property (nonatomic,strong) UIView *backView ;
@property (nonatomic,strong) UIImageView *bgImgView ;
@property (nonatomic,strong) UIImageView *gradientImgView ;

@end

@implementation CenterTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUIs] ;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configureUIs] ;
    }
    return self;
}

- (void)configureUIs
{
    self.backgroundView = self.backView ;
    self.separatorStyle = 0 ;
    self.backgroundColor = [UIColor clearColor] ;
    [self setBgViewHidden:NO] ;
    [self addObserver:self
           forKeyPath:@"contentOffset"
              options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
              context:nil] ;
}

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"contentOffset"
                 context:nil] ;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"] && object == self) {
        NSLog(@"change %@",change) ;
        id old = change[NSKeyValueChangeOldKey] ;
        id new = change[NSKeyValueChangeNewKey] ;
        if (![old isKindOfClass:[NSNull class]] && old != new) {
            CGFloat contentOffsetY = self.contentOffset.y ;
            if (self.offsetYHasChangedValue) {
                self.offsetYHasChangedValue(contentOffsetY) ;
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context] ;
    }
}

- (UIView *)backView
{
    if (!_backView)
    {
        _backView = [[UIView alloc] initWithFrame:APPFRAME] ;
        _backView.backgroundColor = [UIColor xt_cellSeperate] ;
        [_backView addSubview:self.bgImgView] ;
        [self.bgImgView addSubview:self.gradientImgView] ;
        
        UIView *blackPartView = [[UIView alloc] init];
        blackPartView.backgroundColor = [UIColor blackColor] ;
        blackPartView.frame = CGRectMake(0, [[self class] getHeight], APP_WIDTH, 130) ;
        [_backView addSubview:blackPartView] ;
    }
    return _backView ;
}

- (UIImageView *)bgImgView
{
    if (!_bgImgView)
    {
        CGRect rect = CGRectZero ;
        rect.size.width = APP_WIDTH ;
        rect.size.height = [[self class] getHeight] ;

        _bgImgView = [[UIImageView alloc] initWithFrame:rect] ;
        _bgImgView.backgroundColor = [UIColor blackColor] ;
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill ;
        _bgImgView.layer.masksToBounds = YES ;
    }
    return _bgImgView ;
}

- (UIImageView *)gradientImgView
{
    if (!_gradientImgView)
    {
        _gradientImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradient_w2b"]] ;
        CGRect rect = CGRectZero ;
        rect.origin.y = [[self class] getHeight] - 100. ;
        rect.size.width = APP_WIDTH ;
        rect.size.height = 100. ;
        _gradientImgView.frame = rect ;
    }
    return _gradientImgView ;
}


#pragma mark - 

- (void)setBgViewHidden:(BOOL)hidden
{
    self.bgImgView.hidden = hidden ;
}

- (void)refreshImage:(NSString *)imgStr
{
    // sd web .
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:imgStr]] ;
}

- (void)clearImage
{
    self.bgImgView.image = nil ;
}


#pragma mark - public
+ (float)getHeight
{
    return 666. * APPFRAME.size.width / 750. ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
