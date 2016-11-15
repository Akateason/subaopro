//
//  DetailCtrller.m
//  pro
//
//  Created by TuTu on 16/8/23.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "DetailCtrller.h"
#import "ShareUtils.h"
#import "Content.h"
#import "TagListCtrller.h"
#import "ShareAlertV.h"
#import "UIImage+AddFunction.h"
#import "UrlRequestHeader.h"
#import "TagCollectionCell.h"
#import "Tag.h"
#import "UIImageView+WebCache.h"
#import "ZQWebViewHeader.h"


@interface DetailCtrller () <UIScrollViewDelegate,UIWebViewDelegate,ShareAlertVDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ZQWebViewHeaderDelegate>

@property (nonatomic,strong) UIButton *backButton ;
@property (nonatomic,strong) UIButton *shareButton ;

@property (nonatomic,strong)ZQWebViewHeader *webView;

@property (nonatomic,strong) UIImageView *navImageView ;
@property (nonatomic,strong) UILabel     *titleLabel ;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation DetailCtrller

#pragma mark - ZQWebViewHeaderDelegate
- (void)displayNavigationBar:(BOOL)bShow
{
    if (bShow && self.navImageView.superview == nil) {
        
        self.navImageView.transform = CGAffineTransformTranslate(self.navImageView.transform, 0, -68) ;
        
        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionShowHideTransitionViews
                        animations:^{
                            self.navImageView.transform = CGAffineTransformIdentity ;
                            
                            [self.view addSubview:self.navImageView] ;
                        } completion:^(BOOL finished) {
                            
                        }] ;
        
        [self.view bringSubviewToFront:self.backButton] ;
        
        [UIView transitionWithView:self.backButton
                          duration:0.5
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            [self.backButton setImage:[UIImage imageNamed:@"CustomNavBack"] forState:0] ;
                        } completion:^(BOOL finished) {
                            
                        }] ;
        
    }
    else if (!bShow && self.navImageView.superview != nil) {
        
        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            self.navImageView.transform = CGAffineTransformTranslate(self.navImageView.transform, 0, -68) ;
                        } completion:^(BOOL finished) {
                            [self.navImageView removeFromSuperview] ;
                        }] ;
        
        [UIView transitionWithView:self.backButton
                          duration:0.5
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            [self.backButton setImage:[UIImage imageNamed:@"btback"] forState:0] ;
                        } completion:^(BOOL finished) {
                            
                        }] ;
        
    }
}

#pragma mark - DetailParallaxHeaderDelegate
- (void)tagSelected:(Tag *)atag
{
    [self performSegueWithIdentifier:@"detail2taglist" sender:atag] ; //  send tag .
}


#pragma mark - prop
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        float flex = 60. ;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(flex,
                                                                17,
                                                                APP_WIDTH - 2 * flex,
                                                                48)] ;
        _titleLabel.textColor = [UIColor whiteColor] ;
        _titleLabel.font = [UIFont systemFontOfSize:15.] ;
        _titleLabel.numberOfLines = 1 ;
        _titleLabel.text = self.content.title ;
        _titleLabel.textAlignment = NSTextAlignmentCenter ;
    }
    return _titleLabel ;
}

- (UIImageView *)navImageView
{
    if (!_navImageView) {
        _navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 68)] ;
        _navImageView.image = [UIImage imageNamed:@"HomepageNavBar"] ;
        [_navImageView addSubview:self.titleLabel] ;
    }
    return  _navImageView ;
}

- (void)setContent:(Content *)content
{
    _content = content ;
    
    [ServerRequest addReadWithContentID:content.contentId
                                success:nil
                                   fail:nil] ;
}

+ (CGSize)getHeaderSize
{
    return CGSizeMake(APP_WIDTH, APP_WIDTH * 3. / 4.) ;
}

static float kflex_backbutton = 30. ;
static float klength_backbutton = 44. ;

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init] ;
        CGRect rect = CGRectMake(10., 20., klength_backbutton, klength_backbutton) ;
        _backButton.frame = rect ;
        [_backButton setImage:[UIImage imageNamed:@"btback"] forState:0] ;
        [_backButton addTarget:self action:@selector(backButtonOnclick) forControlEvents:UIControlEventTouchUpInside] ;
    }
    return _backButton ;
}

