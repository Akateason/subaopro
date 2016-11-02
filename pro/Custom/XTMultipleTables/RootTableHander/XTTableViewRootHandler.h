//
//  XTTableViewRootHandler.h
//  XTMultipleTables
//
//  Created by TuTu on 15/12/7.
//  Copyright © 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XTTableViewRootHandler : NSObject 

//@property (nonatomic,strong) NSArray *dataList ;    // datasource
@property (nonatomic)        CGFloat        offsetY ;      // cache offsetY .
@property (nonatomic,strong) UITableView    *table ;

// 这个参数要改成dic. 分别挂钩 1.header放置banner, 2.
- (instancetype)initWithDataList:(NSArray *)datalist ;
- (instancetype)initWithDataList:(NSArray *)datalist table:(UITableView *)table ;

- (void)handleTableDatasourceAndDelegate:(UITableView *)table ;
- (void)refreshOffsetY ;
- (void)centerHandlerRefreshing ;
- (void)tableIsFromCenter:(BOOL)isFromCenter ;

@end
