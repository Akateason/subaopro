//
//  FindViewController.m
//  pro
//
//  Created by TuTu on 16/8/29.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "FindViewController.h"
#import "ServerRequest.h"
#import "YYModel.h"
#import "SearchCtrller.h"
#import "HomeCell.h"
#import "HomeUserTableHeaderView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Article.h"
#import "ArticleTopic.h"
#import "Themes.h"
#import "ResultSBJ.h"
#import "UserCenterController.h"
#import "DetailSubaoCtrller.h"
#import "DetailSubaoCtrller+TaskModuleTransition.h"


float const SIZE_OF_PAGE = 20 ;


@interface FindViewController () <UITableViewDataSource,UITableViewDelegate,RootTableViewDelegate,HomeCellDelegate,HomeUserTableHeaderViewDelegate>
{
    long long           m_lastUpdateTime ; // 首页最新的updateTime && 话题页
    
}
@property (weak, nonatomic) IBOutlet UIView         *schbarbg;
@property (weak, nonatomic) IBOutlet UIView         *schbarbg2;
@property (weak, nonatomic) IBOutlet RootTableView  *table;

@property (nonatomic,strong) dispatch_queue_t       myQueue ;
@property (nonatomic,strong)  NSArray               *articleList ;

@end

@implementation FindViewController
@synthesize articleList = _articleList ;


#pragma mark - SuBaoHeaderViewDelegate
- (void)clickUserHead:(int)userID
{
    [UserCenterController jump2UserCenterCtrller:self
                                       AndUserID:userID] ;
}

#pragma mark - action

- (IBAction)schbarOnClick:(id)sender
{
    UINavigationController *searchNavVC = (UINavigationController *)[[self class] getCtrllerFromStory:@"Find" controllerIdentifier:@"SchNavCtrl"] ;
    
    [self presentViewController:searchNavVC
                       animated:YES
                     completion:^{
        
    }] ;
}

#pragma mark - prop
- (dispatch_queue_t)myQueue
{
    if (!_myQueue) {
        _myQueue = dispatch_queue_create("mySyncQueue", DISPATCH_QUEUE_CONCURRENT) ;
    }
    return _myQueue ;
}

- (NSArray *)articleList
{
    if (!_articleList) {
        _articleList = @[] ;
    }
    return _articleList ;
    
    __block NSArray *list ;
    dispatch_sync(self.myQueue, ^{
        list = _articleList ;
    }) ;
    return list ;
}

- (void)setArticleList:(NSArray *)articleList
{
    dispatch_barrier_async(self.myQueue, ^{
        _articleList = articleList ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_table reloadData] ;
        }) ;
    }) ;
}


#pragma mark - life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureUIs] ;
    [self configreTable] ;
}

- (void)configureUIs
{
    _schbarbg.backgroundColor = [UIColor xt_nav] ;
    _schbarbg2.backgroundColor = [UIColor whiteColor] ;
    _schbarbg2.layer.cornerRadius = 5. ;
    _schbarbg2.layer.masksToBounds = true ;
}

- (void)configreTable
{
    [_table registerNib:[UINib nibWithNibName:HomeCellID bundle:nil] forCellReuseIdentifier:HomeCellID] ;
    [_table registerNib:[UINib nibWithNibName:HeaderIdentifier bundle:nil] forHeaderFooterViewReuseIdentifier:HeaderIdentifier] ;
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _table.xt_Delegate = self ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
    [self.navigationController setNavigationBarHidden:YES] ;
}



#pragma mark --
#pragma mark - parser Home Info
- (BOOL)parserResult:(ResultSBJ *)result
              getNew:(BOOL)bGetNew
{
    result.info = [result.info objectForKey:@"items"] ;
    //1 get article
    NSArray *tempArticleList = [[result.info objectForKey:@"articles"] objectForKey:@"article_list"] ;
    if (!tempArticleList.count) return NO ;
    
    NSMutableArray *mutableList = bGetNew ? [@[] mutableCopy] : self.articleList ;
    
    [tempArticleList enumerateObjectsUsingBlock:^(NSDictionary *articleDic, NSUInteger idx, BOOL * _Nonnull stop) {
        Article *arti = [[Article alloc] initWithDict:articleDic] ;
        [mutableList addObject:arti] ;
    }] ;
    self.articleList = mutableList ;
    
    m_lastUpdateTime = ((Article *)[self.articleList lastObject]).a_updatetime ;
    
    return YES ;
}

- (BOOL)getHomeInfoFromServerWithPullUpDown:(BOOL)bUpDown
{
    if (bUpDown) m_lastUpdateTime = 0 ;
    id json = [ServerRequest getHomePageInfoResultWithSinceID:0
                                                     AndMaxID:m_lastUpdateTime
                                                     AndCount:SIZE_OF_PAGE] ;
    ResultSBJ *result = [ResultSBJ yy_modelWithJSON:json] ;
    BOOL bHas = [self parserResult:result getNew:bUpDown] ;
    if ( (bUpDown && !bHas) || (!bUpDown && !bHas) ) return NO ;
    
    return YES   ;
}


#pragma mark --
#pragma mark -- RootTableViewDelegate
- (void)loadNewData:(UITableView *)table
{
    [self getHomeInfoFromServerWithPullUpDown:YES] ;
}

- (void)loadMoreData
{
    [self getHomeInfoFromServerWithPullUpDown:NO] ;
}



#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.articleList.count ;
}

- (HomeCell *)getHomeCellWithIndexPath:(NSIndexPath *)indexPath
{
    HomeCell * cell = [_table dequeueReusableCellWithIdentifier:HomeCellID] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.delegate = self ;
    cell.isflywordShow = true ;
    [self configureHomeCell:cell atIndexPath:indexPath] ;
    return cell ;
}

- (void)configureHomeCell:(HomeCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.fd_enforceFrameLayout = YES ; // Enable to use "-sizeThatFits:"
    cell.article = (Article *)self.articleList[indexPath.section] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHomeCellWithIndexPath:indexPath] ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section ;
    Article *articleTemp = self.articleList[section] ;
    [DetailSubaoCtrller jump2DetailSubaoCtrller:self
                               AndWithArticleID:articleTemp.a_id
                               AndWithCommentID:0
                                       FromRect:CGRectZero
                                        imgSend:nil] ;
    //self.fromRect
    //self.imgTempWillSend
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger section = indexPath.section ;
    return [tableView fd_heightForCellWithIdentifier:HomeCellID
                                    cacheByIndexPath:indexPath
                                       configuration:^(HomeCell *cell) {
        [self configureHomeCell:cell atIndexPath:indexPath] ;
    }] ;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HomeUserTableHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier] ;
    header.delegate = self ;
    header.article = self.articleList[section] ;
    return header ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48.0f ;
}

static NSString *const kFooterIdentifer = @"kFooterIdentifer" ;
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *emtpyHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kFooterIdentifer] ;
    if (!emtpyHeader) {
        emtpyHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kFooterIdentifer] ;
    }
    return emtpyHeader ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0. ;
}







- (void)didReceiveMemoryWarning
{
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
