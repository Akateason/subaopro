





#import "DigitInformation.h"
#import "Reachability.h"
#import "YXSpritesLoadingView.h"
#import "NSObject+MKBlockTimer.h"
#import "ServerRequest.h"
#import "XTFileManager.h"
#import "CommonFunc.h"
#import "WXApi.h"

static dispatch_once_t onceToken ;
static DigitInformation *instance ;

@implementation DigitInformation

+ (DigitInformation *)shareInstance
{
    dispatch_once(&onceToken, ^{
        instance = [[DigitInformation alloc] init] ;
    }) ;
    return instance ;
}


#pragma mark --
#pragma mark - Setter

#pragma mark --
#pragma mark - Getter
//- (NSString *)g_token
//{
//    if (!_g_token)
//    {
//        NSString *homePath = NSHomeDirectory() ;
//        NSString *path     = [homePath stringByAppendingPathComponent:PATH_TOKEN_SAVE] ;
//        if ([XTFileManager is_file_exist:path])
//        {
//            NSString *token = [XTFileManager getObjUnarchivePath:path] ;
//            _g_token        = token ;
//            NSLog(@"token : %@",token) ;
//        }
//        else
//        {
//            NSLog(@"未登录") ;
//        }
//    }
//    
//    return _g_token ;
//}

/*
- (User *)g_currentUser
{
    if (!_g_currentUser) {
        ResultParsered *result = [ServerRequest getMyIndexPersonalInfo] ;
        if (!result) return nil ;
        _g_currentUser = [[User alloc] initWithDic:result.info] ;
    }
    
    return _g_currentUser ;
}
*/


#define KEY_UUID            @"uuid"

- (NSString *)uuid
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _uuid = [userDefaults objectForKey:KEY_UUID] ;
    if (!_uuid)
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        //    NSString *uuid = (NSString *)CFUUIDCreateString(kCFAllocatorDefault,uuidRef) ;
        _uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef)) ;
        CFRelease(uuidRef) ;
        [userDefaults setObject:_uuid forKey:KEY_UUID];
    }
    
    return _uuid ;
}


#define BUCKECT     @"social"
- (NSString *)token_QiNiuUpload
{
    ResultParsered *result = [ServerRequest getQiniuTokenWithBuckect:BUCKECT] ;
    if (!result.errCode)
    {
        // Success
        _token_QiNiuUpload = [result.info objectForKey:@"uptoken"] ;
    }
    else
    {
        // Fail
        return nil ;
    }
        
    return _token_QiNiuUpload ;
}

- (BOOL)appHasInstalledWX
{
    if (_appHasInstalledWX == TRUE) return _appHasInstalledWX ;
    
    _appHasInstalledWX = [WXApi isWXAppInstalled] ;
    return _appHasInstalledWX ;
}

@end


