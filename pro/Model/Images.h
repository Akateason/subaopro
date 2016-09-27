//
//  Images.h
//  pro
//
//  Created by TuTu on 16/8/26.
//  Copyright © 2016年 teason. All rights reserved.
// 多图

#import <Foundation/Foundation.h>

@interface Images : NSObject

@property (nonatomic)       int         imagesId ;
@property (nonatomic)       int         contentId ;
@property (nonatomic,copy)  NSString    *img ;
@property (nonatomic)       int         order ;

@end
