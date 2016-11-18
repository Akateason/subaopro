//
//  UserPhone.h
//  pro
//
//  Created by TuTu on 16/11/18.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPhone : NSObject

@property (nonatomic) int userId ;
@property (nonatomic,copy) NSString *phone ;

- (instancetype)initWithPhone:(NSString *)phone
                       userId:(int)userId ;

@end
