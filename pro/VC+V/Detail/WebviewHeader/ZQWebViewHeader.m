//
//  ZQWebViewHeader.m
//  ZQWebViewHeader
//
//  Created by zhang on 16/6/27.
//  Copyright © 2016年 zhangqq.com. All rights reserved.
//

#import "ZQWebViewHeader.h"
#import "UIImageView+WebCache.h"
#import "UIImage+AddFunction.h"
#import "Content.h"

#define kHeaderHeight           (float)(APP_WIDTH * 3.0 / 4.0)


CG_INLINE CGRect
CGRectSetX(CGRect rect, CGFloat x)
{
    rect.origin.x = x;
    return rect;
}

CG_INLINE CGRect
CGRectSetY(CGRect rect, CGFloat y)
{
    rect.origin.y = y;
    return rect;
}

CG_INLINE CGRect
CGRectSetH(CGRect rect, CGFloat h)
{
    rect.size.height = h;
    return  rect;
}

@interface ZQWebViewHeader()

@property (nonatomic,strong)UIView *zqBrowserView;
@property (nonatomic, strong) NSMutableArray *blurImages;

@end

@implementation ZQWebViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _zqBrowserView = [self.scrollView.subviews lastObject];
        self.header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, (float)(APP_WIDTH * 3.0 / 4.0))];
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)setContent:(Content *)content
{
    _content = content ;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.content.cover]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         self.blurImages = [[NSMutableArray alloc] init] ;
         [self prepareForBlurImages] ;
     }] ;

}


//set header
- (void)setHeader:(UIView *)header
{
    if (_header) {
        [_header removeFromSuperview];
        _header = nil;
    }
    _header = header;
    [self.scrollView addSubview:header];
    _zqBrowserView.frame = CGRectSetY(_zqBrowserView.frame, CGRectGetMaxY(header.frame));

    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, (float)(APP_WIDTH * 3.0 / 4.0))] ;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_header addSubview:self.headerImageView] ;
    _header.clipsToBounds = YES;

}

- (void)setHeaderHight:(CGFloat)hight animate:(BOOL)animate {
    
    [UIView animateWithDuration:animate ? 0.3 : 0
                     animations:^{
        _header.frame = CGRectSetH(_header.frame, hight);
        _zqBrowserView.frame = CGRectSetY(_zqBrowserView.frame, hight);
    } completion:^(BOOL finished) {
//        [self reloadFooterFrame];
    }];
}


- (void)prepareForBlurImages
{
    [self.blurImages addObject:self.headerImageView.image];
    [self.blurImages addObject:[self.headerImageView.image boxblurImageWithBlur:0.5]];
}


- (void) blurWithOffset:(float)offset
{
    NSInteger index = offset / 10;
    if (index < 0) {
        index = 0;
    }
    else if(index >= self.blurImages.count) {
        index = self.blurImages.count - 1;
    }
    UIImage *image = self.blurImages[index];
    if (self.headerImageView.image != image) {
        [self.headerImageView setImage:image];
    }
}



- (void) dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}


//UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    [self animationForScroll:offset];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat offset = self.scrollView.contentOffset.y;
    [self animationForScroll:offset];
}


- (void)animationForScroll:(CGFloat) offset
{
    NSLog(@"offsety %@",@(offset)) ;
    
    CATransform3D headerTransform = CATransform3DIdentity;
    // DOWN -----------------
    if (offset < 0) {
        CGFloat headerScaleFactor = -(offset) / self.header.bounds.size.height;
        CGFloat headerSizevariation = ((self.header.bounds.size.height * (1.0 + headerScaleFactor)) - self.header.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, -headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        self.header.layer.transform = headerTransform;
    }
    // SCROLL UP/DOWN ------------
    else {
        if (offset > (kHeaderHeight - 68.)) {
            [self.xtDelegate displayNavigationBar:YES] ;
        }
        else {
            [self.xtDelegate displayNavigationBar:NO] ;
        }
    }
    if (self.headerImageView.image != nil) {
        [self blurWithOffset:offset];
    }

}

@end

