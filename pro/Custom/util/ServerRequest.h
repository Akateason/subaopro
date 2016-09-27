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

#pragma mark -- 微猫 签名
/*ADD WEMART RSA SIGN*/
+ (ResultParsered *)getWemartRsaSignWithUserID:(NSString *)userID
                                         appID:(NSString *)appID ;


#pragma mark -- Qi Niu
/** 取七牛token
 bucket	必填参数	存储空间
 */
+ (void)getQiniuTokenWithBuckect:(NSString *)bucket
                         success:(void (^)(id json))success
                            fail:(void (^)())fail ;

+ (ResultParsered *)getQiniuTokenWithBuckect:(NSString *)bucket ;


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





