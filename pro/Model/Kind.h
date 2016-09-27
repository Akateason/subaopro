//
//  Kind.h
//  pro
//
//  Created by TuTu on 16/8/26.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Kind : NSObject

@property (nonatomic)       int         kindId ;
@property (nonatomic,copy)  NSString    *name ;
@property (nonatomic)       int         order ;     //分类排列的顺序. 从0开始递增

@end
