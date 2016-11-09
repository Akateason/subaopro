//
//  LoopInfoView.m
//  pro
//
//  Created by TuTu on 16/8/11.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "LoopInfoView.h"
#import "Content.h"
#import "Tag.h"
#import "UIImageView+QNExtention.h"

@interface LoopInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lb_Kind;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIView *backgroundWord;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w_kind;

@end

@implementation LoopInfoView

- (void)makeImageHidden:(BOOL)hidden
{
    if (self.imgView.hidden == hidden) return ;
    // .
    if (hidden == false) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ;
        dispatch_after(time, concurrentQueue, ^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imgView.hidden = hidden ;
            }) ;
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgView.hidden = hidden ;
        }) ;
    }
}

- (void)awakeFromNib
{
    self.backgroundColor            = [UIColor clearColor] ;
    self.lb_Kind.backgroundColor    = [UIColor xt_mainColor] ;
    self.lb_Kind.textColor          = [UIColor whiteColor] ;
    self.lb_Kind.layer.cornerRadius = 5. ;
    self.lb_Kind.layer.masksToBounds = YES ;
    self.imgView.backgroundColor    = [UIColor blackColor] ;
    self.backgroundWord.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.2] ;
}

- (void)setInfo:(id)info
{
    _info = info ;
    
    Content *aContent = info ;
    self.labelTitle.text = aContent.title ;
    self.lb_Kind.text =  aContent.kindName ;
    
    [self.imgView photoFromQiNiu:aContent.cover] ;
    
    UIFont *font = [UIFont systemFontOfSize:11.0f] ;
    CGSize size = CGSizeMake(200 ,18) ;
    CGSize labelsize = [aContent.kindName boundingRectWithSize:size
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    attributes:@{NSFontAttributeName:font}
                                                       context:nil].size ;
    _w_kind.constant = labelsize.width + 18. ;

    
}

@end
