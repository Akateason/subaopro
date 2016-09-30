//
//  FindViewController.m
//  pro
//
//  Created by TuTu on 16/8/29.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "FindViewController.h"
#import "ServerRequest.h"
//#import "ResultParsered.h"
#import "YYModel.h"
#import "SearchCtrller.h"
#import "HomeCell.h"
#import "HomeUserTableHeaderView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Article.h"
#import "ArticleTopic.h"
#import "Themes.h"
#import "ResultSBJ.h"


float const SIZE_OF_PAGE = 20 ;


@interface FindViewController () <UITableViewDataSource,UITableViewDelegate,RootTableViewDelegate,HomeCellDelegate,HomeUserTableHeaderViewDelegate>
{
    long long           m_lastUpdateTime    ; // 首页最新的updateTime && 话题页
    
}
@property (weak, nonatomic) IBOutlet UIView         *schbarbg;
@property (weak, nonatomic) IBOutlet UIView         *schbarbg2;
@property (weak, nonatomic) IBOutlet UIView         *navbar;
@property (weak, nonatomic) IBOutlet UILabel        *labelFind;
@property (weak, nonatomic) IBOutlet RootTableView  *table;

@property (atomic, strong)  NSMutableArray          *articleList ;

@end

@implementation FindViewController

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


#pragma mark - life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureUIs] ;
    [_table registerNib:[UINib nibWithNibName:HomeCellID bundle:nil] forCellReuseIdentifier:HomeCellID] ;
    [_table registerNib:[UINib nibWithNibName:HeaderIdentifier bundle:nil] forHeaderFooterViewReuseIdentifier:HeaderIdentifier] ;
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _table.xt_Delegate = self ;
//    _table.backgroundColor = COLOR_BACKGROUND ;
//    _table.customLoadMore = YES ;
    
}

- (void)configureUIs
{
    _navbar.backgroundColor = [UIColor xt_nav] ;
    _schbarbg.backgroundColor = [UIColor xt_nav] ;
    _schbarbg2.backgroundColor = [UIColor whiteColor] ;
    _schbarbg2.layer.cornerRadius = 5. ;
    _schbarbg2.layer.masksToBounds = true ;
    _labelFind.textColor = [UIColor whiteColor] ;
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
    @synchronized (self.articleList)
    {
        result.info = [result.info objectForKey:@"items"] ;
        //1 get article
        NSArray *tempArticleList = [[result.info objectForKey:@"articles"] objectForKey:@"article_list"] ;
        if (!tempArticleList.count) return NO ;
        if (bGetNew) {
            [self.articleList removeAllObjects] ;
        }
        
        NSMutableArray *mutableList = self.articleList ;
        [tempArticleList enumerateObjectsUsingBlock:^(NSDictionary *articleDic, NSUInteger idx, BOOL * _Nonnull stop) {
            Article *arti = [[Article alloc] initWithDict:articleDic] ;
            [mutableList addObject:arti] ;
        }] ;
        self.articleList = mutableList ;
        
        m_lastUpdateTime = ((Article *)[self.articleList lastObject]).a_updatetime ;
    }
    
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
- (void)loadNewData
{
    BOOL bSuccess = [self getHomeInfoFromServerWithPullUpDown:YES] ;
}

- (void)loadMoreData
{
    BOOL hasNew = [self getHomeInfoFromServerWithPullUpDown:NO] ;
}



#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.articleList.count + 1 ;
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
    @synchronized (self.articleList) {
        cell.article = (Article *)self.articleList[indexPath.section] ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHomeCellWithIndexPath:indexPath] ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section ;
    Article *articleTemp = self.articleList[section - 1] ;
    
//    [DetailSubaoCtrller jump2DetailSubaoCtrller:self
//                               AndWithArticleID:articleTemp.a_id
//                               AndWithCommentID:0
//                                       FromRect:self.fromRect
//                                        imgSend:self.imgTempWillSend] ;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section ;
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

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *emtpyHeader = [[UITableViewHeaderFooterView alloc] init] ;
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
