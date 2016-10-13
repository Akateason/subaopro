//
//  UserCenterController.m
//  SuBaoJiang
//
//  Created by apple on 15/6/9.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "UserCenterController.h"
#import "User.h"
#import "Article.h"
#import "MyPraisedCell.h"
#import "ArticlePraise.h"
#import "MySubaoCell.h"
#import "ArticleComment.h"
#import "MyCommentsCell.h"
#import "DetailSubaoCtrller+TaskModuleTransition.h"
#import "CommonFunc.h"
#import "XTSegment.h"
#import "XHPathCover.h"
#import "UIImageView+WebCache.h"
#import "UIImage+AddFunction.h"
#import "NotificationCenterHeader.h"
#import "PublicEnum.h"
#import "ResultSBJ.h"

#define SIZE_OF_PAGE    10
#define KVO_THE_USER    @"KVO_THE_USER"



@interface UserCenterController () <XTSegmentDelegate,MyCellDelegate>
{
    BOOL                _reloadingHead      ;

    BOOL                _reloadingFoot      ;

    BOOL                isOther ;
    
    //我的速报
    int                 m_lastSubaoID ;
    NSMutableArray      *m_subaoList ;
    
    UIButton            *m_btSetting ;
}

@property (weak, nonatomic) IBOutlet RootTableView *table;
@property (nonatomic,strong) XHPathCover *pathCover;

@property (nonatomic,strong) XTSegment  *segment ;
@property (nonatomic,strong) NSArray    *segList ;

@property (nonatomic,strong) User       *theUser ; // 设置为看别人, 不设置为自己
@end


@implementation UserCenterController

#pragma mark -- public
+ (void)jump2UserCenterCtrller:(UIViewController *)ctrller
                     AndUserID:(int)uid
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Find" bundle:nil] ;
    UserCenterController *userCtrller = [story instantiateViewControllerWithIdentifier:@"UserCenterController"] ;
    
    userCtrller.userID = uid ;
    userCtrller.noBottom = YES ;
    [userCtrller setHidesBottomBarWhenPushed:YES] ;
    [ctrller.navigationController pushViewController:userCtrller animated:YES] ;
}

#pragma mark -- initialization
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
       
    }
    
    return self ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

// notification
- (void)userHasChanged
{
    //我的速报
    @synchronized(m_subaoList)
    {
        m_lastSubaoID = 0 ;
        [m_subaoList removeAllObjects] ;
    }
    
    
    [self _refreshing] ;
}

- (void)uploadFinished
{
    [self _refreshing] ;
}

- (void)refreshTable
{
    [self _refreshing] ;
}

#pragma mark - Properties
- (void)setUserID:(int)userID
{
    _userID = userID ;
    
    isOther = YES ;
    if (isOther) _segment = nil ;
}

- (User *)theUser
{
    
    return _theUser ;
}

- (NSArray *)segList
{
    _segList = @[@"速报"] ;

    return _segList ;
}

#define MENU_HEIGHT 44.0

- (XTSegment *)segment
{
    if (!_segment)
    {
        CGRect rect = CGRectZero ;
        rect.size = CGSizeMake(APPFRAME.size.width, MENU_HEIGHT) ;

        _segment = [[XTSegment alloc] initWithDataList:self.segList imgBg:[UIImage imageNamed:@"btBase"] height:MENU_HEIGHT normalColor:[UIColor darkTextColor] selectColor:COLOR_MAIN font:[UIFont systemFontOfSize:13.0]] ;
        _segment.delegate = self ;
        _segment.frame = rect ;
        _segment.backgroundColor = [UIColor whiteColor];
    }
    
    return _segment ;
}

#pragma mark - UserInfoViewDelegate
- (void)userInfoTappedBackground
{
//    if ( (!G_TOKEN || !G_USER.u_id) && (_noBottom == NO) ) {
//        [NavLogCtller modalLogCtrllerWithCurrentController:self] ;
//    }
}

- (void)editBtClick
{
    [self performSegueWithIdentifier:@"user2useredit" sender:nil] ;
}

