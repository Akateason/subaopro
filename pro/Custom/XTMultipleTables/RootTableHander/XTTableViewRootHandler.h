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

@property (nonatomic)        CGFloat        offsetY ;      // cache offsetY .
@property (nonatomic,strong) UITableView    *table ;

- (void)handleTableDatasourceAndDelegate:(UITableView *)table ;
- (void)refreshOffsetY ;
- (void)centerHandlerRefreshing ;
- (void)tableIsFromCenter:(BOOL)isFromCenter ;

@end
