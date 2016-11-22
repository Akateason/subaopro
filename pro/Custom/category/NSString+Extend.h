//
//  NSString+Extend.h
//  SuBaoJiang
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)


// 去除收尾空格
- (NSString *)strMinusSpaceInPrefixAndTail ;

// 去除空格.
- (NSString *)minusSpaceStr ;

// \n
- (NSString *)minusReturnStr ;


// 算label大小
- (CGSize)calculateWithOverSize:(CGSize)overSize
                 systemFontSize:(CGFloat)fontNumber ;


+(NSString*)encodeString:(NSString*)unencodedString ;
-(NSString*)decodeString:(NSString*)encodedString ;


@end
