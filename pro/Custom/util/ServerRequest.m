//
//  ServerRequest.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ServerRequest.h"
#import "XTRequest.h"
#import "UrlRequestHeader.h"
#import "DigitInformation.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "CommonFunc.h"

@implementation ServerRequest

/** 获取首页
 since_id	选填参数	若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0
 max_id     选填参数	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
 count      选填参数	单页返回的记录条数，默认为50。
 */
+ (id)getHomePageInfoResultWithSinceID:(int)sinceID
                              AndMaxID:(long long)maxID
                              AndCount:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithLongLong:maxID]
                forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:sinceID]
                forKey:@"since_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;
    
    return [self getJsonObjWithURLstr:URL_SBJ_INDEX_TIMELINE
                       AndWithParamer:paramer
                          AndWithMode:GET_MODE] ;
}




#pragma mark - 一直播 直播列表
+ (void)yzb_hotliveListWithSDKID:(NSString *)sdkid
                            time:(long long)time
                            sign:(NSString *)sign
                            page:(int)page
                           limit:(int)limit
                         success:(void (^)(id json))success
                            fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:sdkid forKey:@"sdkid"] ;
    [paramer setObject:@(time) forKey:@"time"] ;
    [paramer setObject:sign forKey:@"sign"] ;
    [paramer setObject:@(page) forKey:@"page"] ;
    [paramer setObject:@(limit) forKey:@"limit"] ;

    [XTRequest POSTWithUrl:URL_YZB_LIST
                parameters:paramer
                   success:^(id json) {
                       if (success) success (json) ;
                   } fail:^{
                       if (fail) fail() ;
                   }] ;
}

+ (id)yzb_hotliveListWithSDKID:(NSString *)sdkid
                          time:(long long)time
                          sign:(NSString *)sign
                          page:(int)page
                         limit:(int)limit
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:sdkid forKey:@"sdkid"] ;
    [paramer setObject:@(time) forKey:@"time"] ;
    [paramer setObject:sign forKey:@"sign"] ;
    [paramer setObject:@(page) forKey:@"page"] ;
    [paramer setObject:@(limit) forKey:@"limit"] ;
    
    return [self getJsonObjWithURLstr:URL_YZB_LIST
                       AndWithParamer:paramer
                          AndWithMode:POST_MODE] ;
}


#pragma mark --
#pragma mark - 获取类型 列表 .                        i/h
+ (void)getAllKindListSuccess:(void (^)(id json))success
                         fail:(void (^)())fail
{
    [XTRequest GETWithUrl:[self getFinalUrl:URL_KIND_ALL]
               parameters:nil
                  success:^(id json) {
                      if (success) success (json) ;
                  } fail:^{
                      if (fail) fail() ;
                  }] ;
}

+ (ResultParsered *)getAllKindList
{
    return [self getResultParseredWithURLstr:[self getFinalUrl:URL_KIND_ALL] AndWithParamer:nil AndWithMode:GET_MODE] ;
}


#pragma mark - 获取内容列表     app                      i/h (全部返回)
+ (void)getContentListWithKindID:(int)kindID
                        sendtime:(long long)sendtimeTick
                            size:(int)size
                         success:(void (^)(id json))success
                            fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:@(kindID) forKey:@"kind"] ;
    [paramer setObject:@(sendtimeTick) forKey:@"sendtime"] ;
    [paramer setObject:@(size) forKey:@"size"] ;
    
    [XTRequest POSTWithUrl:[self getFinalUrl:URL_CONTENT_ALIST]
               parameters:paramer
                  success:^(id json) {
                      if (success) success (json) ;
                  } fail:^{
                      if (fail) fail() ;
                  }] ;
}


#pragma mark - 获取内容详情                            i/hP : 内容id .
+ (void)getContentDetailWithContentID:(int)contentID
                              success:(void (^)(id json))success
                                 fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:@(contentID) forKey:@"contentId"] ;
    
    [XTRequest GETWithUrl:[self getFinalUrl:URL_CONTENT_DETAIL]
               parameters:paramer
                  success:^(id json) {
                      if (success) success (json) ;
                  } fail:^{
                      if (fail) fail() ;
                  }] ;
    
}


#pragma mark - 按标题搜索 获取内容列表
+ (void)searchContentsByTitle:(NSString *)title
                      success:(void (^)(id json))success
                         fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:title forKey:@"keyword"] ;
    
    [XTRequest GETWithUrl:[self getFinalUrl:URL_SEARCH_BY_TITLE]
               parameters:paramer
                  success:^(id json) {
                      if (success) success (json) ;

                  } fail:^{
                      if (fail) fail() ;

                  }] ;
}


#pragma mark - 按标签搜索 获取内容列表          i/h
+ (void)searchContentByTag:(NSString *)tag
                   success:(void (^)(id json))success
                      fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:tag forKey:@"keyword"] ;
    
    [XTRequest GETWithUrl:[self getFinalUrl:URL_SEARCH_BY_TAG]
               parameters:paramer
                  success:^(id json) {
                      if (success) success (json) ;
                  } fail:^{
                      if (fail) fail() ;
                  }] ;
    
}

