//
//  IndexViewController.m
//  GroupBuying
//
//  Created by TuTu on 16/7/26.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "IndexViewController.h"
#import "XTMultipleTables.h"
#import "XTStretchSegment.h"
#import "CmsTableHandler.h"
#import "BannerCell.h"
#import "DetailCtrller.h"
#import "Kind.h"

#define TopRect             CGRectMake(0, 0, APPFRAME.size.width, 40)
#define MainRect            CGRectMake(0, 0, APPFRAME.size.width, APP_HEIGHT - 49.)
#define TopImageRect        CGRectMake(0, 0, APP_WIDTH, [BannerCell getHeight])
#define TopNavgationRect    CGRectMake(0, 0, APPFRAME.size.width, 40. + 20.)
#define TopAndNavRect       CGRectMake(0, 20, APPFRAME.size.width, 40. + 20.)
#define OverLength          ([BannerCell getHeight] - 40. - 20.)
static const float kCriticalPoint = 5. ;


@interface IndexViewController () <XTStretchSegmentDelegate, XTMultipleTablesDelegate, CmsTableHandlerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) NSArray          *kindList ;
@property (nonatomic,strong) XTStretchSegment *xtStretchSegment ;
@property (nonatomic,strong) XTMultipleTables *xtMultipleTables ;
@property (nonatomic,strong) UIImageView      *navBgImageView ;

@property (nonatomic)        BOOL             bNavbarBlackOrRed ;

@end



@implementation IndexViewController


#pragma mark - Life

- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    [super viewDidLoad] ;
    
    [self showTheScence] ;
}

- (void)showTheScence
{
    // 1. XTMultipleTables
    NSMutableArray *tableHandlersList = [@[] mutableCopy] ;
    for (Kind *akind in self.kindList) {
        CmsTableHandler *handler_Cms = [[CmsTableHandler alloc] initWithKind:akind] ;
        handler_Cms.handlerDelegate = self ;
        [tableHandlersList addObject:handler_Cms] ;
    }
    self.xtMultipleTables = [[XTMultipleTables alloc] initWithFrame:MainRect
                                                           handlers:tableHandlersList] ;
    self.xtMultipleTables.xtDelegate = self ;
    [self.view addSubview:self.xtMultipleTables] ;
    
    // 2. XTStretchSegment
    [self navBgImageView] ;
    [self xtStretchSegment] ;
    
    [self.view bringSubviewToFront:_navBgImageView] ;
    [self.view bringSubviewToFront:_xtStretchSegment] ;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    

    [[UIApplication sharedApplication] setStatusBarHidden:self.bNavbarBlackOrRed == false] ;
    [self.navigationController setNavigationBarHidden:YES] ;
    
    // 1. XTMultipleTables
    if (self.kindList.count <= 1)
    {
        self.kindList = nil ;
        [self kindList] ;
        
        if (self.kindList.count <= 1) return ;
        [self.xtMultipleTables removeFromSuperview] ;
        [self.xtStretchSegment removeFromSuperview] ;
        [self.navBgImageView removeFromSuperview] ;
        self.xtMultipleTables = nil ;
        self.xtStretchSegment = nil ;
        self.navBgImageView = nil ;
        
        [self showTheScence] ;
    }
}


#pragma mark - Prop

- (void)setBNavbarBlackOrRed:(BOOL)bNavbarBlackOrRed
{
    _bNavbarBlackOrRed = bNavbarBlackOrRed ;
    
    if (bNavbarBlackOrRed == true) {
        self.navBgImageView.image = [UIImage imageNamed:@"HomepageNavBar"] ;
    }
    else {
        self.navBgImageView.image = [UIImage imageNamed:@"gradient_b2w"] ;
    }
}


- (NSArray *)kindList
{
    if (!_kindList)
    {
        Kind *kindRecommend = [[Kind alloc] init] ;
        kindRecommend.kindId = 0 ;
        kindRecommend.name = @"推荐" ;
        
        NSMutableArray *list = [@[kindRecommend] mutableCopy] ;
        ResultParsered *result = [ServerRequest getAllKindList] ;
        if (result.errCode == 1001)
        {
            NSArray *kindlist = result.info[@"kindList"] ;
            for (NSDictionary *dicKind in kindlist) {
                Kind *akind = [Kind yy_modelWithDictionary:dicKind] ;
                [list addObject:akind] ;
            }
        }
        _kindList = list ;
    }
    return _kindList ;
}

- (XTStretchSegment *)xtStretchSegment
{
    if (!_xtStretchSegment && self.kindList.count > 0)
    {
        _xtStretchSegment = [[XTStretchSegment alloc] initWithFrame:TopRect
                                                           dataList:self.kindList
                                                       overlayImage:nil
                                                      hasSpliteLine:false
                                                               type:TypeZoomTitle] ;
        _xtStretchSegment.xtDelegate = self ;
        if (![_xtStretchSegment superview]) {
            [self.view addSubview:_xtStretchSegment] ;
        }
    }

    return _xtStretchSegment ;
}

