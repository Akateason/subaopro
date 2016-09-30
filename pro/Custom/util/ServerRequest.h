//
//  ServerRequest.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "XTRequest.h"
#import "ResultParsered.h"
#import "PublicEnum.h"
@class User ;

@interface ServerRequest : XTRequest


#pragma mark - SBJ 获取首页
/** 获取首页
 since_id	选填参数	若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0
 max_id     选填参数	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
 count      选填参数	单页返回的记录条数，默认为50。
 */
+ (id)getHomePageInfoResultWithSinceID:(int)sinceID
                              AndMaxID:(long long)maxID
                              AndCount:(int)count ;


#pragma mark - 一直播 直播列表
+ (void)yzb_hotliveListWithSDKID:(NSString *)sdkid
                            time:(long long)time
                            sign:(NSString *)sign
                            page:(int)page
                           limit:(int)limit
                         success:(void (^)(id json))success
                            fail:(void (^)())fail ;

+ (id)yzb_hotliveListWithSDKID:(NSString *)sdkid
                          time:(long long)time
                          sign:(NSString *)sign
                          page:(int)page
                         limit:(int)limit ;





#pragma mark --
#pragma mark - 获取类型 列表 .                        i/h
+ (void)getAllKindListSuccess:(void (^)(id json))success
                         fail:(void (^)())fail ;
+ (ResultParsered *)getAllKindList ;

#pragma mark - 获取内容列表     app                      i/h (全部返回)
+ (void)getContentListWithKindID:(int)kindID
                        sendtime:(long long)sendtimeTick
                            size:(int)size
                         success:(void (^)(id json))success
                            fail:(void (^)())fail ;

#pragma mark - 获取内容详情                            i/hP : 内容id .
+ (void)getContentDetailWithContentID:(int)contentID
                              success:(void (^)(id json))success
                                 fail:(void (^)())fail ;

#pragma mark - 按标题搜索 获取内容列表
+ (void)searchContentsByTitle:(NSString *)title
                      success:(void (^)(id json))success
                         fail:(void (^)())fail ;

#pragma mark - 按标签搜索 获取内容列表          i/h
+ (void)searchContentByTag:(NSString *)tag
                   success:(void (^)(id json))success
                      fail:(void (^)())fail ;


#pragma mark - 标签 模糊搜索  返回列表            h
+ (void)tagSearchByWord:(NSString *)word
                success:(void (^)(id json))success
                   fail:(void (^)())fail ;

#pragma mark - 增加阅读数
+ (void)addReadWithContentID:(int)contentID
                     success:(void (^)(id json))success
                        fail:(void (^)())fail ;

@end





