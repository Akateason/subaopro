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

@interface SearchCtrller () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    BOOL    typeTitleOrTag ; // false - > title , true tag .
}
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIButton *btSwith;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *statusbar;
//
@property (nonatomic,strong) NSArray *dataList ;
@property (nonatomic,strong) NSArray *menuItems ;

@end

@implementation SearchCtrller


#pragma mark - life

- (void)viewDidLoad
{
    [super viewDidLoad] ;
    
    
    [self configureUI] ;
    
    // Do any additional setup after loading the view.
    _searchBar.delegate = self ;
    _table.backgroundColor = [UIColor xt_cellSeperate] ;
    _table.dataSource = self ;
    _table.delegate = self ;
    _table.separatorStyle = 0 ;
}

- (void)configureUI
{
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
    [self dismissViewControllerAnimated:YES
                             completion:^{
        
    }] ;
}

#pragma mark - prop

- (IBAction)btSearchConditionOnClick:(UIButton *)sender
{
    CGRect rect = sender.frame ;
    rect.origin.y -= sender.frame.size.height / 2. ;
    [KxMenu showMenuInView:self.view.window
                  fromRect:rect
                 menuItems:self.menuItems] ;
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
        
    }] ;
}

// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES ;
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"开始搜索") ;
    if (typeTitleOrTag == false)
    {
        [ServerRequest searchContentsByTitle:self.searchBar.text
                                     success:^(id json) {
                                         [self dealResultJson:json] ;
                                         [self.searchBar resignFirstResponder] ;
                                     } fail:^{
                                         [self.searchBar resignFirstResponder] ;
                                     }] ;
    }
    else if (typeTitleOrTag == true)
    {
        [ServerRequest searchContentByTag:self.searchBar.text
                                  success:^(id json) {
                                      [self dealResultJson:json] ;
                                      [self.searchBar resignFirstResponder] ;
                                  } fail:^{
                                      [self.searchBar resignFirstResponder] ;
                                  }] ;
    }
}

- (void)dealResultJson:(id)json
{
    ResultParsered *result = [ResultParsered yy_modelWithJSON:json] ;
    if (result.errCode == 1001)
    {
        NSArray *resultList = result.info[@"list"] ;
        NSMutableArray *tmpList = [@[] mutableCopy] ;
        for (NSDictionary *dic in resultList) {
            Content *acontent = [Content yy_modelWithJSON:dic] ;
            [tmpList addObject:acontent] ;
        }
        self.dataList = tmpList ;
        [_table reloadData] ;
    }
    
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
