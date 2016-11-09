//
//  UIImageView+QNExtention.m
//  pro
//
//  Created by TuTu on 16/9/12.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "UIImageView+QNExtention.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (QNExtention)

- (void)photoFromQiNiu:(NSString *)imgUrl
{    
    [self sd_setImageWithURL:[NSURL URLWithString:imgUrl]] ;
}




@end
