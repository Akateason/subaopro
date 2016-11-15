//
//  AppDelegateInitial.m
//  GroupBuying
//
//  Created by TuTu on 15/12/24.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "AppDelegateInitial.h"
#import "KeyChainHeader.h"
#import "DigitInformation.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "UMMobClick/MobClick.h"

NSString *const UM_APPKEY       = @"582ac38dc62dca40fc000d1f" ;

NSString *const WX_APPKEY       = @"wxcfc0cac5ea95bff5" ;
//NSString *const WX_APPSECRET    = @"d4624c36b6795d1d99dcf0547af5443d" ;

NSString *const WB_APPKEY       = @"1588912701" ;
NSString *const WB_APPSECRET    = @"e4487f8fd3ef1fcaca1d4c1315e7a5af" ;
NSString *const WB_REDIRECTURL  = @"https://api.weibo.com/oauth2/default.html" ;

//
NSString *const APPSTORE_APPID  = @"999705868" ;

@interface AppDelegateInitial ()

@property (nonatomic,strong) NSDictionary *launchOptions ;
@property (nonatomic,strong) UIApplication *application ;
@property (nonatomic,strong) UIWindow *window ;

@end

@implementation AppDelegateInitial

- (instancetype)initWithApplication:(UIApplication *)application
                            options:(NSDictionary *)launchOptions
                             window:(UIWindow *)window
{
    self = [super init];
    if (self)
    {
        self.application = application ;
        self.launchOptions = launchOptions ;
        self.window = window ;
        [self setup] ;
    }
    return self;
}

- (void)setup
{
    [self configureStyle] ;
    
    [self configureWeixin] ;
    
    [self configureWeibo] ;
    
    [self configureUmeng] ;
}


- (void)configureStyle
{
    //1 status bar .
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;

    [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor xt_mainColor] ;
    
    //2 nav style .
    [[UINavigationBar appearance] setBarTintColor:[UIColor xt_mainColor]] ;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}] ;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]] ;
    [[UINavigationBar appearance] setBackgroundColor:[UIColor xt_mainColor]] ;
}

- (void)configureWeixin
{
    //  wx register
    [WXApi registerApp:WX_APPKEY] ;
}

- (void)configureWeibo
{
    //  wb
    [WeiboSDK enableDebugMode:YES] ;
    [WeiboSDK registerApp:WB_APPKEY] ;
}

- (void)configureUmeng
{
    // umeng stat
    UMConfigInstance.appKey = UM_APPKEY ;
    [MobClick startWithConfigure:UMConfigInstance];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ;
    [MobClick setAppVersion:version] ;
}


@end