- (UIImageView *)navBgImageView
{
    if (!_navBgImageView) {
        CGRect rect = self.xtStretchSegment.frame ;
        _navBgImageView = [[UIImageView alloc] initWithFrame:rect] ;
        _navBgImageView.image = [UIImage imageNamed:@"gradient_b2w"] ;
        if (!_navBgImageView.superview) {
            [self.view insertSubview:_navBgImageView belowSubview:self.xtStretchSegment] ;
        }
    }
    
    return _navBgImageView ;
}








#pragma mark - CmsTableHandlerDelegate
- (void)bannerSelected:(Content *)content
{
    [self jump2DetailVC:content] ;
}

- (void)didSelectRowWithContent:(Content *)content
{
    [self jump2DetailVC:content] ;
}

- (void)jump2DetailVC:(Content *)content
{
    DetailCtrller *detailVC = (DetailCtrller *)[[self class] getCtrllerFromStory:@"Index" controllerIdentifier:@"DetailCtrller"] ;
    detailVC.content = content ;
    [detailVC setHidesBottomBarWhenPushed:YES] ;
    [self.navigationController pushViewController:detailVC animated:YES] ;
}


// callback in did scroll and
- (void)tableDidScrollWithOffsetY:(float)offsetY
{
    [self makeNavBarDisplayWithOffsetY:offsetY] ;
}

// callback in will end dragging .
- (void)tablelWillEndDragWithOffsetY:(float)offsetY WithVelocity:(CGPoint)velocity
{
//    NSLog(@"offsetY : %lf",offsetY) ;
    [self makeNavigationbarDisplayWithOffsetY:offsetY Velocity:velocity] ;
}

- (void)handlerRefreshing:(id)handler
{
    float offsetY = ((CmsTableHandler *)handler).offsetY ;
    float overLength = OverLength ;
    
//    NSLog(@"offsetY : %lf",offsetY) ;
    if (offsetY > overLength) {
        [self makeNavigationbarDisplayWithOffsetY:offsetY Velocity:CGPointZero] ;
    }
    else {
        [self makeNavBarDisplayWithOffsetY:offsetY] ;
    }
}


#pragma mark - XTStretchSegmentDelegate
- (void)xtStretchSegmentMoveToTheIndex:(NSInteger)index
                              dataItem:(id)item
{
    NSLog(@"xtStretchSegmentMoveToTheIndex %@",@(index)) ;
    [self.xtMultipleTables xtMultipleTableMoveToTheIndex:(int)index] ;
}

#pragma mark - XTMultipleTablesDelegate
- (void)moveToIndexCallBack:(int)index
{
    NSLog(@"moveToIndexCallBack %@",@(index)) ;
    self.xtStretchSegment.currentIndex = index ;
    [self.xtMultipleTables pulldownCenterTableIfNeeded] ;
}








#pragma mark --
#pragma mark - func nav & seg
- (void)makeNavBarDisplayWithOffsetY:(float)offsetY
{
    float overLength = OverLength ;
    
    //1. 顶部 临界点15 .  控制nav和seg 显示
    if (offsetY <= kCriticalPoint)
    {
        // 隐藏nav 显示seg
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.xtStretchSegment.frame = TopRect ;
                             self.navBgImageView.frame = TopRect ;
                             self.bNavbarBlackOrRed = false ;
                         }] ;
        [[UIApplication sharedApplication] setStatusBarHidden:YES] ;
        
    }
    else if (offsetY > kCriticalPoint && offsetY <= overLength)
    {
        // 显示 全部 seg + nav
        if (self.bNavbarBlackOrRed == false) {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 self.xtStretchSegment.frame = TopAndNavRect ;
                                 self.navBgImageView.frame = TopNavgationRect ;
                                 self.bNavbarBlackOrRed = true ;
                             }] ;
            [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
        }
    }
    
}

- (void)makeNavigationbarDisplayWithOffsetY:(float)offsetY Velocity:(CGPoint)velocity
{
    float overLength = OverLength ;
    
    if (offsetY > overLength) {
        //  NSLog(@"vel y %@",NSStringFromCGPoint(velocity)) ;
        
        if (velocity.y < 0 && self.bNavbarBlackOrRed == false) {
            // 显示 全部 seg + nav
            [UIView animateWithDuration:0.5
                             animations:^{
                                 self.xtStretchSegment.frame = TopAndNavRect ;
                                 self.navBgImageView.frame = TopNavgationRect ;
                                 self.bNavbarBlackOrRed = true ;
                             }] ;
            [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
            
        }
        else if (velocity.y > 0 && self.bNavbarBlackOrRed == true) {
            // 隐藏全部
            [self hideAll] ;
        }
        else if (CGPointEqualToPoint(velocity, CGPointZero) && offsetY > overLength) {
            // 隐藏全部
            [self hideAll] ;
        }
    }
}

- (void)hideAll
{
    self.xtStretchSegment.transform = CGAffineTransformTranslate(self.xtStretchSegment.transform, 0, - self.xtStretchSegment.frame.size.height) ;
    self.navBgImageView.transform = CGAffineTransformTranslate(self.navBgImageView.transform, 0, - self.navBgImageView.frame.size.height) ;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.bNavbarBlackOrRed = false ;
                     }] ;
    [[UIApplication sharedApplication] setStatusBarHidden:YES] ;
}
















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