- (void)backButtonOnclick
{
    [self.navigationController popViewControllerAnimated:YES] ;
//    [self dismissViewControllerAnimated:YES completion:^{
//    }] ;
}

- (UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init] ;
        CGRect rect = CGRectMake(APP_WIDTH - klength_backbutton - kflex_backbutton, APP_HEIGHT - klength_backbutton - kflex_backbutton, klength_backbutton, klength_backbutton) ;
        _shareButton.frame = rect ;
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"btshare"] forState:0] ;
        [_shareButton addTarget:self action:@selector(shareButtonOnClick) forControlEvents:UIControlEventTouchUpInside] ;
    }
    return _shareButton ;
}

- (void)shareButtonOnClick
{
    NSLog(@"分享") ;
    ShareAlertV *shareAlert = [[ShareAlertV alloc] initWithController:self] ;
    shareAlert.aDelegate = self ;
}

#pragma mark - func
- (UIImage *)thumbnail
{
    UIImage *originalImg = self.webView.headerImageView.image ;
    UIImage *thumbnail = [UIImage thumbnailWithImage:originalImg size:CGSizeMake(80, 80)] ;
    return thumbnail ;
}


#pragma mark - ShareAlertVDelegate
- (void)clickIndex:(NSInteger)index
{
    // share call back
    switch (index)
    {
        case 0:
        {
            //@"新浪微博" ;
            [ShareUtils wb_sendTitleAndUrl:self.content.link
                                thumbImage:[self thumbnail]] ;
        }
            break;
        case 1:
        {
            //@"微信" ;
            [ShareUtils wx_sendLinkURL:self.content.link
                               TagName:nil
                                 Title:self.content.title
                           Description:nil
                            ThumbImage:[self thumbnail]
                               InScene:WXSceneSession] ;
        }
            break;
        case 2:
        {
            //@"朋友圈" ;
            [ShareUtils wx_sendLinkURL:self.content.link
                               TagName:nil
                                 Title:self.content.title
                           Description:nil
                            ThumbImage:[self thumbnail]
                               InScene:WXSceneTimeline] ;

        }
            break;
        default:
            break;
    }
}


#define kHeaderHeight           (float)(APP_WIDTH * 3.0 / 4.0)

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView = [[ZQWebViewHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width ,self.view.frame.size.height)];
    _webView.xtDelegate = self ;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.content getFinalLink]]]];

    [self.view addSubview:self.backButton] ;
    [self.view addSubview:self.shareButton] ;
    
    // collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init] ;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal ;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, kHeaderHeight - 38, APP_WIDTH - 16, 30) collectionViewLayout:flowLayout] ;
    self.collectionView.backgroundColor = [UIColor clearColor] ;
    [self.webView.scrollView addSubview:self.collectionView] ;
    self.collectionView.delegate = self ;
    self.collectionView.dataSource = self ;
    [self.collectionView registerNib:[UINib nibWithNibName:identifier_TagCollectionCell bundle:nil] forCellWithReuseIdentifier:identifier_TagCollectionCell] ;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;

    self.webView.content = self.content ;
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.content.tags.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier_TagCollectionCell forIndexPath:indexPath] ;
    cell.aTag = (Tag *)(self.content.tags[indexPath.row]) ;
    return cell ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Tag *atag = (Tag *)(self.content.tags[indexPath.row]) ;
    UIFont *font = [UIFont systemFontOfSize:11.0f] ;
    CGSize size = CGSizeMake(APP_WIDTH, 30.) ;
    CGSize resultSize = [atag.name boundingRectWithSize:size
                                                options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName:font}
                                                context:nil].size ;
    resultSize.width += 10. ;
    resultSize.height = 30. ;
    return resultSize ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Tag *atag = (Tag *)(self.content.tags[indexPath.row]) ;
    [self tagSelected:atag] ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detail2taglist"]) {
        TagListCtrller *tagListCtrller = [segue destinationViewController] ;
        tagListCtrller.atag = sender ;
    }
}


@end
