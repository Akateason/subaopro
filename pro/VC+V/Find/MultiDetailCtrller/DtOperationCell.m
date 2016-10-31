//
//  DtOperationCell.m
//  subao
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "DtOperationCell.h"
#import "WPHotspotLabel.h"
#import "UserHeadCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "ArticleTopic.h"
#import "ArticleComment.h"
#import "Article.h"
#import "ArticlePraise.h"
#import "DigitInformation.h"
#import "ServerRequest.h"
#import "DetailSubaoCtrller+AnimationManager.h"
#import "User.h"

@interface DtOperationCell () <UICollectionViewDataSource,UICollectionViewDelegate,ArticleDelegate>
//UIs
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UILabel *lb_countOfCmtAndPraise;
@property (weak, nonatomic) IBOutlet WPHotspotLabel *lb_topicsAndContent;
@property (weak, nonatomic) IBOutlet UIButton *bt_like;
@property (weak, nonatomic) IBOutlet UIButton *bt_more;
@property (weak, nonatomic) IBOutlet UIButton *bt_share;
@property (weak, nonatomic) IBOutlet UIButton *bt_delete; // 删除 or 举报
@property (weak, nonatomic) IBOutlet UICollectionView *collection_praisers;
//Attrs
@property (nonatomic,strong)         NSMutableArray *praiseList ;
@property (nonatomic)                BOOL           bMyArticle;

@end

@implementation DtOperationCell


#pragma mark - ArticleDelegate
- (void)topicHotPotClicked
{
//    [self.delegate topicSelected:[[self.superArticle articleTopicList] firstObject]] ;
}

- (void)setup
{
    self.contentView.backgroundColor = COLOR_BACKGROUND ;
    // hide share to check AppStore
//    _bt_share.hidden = !G_BOOL_OPEN_APPSTORE ;
    _bt_share.hidden = false ;
    _bt_delete.hidden = true ;
    //
    [self praiseList] ;
    _collection_praisers.delegate = self ;
    _collection_praisers.dataSource = self ;
    _collection_praisers.backgroundColor = nil ;
    _collection_praisers.scrollEnabled = NO ;
    
    
}

- (void)awakeFromNib
{
    // Initialization code
    [self setup] ;
}

#pragma mark --
#pragma mark - Actions
- (IBAction)likeButtonClickAction:(id)sender
{
    
    [self.delegate hasPraised:!_bt_like.selected] ;
}

// from client
- (void)getNewPraiseWithisLiked:(BOOL)isLiked
                          delay:(float)delayTime
{
    _bt_like.selected = isLiked ;
    
//    __block BOOL bHasPraiseYet = NO ;
//    [self.praiseList enumerateObjectsUsingBlock:^(ArticlePraise *praise, NSUInteger idx, BOOL * _Nonnull stop)
//     {
//         if (praise.user.u_id == G_USER.u_id)
//         {
//             bHasPraiseYet = YES ;
//             if (!isLiked) {
//                 [self.praiseList removeObjectAtIndex:idx] ;
//             }
//             *stop = YES ;
//         }
//     }] ;
//    
//    if (!bHasPraiseYet && isLiked)
//    {
//        ArticlePraise *praiseWillAdd = [[ArticlePraise alloc] initByOwner] ;
//        [self.praiseList insertObject:praiseWillAdd atIndex:0] ;
//    }
//    
//    isLiked ? _superArticle.praiseCount ++ : _superArticle.praiseCount -- ;
//    
//    _lb_countOfCmtAndPraise.attributedText = [self.superArticle getAttributeStrCmtCountRplyCount];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.collection_praisers reloadData] ;
//    }) ;
    
}

- (IBAction)moreButtonClickAction:(id)sender
{
    [self.delegate moreLikersPressedWithArticleID:self.superArticle.a_id] ;
}

- (IBAction)shareButtonClickAction:(id)sender
{
    _bt_share.highlighted = NO ;

    [self.delegate clickShareCallBack] ;
}

- (IBAction)shareButtonTouchDown:(id)sender
{
    _bt_share.highlighted = YES ;
}

- (IBAction)deleteButtonClickAction:(id)sender
{
    _bt_delete.highlighted = NO ;

    if (self.bMyArticle) {
        [self.delegate deleteMyArticle] ;
    }
    else {
        [self.delegate reportCallBack] ;
    }
}

- (IBAction)deleteButtonTouchDown:(id)sender
{
    _bt_delete.highlighted = YES ;
}

