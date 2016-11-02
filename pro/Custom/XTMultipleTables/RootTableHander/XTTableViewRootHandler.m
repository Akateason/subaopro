//
//  XTTableViewRootHandler.m
//  XTMultipleTables
//
//  Created by TuTu on 15/12/7.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "XTTableViewRootHandler.h"

@interface XTTableViewRootHandler () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation XTTableViewRootHandler

#pragma mark --
#pragma mark - Initialization
- (instancetype)initWithDataList:(NSArray *)datalist
                           table:(UITableView *)table
{
    self = [super init];
    if (self) {
//        self.dataList = datalist ;
        self.table = table ;
        [self handleTableDatasourceAndDelegate:table] ;
    }
    return self;
}

- (instancetype)initWithDataList:(NSArray *)datalist
{
    self = [super init];
    if (self) {
//        self.dataList = datalist ;
    }
    return self;
}

#pragma mark --
#pragma mark - Public
- (void)handleTableDatasourceAndDelegate:(UITableView *)table
{
// set datasource and delegate .
    self.table = table ;
    table.dataSource = self ;
    table.delegate = self ;
// needs layout
    [table setNeedsLayout] ;
}

- (void)refreshOffsetY
{
    CGPoint offset = self.table.contentOffset ;
    offset.y = self.offsetY ;
    self.table.contentOffset = offset ;
}

- (void)tableIsFromCenter:(BOOL)isFromCenter
{
    //1. do sth . only center table will do .
    
    //2. do sth  left right table will do .
    
}

- (void)centerHandlerRefreshing
{
    
}


#pragma mark - root table view delegate
- (void)loadNewData
{
    
}

- (void)loadMoreData
{
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0. ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
