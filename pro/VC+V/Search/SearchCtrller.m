//
//  SearchCtrller.m
//  pro
//
//  Created by TuTu on 16/9/27.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "SearchCtrller.h"
#import "KxMenu.h"

@interface SearchCtrller () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *menuItems ;

@end

@implementation SearchCtrller

- (IBAction)btCancelOnClick:(id)sender
{
    [self hideSearchBar:YES] ;
}

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
                       [KxMenuItem menuItem:@"标题"
                                      image:nil
                                     target:self
                                     action:@selector(toTitle:)] ,
                       [KxMenuItem menuItem:@"标签"
                                      image:nil
                                     target:self
                                     action:@selector(toTag:)] ,
                       ] ;
    }
    return _menuItems ;
}

- (void)toTitle:(KxMenuItem *)item
{
    [self.btSearchCondition setTitle:@"标题" forState:0] ;
    typeTitleOrTag = false ;
}

- (void)toTag:(KxMenuItem *)item
{
    [self.btSearchCondition setTitle:@"标签" forState:0] ;
    typeTitleOrTag = true ;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _table.backgroundColor = [UIColor xt_cellSeperate] ;
    _table.dataSource = self ;
    _table.delegate = self ;
    _table.separatorStyle = 0 ;

}




#pragma mark - UISearchBarDelegate
// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self hideSearchBar:NO] ;
    return YES ;
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self hideSearchBar:YES] ;
    
    NSLog(@"开始搜索") ;
    if (typeTitleOrTag == false)
    {
        [ServerRequest searchContentsByTitle:self.searchBar.text
                                     success:^(id json) {
                                         [self dealResultJson:json] ;
                                     } fail:^{
                                     }] ;
    }
    else if (typeTitleOrTag == true)
    {
        [ServerRequest searchContentByTag:self.searchBar.text
                                  success:^(id json) {
                                      [self dealResultJson:json] ;
                                  } fail:^{
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

- (void)hideSearchBar:(BOOL)bHide
{
    if (bHide) {
        [self.searchBar resignFirstResponder] ;
        self.btCancel.hidden = bHide ;
        self.btCancel_width.constant = 0. ;
    }
    else {
        self.btCancel.hidden = bHide ;
        self.btCancel_width.constant = 54. ;
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
    [detailVC setHidesBottomBarWhenPushed:YES] ;
    [self.navigationController pushViewController:detailVC animated:YES] ;
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
