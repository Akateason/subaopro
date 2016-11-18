//
//  LoginManager.h
//  pro
//
//  Created by TuTu on 16/11/18.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserPhone.h"

@interface LoginManager : NSObject

+ (BOOL)hasLogin ;

+ (UserPhone *)userOnDevice ;

+ (void)cacheUser:(UserPhone *)user ;

+ (void)clean ;

+ (BOOL)goLogin:(UIViewController *)ctrller ;

@end
