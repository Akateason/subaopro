//
//  ResultSBJ.m
//  pro
//
//  Created by TuTu on 16/9/30.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "ResultSBJ.h"

@implementation ResultSBJ

- (instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _errCode = [[dict objectForKey:@"err_code"] intValue] ;
        
//        if (_errCode == 10002)
//        {
//            // token失效
//            [CommonFunc exitLog] ;
//        }
        
        _message = [dict objectForKey:@"message"] ;
        _info    = [dict objectForKey:@"info"] ;
    }
    
    return self;
}

@end
