//
//  NormalContentCell.h
//  pro
//
//  Created by TuTu on 16/8/8.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Content ;

static NSString *identifier_normalContentcell = @"NormalContentCell" ;

@interface NormalContentCell : UITableViewCell

@property (nonatomic,strong) Content *aContent ;

+ (float)getHeight ;

@end
