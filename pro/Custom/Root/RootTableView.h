//
//  RootTableView.h
//  Demo_MjRefresh
//
//  Created by TuTu on 15/12/3.
//  Copyright © 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

#define TABLE_HEADER_IMAGES             @"loading_"
#define TABLE_HEADER_IMAGES_COUNT       7

@protocol RootTableViewDelegate <NSObject>

@optional
- (void)loadNewData ;
- (void)loadMoreData ;

@end

@interface RootTableView : UITableView

// SET myDelegate TO YOUR CTRLLER
@property (nonatomic,weak) id <RootTableViewDelegate> xt_Delegate ;
// DEFAULT IS `NO`  -> ONLY GIF IMAGES , SHOW WORDS WHEN IT BECOMES `YES`
@property (nonatomic) BOOL showRefreshDetail ;
// DEFAULT IS `NO`  -> MANUALLY LOADING . AUTOMATICALLY LOAD WHEN IT BECOMES `YES`
@property (nonatomic) BOOL automaticallyLoadMore ;
// DEFAULT IS `YES` -> EVERYTIME INITIAL WITH AUTO LOAD NEW . CHANGE IT TO `NO` IF NECESSARY .
@property (nonatomic) BOOL automaticallyLoadNew ;

- (void)pullDownRefreshHeader ;

@end
