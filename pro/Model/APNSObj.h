//
//  APNSObj.h
//  pro
//
//  Created by TuTu on 16/11/14.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APNSObj : NSObject

@property (nonatomic,copy) NSString *alert ;
@property (nonatomic)      int      badge ;
@property (nonatomic,copy) NSString *sound ;

@end
