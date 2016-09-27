//
//  DigitInformation.h
//  ParkingSys
//
//  Created by mini1 on 14-4-2.
//  Copyright (c) 2014年 mini1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

//#define G_TOKEN                     [DigitInformation shareInstance].g_token

#define DB                          [DigitInformation shareInstance].db

//#define G_USER                      [DigitInformation shareInstance].g_currentUser

@interface DigitInformation : NSObject

+ (DigitInformation *)shareInstance ;

#pragma mark --
// global token of current user
//@property (nonatomic,copy)      NSString        *g_token ;       //当前token

// global current user
//@property (nonatomic,strong)    User            *g_currentUser ; // 当前用户

// dataBase
@property (atomic,retain)       FMDatabase      *db;

// UUID
@property (nonatomic,copy)      NSString        *uuid ;

// QiniuToken
@property (nonatomic,copy)      NSString        *token_QiNiuUpload ;

// has weixin or not
@property (nonatomic)           BOOL            appHasInstalledWX ;


@end




