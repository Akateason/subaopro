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



@end
