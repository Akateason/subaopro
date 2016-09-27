//
//  YzbListItem.h
//  pro
//
//  Created by TuTu on 16/9/19.
//  Copyright © 2016年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Content ;

@interface YzbListItem : NSObject

@property (nonatomic,copy) NSString     *scid ;
@property (nonatomic)      long         memberid ;
@property (nonatomic,copy) NSString     *title ;
@property (nonatomic,copy) NSString     *address ;
@property (nonatomic)      long long    starttime ;
@property (nonatomic)      int          status ;
@property (nonatomic,copy) NSString         *playurl ;
@property (nonatomic,strong)NSDictionary     *covers ; // s , m , b
@property (nonatomic)      NSInteger    online ;
@property (nonatomic,copy) NSString     *nickname ;
@property (nonatomic,copy) NSString     *avatar ;
@property (nonatomic,copy) NSString     *ytypename ;
@property (nonatomic)      NSInteger    ytypevt ;

- (Content *)convertToContent ;

@end

