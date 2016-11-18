//
//  AppDelegate.m
//  GroupBuying
//
//  Created by TuTu on 15/12/23.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegateInitial.h"
#import "ServerRequest.h"
#import "ShareUtils.h"
#import "SIAlertView.h"
#import "APNSObj.h"
#import "YYModel.h"

@interface AppDelegate () <WXApiDelegate>
@property (nonatomic,strong) ShareUtils *shareutils ;
@end

@implementation AppDelegate

- (ShareUtils *)shareutils
{
    if (!_shareutils) {
        _shareutils = [[ShareUtils alloc] init] ;
    }
    return _shareutils ;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AppDelegateInitial *ap = [[AppDelegateInitial alloc] initWithApplication:application
                                                                     options:launchOptions
                                                                      window:self.window] ;
    [ap doConfigures] ;
    
    return YES ;
}

- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    return [self.shareutils handleOpenUrl:url] ;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                        stringByReplacingOccurrencesOfString: @">" withString: @""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    NSLog(@"deviceToken: %@",token) ;
    [ServerRequest registerDeviceToken:token
                               success:^(id json) {
                                   
                               } fail:^{
                                   
                               }] ;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

//处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //在此处理接收到的消息。
    int badge = (int)[UIApplication sharedApplication].applicationIconBadgeNumber ;
    if (badge > 0) {
        //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0 ;
    }
    
    if (userInfo) {
        // 有推送的消息，处理推送的消息
        NSLog(@"userInfo : %@",userInfo) ;
        APNSObj *aps = [APNSObj yy_modelWithJSON:userInfo[@"aps"]] ;
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            // 只有app在前台 . 才做显示alert.
            SIAlertView *alert = [[SIAlertView alloc] initWithTitle:nil andMessage:aps.alert] ;
            [alert addButtonWithTitle:@"好的,我知道了"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alertView) {}] ;
            [alert addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeCancel
                              handler:nil] ;
            [alert show] ;
        }
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler
{
    // 在此方法中一定要调用completionHandler这个回调，告诉系统是否处理成功
    //    UIBackgroundFetchResultNewData, // 成功接收到数据
    //    UIBackgroundFetchResultNoData,  // 没有接收到数据
    //    UIBackgroundFetchResultFailed   // 接受失败
    if (userInfo) {
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}








- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