#pragma mark - My Cell Delegate ( MySubao MyComments Mypraised )
- (void)jump2Article:(int)a_id
{
    NSLog(@"aID : %d",a_id) ;
    [DetailSubaoCtrller jump2DetailSubaoCtrller:self AndWithArticleID:a_id] ;
}

//- (void)clickDraft:(int)super_cid
//{
//    NSLog(@"super_cid : %d",super_cid) ;
//    Article *superArticle = [[DraftTB shareInstance] getSuperArticleWithCLientID:super_cid] ;
//    NSMutableArray *childsList = [[DraftTB shareInstance] getSubArticlesWithSuperArticleCLientID:super_cid] ;
//    [MultyEditCtrller jump2MultyEditCtrllerWithOrginCtrller:self
//                                               superArticle:superArticle
//                                                   topicStr:[superArticle getTopicStr]
//                                                  childList:childsList] ;
//}

#pragma mark - TeaSegmentDelegate
- (void)clickSegmentWith:(int)index
{
    NSLog(@"click : %d",index) ;
    
    BOOL bSub = [m_subaoList count] ;
    
    if (bSub)
    {
        [_table reloadData] ;
    }
    else
    {
        [self _refreshing] ;
    }
    
}

- (void)setup
{
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _table.backgroundColor = COLOR_BACKGROUND ;    
    _table.rowHeight = UITableViewAutomaticDimension;
}



#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.myTitle = @"用户个人主页" ;
    
    [self setup] ;
    
//    self.tabBarController.tabBar.hidden = _noBottom ;
    
    m_subaoList     = [NSMutableArray array] ;
    
    [self _refreshing] ;
    
    _pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(APPFRAME), 230)] ;
    _pathCover.userObj = self.theUser ;
    [self fetchUserHead] ;
    _pathCover.isZoomingEffect = YES ;
    self.table.tableHeaderView = _pathCover ;
    _pathCover.infoView.delegate = self ;
    
    __weak UserCenterController *wself = self ;
    [_pathCover setHandleRefreshEvent:^{
        [wself _refreshing] ;
    }];
    
}

- (void)fetchUserHead
{
    if (!self.theUser.u_id)
    {
        [_pathCover setBackgroundImage:nil] ;
        return ;
    }

// Ask The "User Head Picture" has cached or not . if not , download it .

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *headImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.theUser.u_headpic
                                                                        withCacheWidth:APPFRAME.size.width] ;
        if (!headImage)
        {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.theUser.u_headpic]
                                                                  options:0
                                                                 progress:nil
                                                                completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                    [self makeBlurOn:image] ;
                                                                }] ;
        }
        else {
            [self makeBlurOn:headImage] ;
        }
    }) ;
    

}

- (void)makeBlurOn:(UIImage *)orgImage
{
    __block UIImage *blurImage = [orgImage blur] ;
    dispatch_async(dispatch_get_main_queue(), ^{
                       [_pathCover setBackgroundImage:blurImage] ;
    }) ;
}


- (void)_refreshing
{
    if (_reloadingHead || _reloadingFoot) return ;
    
    _reloadingHead = YES ;
    // refresh your data sources
    __weak UserCenterController *wself = self ;
    dispatch_queue_t requestQueue = dispatch_queue_create("UserRequestqueue", DISPATCH_QUEUE_SERIAL) ;
    dispatch_async(requestQueue, ^{
        
        [wself getInfoWithPullUpDown:YES] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _pathCover.userObj = wself.theUser ;
            
            [wself fetchUserHead] ; //
            
            [wself.pathCover stopRefresh] ;
            [wself.table reloadData] ;
            _reloadingHead = NO ;
            
        }) ;
    }) ;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
