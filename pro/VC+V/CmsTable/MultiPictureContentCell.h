//
//  MultiPictureContentCell.h
//  pro
//
//  Created by TuTu on 16/8/17.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Content ;

static NSString *identifier_MultiPictureContentCell = @"MultiPictureContentCell" ;

@interface MultiPictureContentCell : UITableViewCell

@property (nonatomic,strong) Content *aContent ;
+ (float)getHeightWithTitle:(NSString *)strTitle ;

@end
