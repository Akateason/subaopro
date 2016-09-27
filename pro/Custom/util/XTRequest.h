//
//  AppDelegate.m
//  XTRequest
//
//  Created by TuTu on 15/11/12.
//  Copyright © 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultParsered.h"

#define TIMEOUT     10

typedef NS_ENUM(NSInteger, METHOD_REQUEST)
{
    GET_MODE  ,
    POST_MODE
} ;

@interface XTRequest : NSObject

+ (void)netWorkStatus ;

+ (void)GETWithUrl:(NSString *)url
        parameters:(NSDictionary *)dict
           success:(void (^)(id json))success
              fail:(void (^)())fail ;

+ (void)GETWithUrl:(NSString *)url
               hud:(BOOL)hud
        parameters:(NSDictionary *)dict
           success:(void (^)(id json))success
              fail:(void (^)())fail ;

+ (void)POSTWithUrl:(NSString *)url
         parameters:(NSDictionary *)dict
            success:(void (^)(id json))success
               fail:(void (^)())fail ;

+ (void)POSTWithUrl:(NSString *)url
                hud:(BOOL)hud
         parameters:(NSDictionary *)dict
            success:(void (^)(id json))success
               fail:(void (^)())fail ;

+ (id)getJsonObjWithURLstr:(NSString *)urlstr
            AndWithParamer:(NSDictionary *)dict
               AndWithMode:(METHOD_REQUEST)mode ;

+ (ResultParsered *)getResultParseredWithURLstr:(NSString *)urlstr
                                 AndWithParamer:(NSDictionary *)dict
                                    AndWithMode:(METHOD_REQUEST)mode ;

@end
