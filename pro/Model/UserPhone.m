//
//  UserPhone.m
//  pro
//
//  Created by TuTu on 16/11/18.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "UserPhone.h"

@implementation UserPhone

- (instancetype)initWithPhone:(NSString *)phone userId:(int)userId
{
    self = [super init];
    if (self)
    {
        self.phone = phone ;
        self.userId = userId ;
    }
    return self;
}

@end
