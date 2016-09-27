//
//  YzbListItem.m
//  pro
//
//  Created by TuTu on 16/9/19.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "YzbListItem.h"
#import "Content.h"

@implementation YzbListItem

- (Content *)convertToContent
{
    Content *aContent = [[Content alloc] init] ;
    NSString *imgStrOrigin = self.covers[@"b"] ;
    NSString *cover = [imgStrOrigin stringByReplacingOccurrencesOfString:@".webp" withString:@""] ;
    aContent.cover = cover ;
    aContent.link = [NSString stringWithFormat:@"http://www.yizhibo.com/l/%@.html",self.scid] ;
    aContent.title = self.title ;
    aContent.kindName = @"直播" ;
    aContent.readNum = (int)self.online ;
    aContent.isTop = 0 ;
    aContent.author = self.nickname ;
    aContent.createtime = self.starttime ;
    aContent.sendtime = self.starttime ;
    
    return aContent ;
}


@end
