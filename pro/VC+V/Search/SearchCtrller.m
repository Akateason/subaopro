//
//  SearchCtrller.m
//  pro
//
//  Created by TuTu on 16/9/27.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "SearchCtrller.h"
#import "KxMenu.h"
#import "NormalContentCell.h"
#import "ServerRequest.h"
#import "ResultParsered.h"
#import "YYModel.h"
#import "Content.h"
#import "DetailCtrller.h"
#import "UIImage+AddFunction.h"
#import "XTSearchHandler.h"

static const int  kSize  =  10 ;

@interface SearchCtrller () <RootTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    BOOL    typeTitleOrTag ; // false - > title , true tag .
    int     currentPage ;
}
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIButton *btSwith;
@property (weak, nonatomic) IBOutlet RootTableView *table;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *statusbar;
@property (weak, nonatomic) IBOutlet UIButton *btCancel;
//
@property (nonatomic,strong) NSArray            *dataList ;
@property (nonatomic,strong) NSArray            *menuItems ;
@property (nonatomic,strong) XTSearchHandler    *searchHandler ;

@end

@implementation SearchCtrller


#pragma mark - life

- (void)viewDidLoad
{
    [super viewDidLoad] ;
    self.myTitle = @"搜索" ;
    [self configureUI] ;
    [self tableConfigure] ;
}

- (void)tableConfigure
{
    _table.backgroundColor = [UIColor xt_cellSeperate] ;
    _table.dataSource = self ;
    _table.delegate = self ;
    _table.separatorStyle = 0 ;
    _table.xt_Delegate = self ;
    _table.automaticallyLoadNew = NO ;
}

- (void)configureUI
{
    _btCancel.backgroundColor = [UIColor xt_nav] ;
 
    _searchBar.delegate = self ;

    _topBar.backgroundColor = [UIColor clearColor] ;
    _statusbar.backgroundColor = [UIColor xt_nav] ;
    _btSwith.backgroundColor = [UIColor xt_nav] ;
    
    _searchBar.barTintColor = [UIColor whiteColor] ;
    _searchBar.tintColor = [UIColor darkGrayColor] ;
    _searchBar.backgroundColor = [UIColor xt_nav] ;
    UIImage* searchBarBg = [UIImage imageNamed:@"schbar"] ;
    //[UIImage imageNamed:@"schbar"] ;
    //[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 28)] ;
    [_searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal] ;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [self.navigationController setNavigationBarHidden:YES] ;
    [_searchBar becomeFirstResponder] ;
}

#pragma mark - action
- (IBAction)btCancelOnClick:(id)sender
{
    if (self.searchBar.text.length == 0) {
        [self dismissViewControllerAnimated:YES
                                 completion:^{}] ;
        return ;
    }
    
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder] ;
    }
    else {
        [self dismissViewControllerAnimated:YES
                                 completion:^{}] ;
    }
}

- (IBAction)btSearchConditionOnClick:(UIButton *)sender
{
    CGRect rect = sender.frame ;
    rect.origin.y -= sender.frame.size.height / 2. ;
    [KxMenu showMenuInView:self.view.window
                  fromRect:rect
                 menuItems:self.menuItems] ;
}




#pragma mark - prop

- (XTSearchHandler *)searchHandler
{
    if (!_searchHandler) {
        _searchHandler = [[XTSearchHandler alloc] init] ;
    }
    return _searchHandler ;
}



- (NSArray *)menuItems
{
    if (!_menuItems) {
        _menuItems = @[
                       [KxMenuItem menuItem:@"按标题"
                                      image:nil
                                     target:self
                                     action:@selector(toTitle:)] ,
                       [KxMenuItem menuItem:@"按标签"
                                      image:nil
                                     target:self
                                     action:@selector(toTag:)] ,
                       ] ;
    }
    return _menuItems ;
}
- (void)toTitle:(KxMenuItem *)item
{
    [self.btSwith setTitle:@"按标题" forState:0] ;
    typeTitleOrTag = false ;
}

- (void)toTag:(KxMenuItem *)item
{
    [self.btSwith setTitle:@"按标签" forState:0] ;
    typeTitleOrTag = true ;
}




#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self loadNewOrMore:YES] ;
}

// return NO to not become first responder
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    return YES ;
//}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"开始搜索") ;
    [self.searchBar resignFirstResponder] ;
}

#pragma mark -
// load from server .
- (void)loadNewOrMore:(BOOL)bNewOrMore
{
    if (bNewOrMore) {
        currentPage = 1 ; //new
    }
    
    if (typeTitleOrTag == false)
    {
        [self.searchHandler searchWithText:self.searchBar.text
                                     order:@""
                                      sort:@"desc"
                                  searchBy:@"title"
                                      page:currentPage
                                      size:kSize
                            searchComplete:^(NSURLSessionDataTask *task, id responseObject) {
                               
                                [self dealResultJson:responseObject loadNewOrLoadMore:bNewOrMore] ;
//                                [self.searchBar resignFirstResponder] ;
                                currentPage ++ ;

                            }
         fail:^(NSURLSessionDataTask *task, NSError *error) {
             
             [self.searchBar resignFirstResponder] ;

         }] ;
    }
    else if (typeTitleOrTag == true)
    {
        [self.searchHandler searchWithText:self.searchBar.text
                                     order:@""
                                      sort:@"desc"
                                  searchBy:@"tag"
                                      page:currentPage
                                      size:kSize
                            searchComplete:^(NSURLSessionDataTask *task, id responseObject) {

                                [self dealResultJson:responseObject loadNewOrLoadMore:bNewOrMore] ;
//                                [self.searchBar resignFirstResponder] ;
                                currentPage ++ ;

                            } fail:^(NSURLSessionDataTask *task, NSError *error) {

                                [self.searchBar resignFirstResponder] ;

                            }] ;

        
    }
}




// bNewOrMore - true New , false More
- (void)dealResultJson:(id)json loadNewOrLoadMore:(BOOL)bNewOrMore
{
    ResultParsered *result = [ResultParsered yy_modelWithJSON:json] ;
    if (result.errCode == 1001)
    {
        NSArray *resultList = result.info[@"list"] ;
        
        NSMutableArray *tmpList = nil ;
        if (bNewOrMore) {
            tmpList = [@[] mutableCopy] ;
        }
        else {
            tmpList = [self.dataList mutableCopy] ;
        }
        
        for (NSDictionary *dic in resultList) {
            Content *acontent = [Content yy_modelWithJSON:dic] ;
            [tmpList addObject:acontent] ;
        }
        self.dataList = tmpList ;
        [_table reloadData] ;
    }
    
}



#pragma mark - RootTableViewDelegate <NSObject>

- (void)loadNewData
{
    [self loadNewOrMore:YES] ;
}

- (void)loadMoreData
{
    [self loadNewOrMore:NO] ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_normalContentcell] ;
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:identifier_normalContentcell bundle:nil] forCellReuseIdentifier:identifier_normalContentcell] ;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier_normalContentcell] ;
    }
    cell.aContent = self.dataList[indexPath.row] ;
    return cell ;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NormalContentCell getHeight] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCtrller *detailVC = (DetailCtrller *)[[self class] getCtrllerFromStory:@"Index" controllerIdentifier:@"DetailCtrller"] ;
    detailVC.content = self.dataList[indexPath.row] ;

    [self.navigationController pushViewController:detailVC animated:YES] ;
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
