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

#pragma mark - 搜索 获取内容列表
//url	/content/search
//param	keyword
//param	order
//param	sort	默认desc
//param	searchBy	title,tag,kind
//param	page	默认1
//param	size	默认20
//return	success 1001 	list
+ (void)searchContentsByKeyword:(NSString *)keyword
                          order:(NSString *)order
                           sort:(NSString *)sort
                       searchBy:(NSString *)searchBy
                           page:(int)page
                           size:(int)size
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

/** 标签颜色
 */
+ (id)getCateTypeColor ;
//获取他人主页
+ (id)getOtherHomePageWithUserID:(int)uid
                    AndWithMaxID:(int)maxID
                    AndWithCount:(int)count ;
/** 文章信息_赞的人数
 请求参数	是否必须	说明
 a_id	必填参数	文章id
 page	选填参数	分页当前页码，默认为1
 count	选填参数	单页返回的记录条数，默认为50。
 */
+ (id)getPraisedInfoWithArticleID:(int)a_id
                   AndWithSinceID:(int)sinceID
                     AndWithMaxID:(int)maxID
                     AndWithCount:(int)count ;

/** 获取文章详情
 a_id  文章id
 */
+ (id)getArticleDetailWithArticleID:(int)a_id ;

+ (void)getArticleDetailWithArticleID:(int)a_id
                              Success:(void (^)(id json))success
                                 fail:(void (^)())fail ;


/** 文章详情_评论信息
 请求参数	是否必须	说明
 a_id	必填参数	文章id
 page	选填参数	分页当前页码，默认为1
 since_id	选填参数	若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0
 max_id	选填参数	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
 count	选填参数	单页返回的记录条数，默认为50。
 */
+ (id)getCommentWithArticleID:(int)a_id
               AndWithSinceID:(int)sinceID
                 AndWithMaxID:(int)maxID
                 AndWithCount:(int)count ;

#pragma mark -- 举报
/**
 请求参数	是否必须	说明
 r_type	必填参数	举报类型，1为文章，2为用户
 r_content	必填参数	举报内容，文章id或者用户id
 */
+ (void)reportWithType:(MODE_TYPE_REPORT)modeReport
             contentID:(int)aidOrUid
               success:(void (^)(id json))success
                  fail:(void (^)())fail ;

@end





