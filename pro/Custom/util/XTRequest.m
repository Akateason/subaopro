//
//  AppDelegate.m
//  XTRequest
//
//  Created by TuTu on 15/11/12.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "XTRequest.h"
#import "AFNetworking.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "YYModel.h"

#define ACCEPTABLE_CONTENT_TYPES        @"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain"


@implementation XTRequest

+ (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"网络状态 : %@", @(status)) ;
    }];
}

+ (void)GETWithUrl:(NSString *)url
        parameters:(NSDictionary *)dict
           success:(void (^)(id json))success
              fail:(void (^)())fail
{
    [self GETWithUrl:url hud:NO parameters:dict success:success fail:fail] ;
}

+ (void)GETWithUrl:(NSString *)url
               hud:(BOOL)hud
        parameters:(NSDictionary *)dict
           success:(void (^)(id json))success
              fail:(void (^)())fail
{
    UIView *view = [UIApplication sharedApplication].delegate.window ;
    if (hud) {
        [MBProgressHUD showHUDAddedTo:view animated:NO] ;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT ;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:ACCEPTABLE_CONTENT_TYPES,nil];//设置相应内容类型
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSLog(@"url : %@ \nparam : %@",url,dict) ;
            NSLog(@"resp %@",responseObject) ;
            success(responseObject);
            if (hud) {
                [MBProgressHUD hideAllHUDsForView:view animated:NO] ;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@", error);
        if (fail) {
            fail();
            if (hud) {
                [MBProgressHUD hideAllHUDsForView:view animated:NO] ;
            }
        }
    }] ;
}

+ (void)POSTWithUrl:(NSString *)url
                hud:(BOOL)hud
         parameters:(NSDictionary *)dict
            success:(void (^)(id json))success
               fail:(void (^)())fail
{
    UIView *view = [UIApplication sharedApplication].delegate.window ;
    if (hud) {
        [MBProgressHUD showHUDAddedTo:view animated:NO] ;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:ACCEPTABLE_CONTENT_TYPES, nil];//设置相应内容类型
    manager.requestSerializer.timeoutInterval = TIMEOUT ;

    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSLog(@"url : %@ \nparam : %@",url,dict) ;
            NSLog(@"resp %@",responseObject) ;
            success(responseObject);
            if (hud) {
                [MBProgressHUD hideAllHUDsForView:view animated:NO] ;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (fail) {
            fail();
            if (hud) {
                [MBProgressHUD hideAllHUDsForView:view animated:NO] ;
            }
        }
    }];

}

+ (void)POSTWithUrl:(NSString *)url
         parameters:(NSDictionary *)dict
            success:(void (^)(id json))success
               fail:(void (^)())fail
{
    [self POSTWithUrl:url hud:NO parameters:dict success:success fail:fail] ;
}


+ (id)getJsonObjWithURLstr:(NSString *)urlstr
            AndWithParamer:(NSDictionary *)dict
               AndWithMode:(METHOD_REQUEST)mode
{
    
    if (mode == GET_MODE) {
        
        NSString *apStr = [self getUrlInGetModeWithDic:dict] ;
        urlstr = [urlstr stringByAppendingString:apStr] ;
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlstr]];
        request.timeOutSeconds = TIMEOUT ;
        [request startSynchronous];
        NSError *error = [request error];
        NSString *response;
        if ( error )
        {
            NSLog(@"error:%@",error);
            return nil ;
        }
        
        response = [request responseString] ;
        
        //        NSLog(@"urlstr : %@\n%@",urlstr,response)  ;
        NSLog(@"urlstr : %@\n",urlstr)  ;
        NSLog(@"response : %@\n",response)  ;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil] ;
        return jsonObj ;
    }
    else if (mode == POST_MODE) {
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlstr]];
        request.timeOutSeconds = TIMEOUT ;
        
        NSArray *allKeys = [dict allKeys] ;
        for (NSString *key in allKeys)
        {
            NSString *val = [dict objectForKey:key] ;
            [request setPostValue:val forKey:key] ;
        }
        
        [request startSynchronous]                  ;
        
        NSError *error = [request error]            ;
        NSString *response                          ;
        
        if ( error )
        {
            NSLog(@"error:%@",error);
            return nil ;
        }
        response = [request responseString]         ;
        
        //        NSLog(@"urlstr : %@\n%@",urlstr,response)   ;
        NSLog(@"urlstr : %@\n",urlstr)  ;
        NSLog(@"response : %@\n",response)  ;
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil] ;
        return jsonObj ;
    }
    
    
    return nil ;
}

+ (ResultParsered *)getResultParseredWithURLstr:(NSString *)urlstr
                                 AndWithParamer:(NSDictionary *)dict
                                    AndWithMode:(METHOD_REQUEST)mode
{
    id jsonObj = [self getJsonObjWithURLstr:urlstr AndWithParamer:dict AndWithMode:mode] ;
    ResultParsered *result = [ResultParsered yy_modelWithJSON:jsonObj] ;
    return result ;
}


+ (NSString *)getUrlInGetModeWithDic:(NSDictionary *)dict
{
    NSArray *allKeys = [dict allKeys] ;
    BOOL bFirst = YES ;
    NSString *appendingStr = @"" ;
    for (NSString *key in allKeys)
    {
        NSString *val = [dict objectForKey:key] ;
        NSString *item = @"";
        if (bFirst) {
            bFirst = NO ;
            item = [NSString stringWithFormat:@"?&%@=%@",key,val] ; //因特殊需求而改动
        }
        else
        {
            item = [NSString stringWithFormat:@"&%@=%@",key,val] ;
        }
        
        appendingStr = [appendingStr stringByAppendingString:item] ;
    }
    
    return appendingStr ;
}



@end