//    if (!G_TOKEN) {
//        [XTHudManager showWordHudWithTitle:WD_NOT_LOGIN] ;
//    }
    
    
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    
    if (m_btSetting != nil)
    {
        CABasicAnimation *animate = [XTAnimation horizonRotationWithDuration:0.65
                                                                      degree:65
                                                                   direction:1
                                                                 repeatCount:1] ;
        [m_btSetting.layer addAnimation:animate forKey:@"rollSetting"] ;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- parsel
- (BOOL)parserResult:(ResultSBJ *)result
              getNew:(BOOL)bGetNew
{
    return [self runSubao:result With:bGetNew] ;
}

- (BOOL)runSubao:(ResultSBJ *)result
            With:(BOOL)bGetNew
{
    @synchronized (m_subaoList)
    {
        if (bGetNew)
        {
            [m_subaoList removeAllObjects] ;
        }
        
        if (isOther)
        {
            self.theUser = [[User alloc] initWithDic:[result.info objectForKey:@"user"]] ;
        }
        
        //1 get subao list
        NSArray *tempSubaoList = [result.info objectForKey:@"artiles"] ;
        if (!tempSubaoList.count) return NO ;
        for (NSDictionary *aDic in tempSubaoList) {
            Article *art = [[Article alloc] initWithDict:aDic] ;
            [m_subaoList addObject:art] ;
        }
        //2 get last subao id
        m_lastSubaoID = ((Article *)[m_subaoList lastObject]).a_id ;
        //3 get draft if get new and owner .
//        if (bGetNew && !isOther)
//        {
//            NSArray *draftList = [[DraftTB shareInstance] getAllNotUploadedSuperArticles] ;
//            m_subaoList = [NSMutableArray arrayWithArray:[draftList arrayByAddingObjectsFromArray:m_subaoList]] ;
//        }
        
        return YES ;
    }
}

- (BOOL)getInfoWithPullUpDown:(BOOL)bUpDown
{
    if (bUpDown)
    {
        m_lastSubaoID = 0 ;

    }
    
    id jsonObj = [ServerRequest getOtherHomePageWithUserID:_userID AndWithMaxID:m_lastSubaoID AndWithCount:SIZE_OF_PAGE] ;
    ResultSBJ *result = [[ResultSBJ alloc] initWithDic:jsonObj] ;
    if (!result) return NO ;
    BOOL bHas = [self parserResult:result getNew:bUpDown] ;

    if (!bUpDown && !bHas) {
        return NO ;
    }
    
    return YES ;
}


#pragma mark --
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1 ; //content ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self useSubaoCell] ;
}

- (MySubaoCell *)useSubaoCell
{
    static  NSString  *CellIdentiferId = @"MySubaoCell";
    MySubaoCell * cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId] ;
    if (!cell)
    {
        [_table registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
        cell = [_table dequeueReusableCellWithIdentifier:CellIdentiferId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.subaoList = m_subaoList ;
    cell.delegate = self ;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MySubaoCell calculateHeightWithList:m_subaoList] ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.segment ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return MENU_HEIGHT ;
}

// custom view for footer. will be adjusted to default or specified footer height
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] init] ;
    backView.backgroundColor = nil ;
    return backView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f ;
}

#pragma mark --
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_pathCover scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_pathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];

    [self loadMoreWithScrollView:scrollView] ;
}

- (void)loadMoreWithScrollView:(UIScrollView *)scrollView
{
    if (_reloadingHead || _reloadingFoot) return ; // protect loading only once . if in loading break
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize contentsize = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = contentsize.height;
    
    if (contentsize.height <= bounds.size.height) return ;
    
    CGFloat alarmDistance = 0 ;
    
    if (maximumOffset <= currentOffset + alarmDistance) {
        [self loadMoreAction];
    }
}

- (void)loadMoreAction
{
    _reloadingFoot = YES ;
    
    dispatch_queue_t queue = dispatch_queue_create("LoadMore", NULL) ;
    dispatch_async(queue, ^{
        BOOL b = [self getInfoWithPullUpDown:NO] ;
        if (b)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData] ;
                _reloadingFoot = NO ;
            }) ;
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [XTHudManager showWordHudWithTitle:WD_HUD_NOMORE delay:1.0] ;
                _reloadingFoot = NO ;
            }) ;
        }
    }) ;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_pathCover scrollViewWillBeginDragging:scrollView];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES] ;
}


@end
