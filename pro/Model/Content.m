//
//  Content.m
//  pro
//
//  Created by TuTu on 16/8/25.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "Content.h"
#import "Tag.h"
#import "Images.h"
#import "UrlRequestHeader.h"

@implementation Content

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"tags" : @"taglist" ,
             @"imgs" : @"imagelist"} ;
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"tags" : [Tag class] ,
             @"imgs" : [Images class]
             } ;
}

- (NSString *)getFinalLink
{
    NSString *strResult = self.link ;
    // 如果有html, 拼出h5地址 . 如果没有, 直接调用link
    if (self.html && self.html.length > 0) {
        strResult = URL_SHOW_CONTENT_WITHID(self.contentId) ;
    }
    
    if (![strResult hasPrefix:@"http"]) {
        strResult = [@"http://" stringByAppendingString:strResult] ;
    }
    return strResult ;
}

@end
