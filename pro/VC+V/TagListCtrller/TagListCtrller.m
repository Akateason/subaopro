//
//  TagListCtrller.m
//  pro
//
//  Created by TuTu on 16/8/29.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "TagListCtrller.h"
#import "NormalContentCell.h"
#import "Tag.h"
#import "ServerRequest.h"
#import "ResultParsered.h"
#import "Content.h"
#import "DetailCtrller.h"

@interface TagListCtrller () <UITableViewDelegate,UITableViewDataSource,RootTableViewDelegate>

@property (weak, nonatomic) IBOutlet RootTableView *table;
@property (nonatomic,strong) NSArray *dataList ;

@end

@implementation TagListCtrller



- (void)setAtag:(Tag *)atag
{
    _atag = atag ;
    
    self.title = atag.name ;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_table registerNib:[UINib nibWithNibName:identifier_normalContentcell bundle:nil] forCellReuseIdentifier:identifier_normalContentcell] ;
    _table.separatorStyle = 0 ;
    _table.dataSource = self ;
    _table.delegate = self ;
    _table.xt_Delegate = self ;
    _table.backgroundColor = [UIColor xt_cellSeperate] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [self.navigationController setNavigationBarHidden:NO] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    [self.navigationController setNavigationBarHidden:YES] ;
}


#pragma mark - RootTableViewDelegate
- (void)loadNewData:(UITableView *)table
{
    [ServerRequest searchContentByTag:self.atag.name
                              success:^(id json) {
                                  
                                  self.dataList = @[] ;
                                  NSMutableArray *tmpList = [@[] mutableCopy] ;
                                  ResultParsered *result = [ResultParsered yy_modelWithJSON:json] ;
                                  if (result.errCode == 1001) {
                                      NSArray *resultList = result.info[@"list"] ;
                                      for (NSDictionary *tmpDic in resultList)
                                      {
                                          Content *acontent = [Content yy_modelWithJSON:tmpDic] ;
                                          [tmpList addObject:acontent] ;
                                      }
                                      self.dataList = tmpList ;
                                      [_table reloadData] ;
                                  }
                                  
                              } fail:^{
                                  
                              }] ;
}

- (void)loadMoreData
{
    
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
