//
//  RootCtrl+ActionJumpToSubao.m
//  pro
//
//  Created by TuTu on 16/10/20.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "RootCtrl+ActionJumpToSubao.h"
#import "SIAlertView.h"

@implementation RootCtrl (ActionJumpToSubao)

static NSString *const kURL_appstore = @"itms://itunes.apple.com/cn/app/su-bao-jiang-ni-xiang-le-jie/id999705868?mt=8" ;

static NSString *const kSTR_TITLE    = @"想要发布我的速报" ;


- (void)jump2subaoAction
{
    NSLog(@"跳转") ;
    NSURL *url = [NSURL URLWithString:@"subao://"] ;
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        SIAlertView *alert = [[SIAlertView alloc] initWithTitle:nil andMessage:kSTR_TITLE] ;
        alert.positionStyle = SIALertViewPositionBottom ;
        [alert addButtonWithTitle:@"前往速报酱APP发布"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              [[UIApplication sharedApplication] openURL:url] ;
                          }] ;
        [alert addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                              
                          }] ;
        [alert show] ;

    }
    else {
        NSLog(@"根据App id打开App STORE") ;
        SIAlertView *alert = [[SIAlertView alloc] initWithTitle:nil andMessage:@"想要发布我的速报"] ;
        alert.positionStyle = SIALertViewPositionBottom ;
        [alert addButtonWithTitle:@"前往APPStore下载速报酱"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURL_appstore]] ;
                          }] ;
        [alert addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                              
                          }] ;
        [alert show] ;
    }
}

- (void)hidePostButton:(UIButton *)button
{
    [UIView animateWithDuration:0.35
                     animations:^{
                         button.alpha = 0.25 ;
                     }] ;
}

- (void)showPostButton:(UIButton *)button
{
    if (button.alpha != 1.0) {
        [UIView animateWithDuration:0.35
                         animations:^{
                             button.alpha = 1.0 ;
                         }] ;
    }
}






@end
