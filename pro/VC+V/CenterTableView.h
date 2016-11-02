//
//  CenterTableView.h
//  pro
//
//  Created by TuTu on 16/8/18.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "RootTableView.h"



@interface CenterTableView : RootTableView

@property (nonatomic,copy) void(^offsetYHasChangedValue)(CGFloat offsetY) ;
- (void)refreshImage:(NSString *)imgStr ;
- (void)clearImage ;

@end