#pragma mark --
#pragma mark - prop
- (void)setSuperArticle:(Article *)superArticle
{
    _superArticle = superArticle ;
    //article delegate
    _superArticle.delegate = self ;
    
    //hide
    _lb_countOfCmtAndPraise.hidden = !superArticle.a_id ;
//    _bt_delete.hidden = !superArticle.a_id ;
//    _bt_share.hidden = !superArticle.a_id || !G_BOOL_OPEN_APPSTORE ;
    _bt_like.hidden = !superArticle.a_id ;
    _bt_more.hidden = !superArticle.a_id  ;
    if (!superArticle.a_id)
    {
        _lb_topicsAndContent.text = @"" ;
        return ;
    }
    
    //top line
    _topLine.hidden = ![superArticle isMultyStyle] ;
    
    //praiselist
    self.praiseList = [NSMutableArray arrayWithArray:superArticle.praiseList] ;
    
    //like
    _bt_like.selected = superArticle.has_praised ;
    
    //comt count like count
    _lb_countOfCmtAndPraise.attributedText = [superArticle getAttributeStrCmtCountRplyCount];
    
    //comment content
    _lb_topicsAndContent.attributedText = [superArticle isMultyStyle] ? [superArticle getAttributeStrOnlyTopics] : [superArticle getAttributeStrCommentContent];
     
    //praise reload
    _bt_more.hidden = !superArticle.praiseCount ;
    if (superArticle.praiseCount) [_collection_praisers reloadData] ;
    
    //delete my article BUTTON And Report BUTTON
    if (!self.bMyArticle)
    {//举报
        [_bt_delete setImage:[UIImage imageNamed:@"report_default"]
                    forState:UIControlStateNormal] ;
        [_bt_delete setImage:[UIImage imageNamed:@"report_highlight"]
                    forState:UIControlStateHighlighted] ;
    }
    else
    {//删除
        [_bt_delete setImage:[UIImage imageNamed:@"deleteNomal"]
                    forState:UIControlStateNormal] ;
        [_bt_delete setImage:[UIImage imageNamed:@"deleteHighlight"]
                    forState:UIControlStateHighlighted] ;
    }
}

- (NSMutableArray *)praiseList
{
    if (!_praiseList) {
        _praiseList = [NSMutableArray array] ;
    }
    
    return _praiseList ;
}

- (BOOL)bMyArticle
{
    return false ;
//    return (G_USER.u_id == self.superArticle.userCurrent.u_id) ;
}

#pragma mark --
#pragma mark - collection dataSourse
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.praiseList count] ; // 限制数量
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up the reuse identifier
    UINib *nib = [UINib nibWithNibName:@"UserHeadCollectionCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"UserHeadCollectionCell"];
    // Set up the reuse identifier
    UserHeadCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserHeadCollectionCell" forIndexPath:indexPath] ;
    // load the image for this cell
    cell.praise = self.praiseList[indexPath.row] ;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int u_id = ((ArticlePraise *)self.praiseList[indexPath.row]).user.u_id ;
    [self.delegate clickUserHead:u_id] ;
}

#pragma mark --
- (CGFloat)calculateHeightWithCmtStr:(NSString *)cmtStr
{
    CGFloat orgHeight = 25.0f ;
    UIFont *font = [UIFont systemFontOfSize:16.0f] ;
    CGSize size = CGSizeMake(APPFRAME.size.width - 13.0 * 2, 300) ;
    CGSize labelsize = [cmtStr boundingRectWithSize:size
                                         options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil].size ;
    CGFloat wordH = labelsize.height ;
    if (wordH < orgHeight) {
        wordH = orgHeight ;
    }
    if (UNDER_IOS_VERSION(7.1)) {
        orgHeight += 5.0 ;
    }
    return 126.0f - orgHeight + wordH ;
}

+ (CGFloat)calculateHeightWithCmtStr:(NSString *)cmtStr
{
    CGFloat orgHeight = 25.0f ;
    UIFont *font = [UIFont systemFontOfSize:16.0f] ;
    CGSize size = CGSizeMake(APPFRAME.size.width - 13.0 * 2, 300) ;
    CGSize labelsize = [cmtStr boundingRectWithSize:size
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:font}
                                            context:nil].size ;
    CGFloat wordH = labelsize.height ;
    if (wordH < orgHeight) {
        wordH = orgHeight ;
    }
    if (UNDER_IOS_VERSION(7.1)) {
        orgHeight += 5.0 ;
    }
    return 126.0f - orgHeight + wordH ;
}


- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, [self calculateHeightWithCmtStr:[self.superArticle isMultyStyle] ? [self.superArticle getTopicStr] : [self.superArticle getStrCommentContent]]) ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
