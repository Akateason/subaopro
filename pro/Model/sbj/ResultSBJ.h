//
//  ResultSBJ.h
//  pro
//
//  Created by TuTu on 16/9/30.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultSBJ : NSObject

@property (nonatomic)           NSInteger       errCode     ;
@property (nonatomic,copy)      NSString        *message    ;
@property (nonatomic,strong)    NSDictionary    *info       ;

- (instancetype)initWithDic:(NSDictionary *)dict            ;

@end
