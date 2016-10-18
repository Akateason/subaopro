//
//  Content.h
//  pro
//
//  Created by TuTu on 16/8/25.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Content : NSObject

@property (nonatomic)       int         contentId ;
@property (nonatomic,copy)  NSString    *title ;
@property (nonatomic,copy)  NSString    *author ;
@property (nonatomic)       int         kind ;
@property (nonatomic,strong)NSArray     *tags ;
@property (nonatomic,copy)  NSString    *link ;
@property (nonatomic,copy)  NSString    *html ;
@property (nonatomic,copy)  NSString    *cover ;
@property (nonatomic,strong)NSArray     *imgs ;
@property (nonatomic)       long long   createtime ;
@property (nonatomic)       long long   updatetime ;
@property (nonatomic)       long long   sendtime ;
@property (nonatomic)       int         displayType ;
@property (nonatomic)       int         readNum ;
@property (nonatomic)       int         isTop ;
@property (nonatomic)       int         isRecommend ;
@property (nonatomic)       int         isSlide ;

@property (nonatomic,copy)    NSString  *kindName ;

- (NSString *)getFinalLink ;

@end