#pragma mark - 标签 模糊搜索  返回列表            h
+ (void)tagSearchByWord:(NSString *)word
                success:(void (^)(id json))success
                   fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:word forKey:@"word"] ;
    
    [XTRequest GETWithUrl:[self getFinalUrl:URL_TAG_SEARCH]
               parameters:paramer
                  success:^(id json) {
                      if (success) success (json) ;
                  } fail:^{
                      if (fail) fail() ;
                  }] ;

}

#pragma mark - 增加阅读数
+ (void)addReadWithContentID:(int)contentID
                     success:(void (^)(id json))success
                        fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:@(contentID) forKey:@"contentId"] ;
    
    [XTRequest GETWithUrl:[self getFinalUrl:URL_ADD_READ]
               parameters:paramer
                  success:^(id json) {
                      if (success) success (json) ;
                  } fail:^{
                      if (fail) fail() ;
                  }] ;
}



#pragma mark - 首页
/** 标签颜色
 */
+ (id)getCateTypeColor
{
     id jsonObj = [self getJsonObjWithURLstr:URL_CATE_COLOR
                    AndWithParamer:nil
                       AndWithMode:GET_MODE] ;        
    return jsonObj ;
}

//获取他人主页
+ (id)getOtherHomePageWithUserID:(int)uid
                    AndWithMaxID:(int)maxID
                    AndWithCount:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:@0 forKey:@"token"] ;
    [paramer setObject:[NSNumber numberWithInt:uid]
                forKey:@"u_id"] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]
                forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]
                forKey:@"count"] ;
    
    return [self getJsonObjWithURLstr:URL_OTHER_HOMEPAGE AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

/** 文章信息_赞的人数
 请求参数	是否必须	说明
 a_id	必填参数	文章id
 page	选填参数	分页当前页码，默认为1
 count	选填参数	单页返回的记录条数，默认为50。
 */
+ (id)getPraisedInfoWithArticleID:(int)a_id
                                 AndWithSinceID:(int)sinceID
                                   AndWithMaxID:(int)maxID
                                   AndWithCount:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:@0 forKey:@"token"] ;
    [paramer setObject:[NSNumber numberWithInt:a_id]    forKey:@"a_id"] ;
    [paramer setObject:[NSNumber numberWithInt:sinceID] forKey:@"since_id"] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]   forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]   forKey:@"count"] ;
    
    return [self getJsonObjWithURLstr:URL_DETAIL_PRAISE AndWithParamer:paramer AndWithMode:GET_MODE] ;
}


/** 获取文章详情
 a_id  文章id
 */
+ (id)getArticleDetailWithArticleID:(int)a_id
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:a_id]   forKey:@"a_id"] ;
    [paramer setObject:@0 forKey:@"token"] ;
    
    return [self getJsonObjWithURLstr:URL_ARTICLE_DETAIL AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

+ (void)getArticleDetailWithArticleID:(int)a_id
                              Success:(void (^)(id json))success
                                 fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:[NSNumber numberWithInt:a_id]   forKey:@"a_id"] ;
    [paramer setObject:@0 forKey:@"token"] ;

    [XTRequest GETWithUrl:URL_ARTICLE_DETAIL parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}

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
                 AndWithCount:(int)count
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:@0 forKey:@"token"] ;
    [paramer setObject:[NSNumber numberWithInt:a_id]    forKey:@"a_id"] ;
    [paramer setObject:[NSNumber numberWithInt:sinceID] forKey:@"since_id"] ;
    [paramer setObject:[NSNumber numberWithInt:maxID]   forKey:@"max_id"] ;
    [paramer setObject:[NSNumber numberWithInt:count]   forKey:@"count"] ;
    
    return [self getJsonObjWithURLstr:URL_GET_COMMENT AndWithParamer:paramer AndWithMode:GET_MODE] ;
}

#pragma mark -- 举报
/**
 请求参数	是否必须	说明
 r_type	必填参数	举报类型，1为文章，2为用户
 r_content	必填参数	举报内容，文章id或者用户id
 */
+ (void)reportWithType:(MODE_TYPE_REPORT)modeReport
             contentID:(int)aidOrUid
               success:(void (^)(id json))success
                  fail:(void (^)())fail
{
    NSMutableDictionary *paramer = [self getParameters] ;
    [paramer setObject:@0 forKey:@"token"] ;
    [paramer setObject:[NSNumber numberWithInt:(int)modeReport]
                forKey:@"r_type"] ;
    [paramer setObject:[NSNumber numberWithInt:aidOrUid]
                forKey:@"r_content"] ;
    
    [XTRequest POSTWithUrl:URL_REPORT parameters:paramer success:^(id json) {
        if (success) success(json);
    } fail:^{
        if (fail) fail();
    }] ;
}


#pragma mark - PRIVATE
+ (NSString *)getFinalUrl:(NSString *)urlstr
{
    NSString *str = [G_IP_SERVER stringByAppendingString:urlstr] ;
    return str ;
}

+ (NSMutableDictionary *)getParameters
{
    return [NSMutableDictionary dictionary] ;
}

@end
