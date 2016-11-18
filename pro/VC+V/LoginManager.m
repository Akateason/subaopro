//
//  LoginManager.m
//  pro
//
//  Created by TuTu on 16/11/18.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "LoginManager.h"
#import "XTJson.h"
#import "YYModel.h"
#import "LoginCtrller.h"

static NSString * const kUser       = @"userCurrent" ;

@implementation LoginManager

+ (BOOL)hasLogin
{
    return ( [self userOnDevice] != nil ) ;
}

+ (UserPhone *)userOnDevice
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
    NSString *json = [defaults objectForKey:kUser] ;
    [defaults synchronize] ;
    if (!json) {
        return nil ;
    }
    UserPhone *auser = [UserPhone yy_modelWithJSON:[XTJson getJsonObj:json]] ;
    return auser ;
}

+ (void)cacheUser:(UserPhone *)user
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
    NSString *jsonStr = [user yy_modelToJSONString] ;
    [defaults setObject:jsonStr forKey:kUser] ;
}

+ (void)clean
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
    [defaults removeObjectForKey:kUser] ;
    [defaults synchronize];
    NSLog(@"defaults keys : %@",defaults.dictionaryRepresentation.allKeys) ;
}

+ (BOOL)goLogin:(UIViewController *)ctrller
{
    if ( ![self hasLogin] )
    {
        NSLog(@"未登录") ;
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil] ;
        LoginCtrller *logVC = [story instantiateViewControllerWithIdentifier:@"LoginCtrller"] ;
        logVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve ;
        UIWindow *currentwindow = [UIApplication sharedApplication].keyWindow ;
        logVC.screenShot = currentwindow ;
        [ctrller presentViewController:logVC
                              animated:YES
                            completion:nil] ;
        return false ;
    }
    else
    {
        return true ;
    }
    return false ;
}

@end
