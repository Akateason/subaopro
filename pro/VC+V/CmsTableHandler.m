
//
//  CmsTableHandler.m
//  pro
//
//  Created by TuTu on 16/8/8.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "CmsTableHandler.h"
#import "NormalContentCell.h"
#import "BannerCell.h"
#import "BigImgContentCell.h"
#import "MultiPictureContentCell.h"
#import "RootTableView.h" 
#import "CenterTableView.h"
#import "ServerRequest.h"
#import "Kind.h"
#import "Content.h"
#import "YYModel.h"

static int const kPageSize = 20 ;

@interface CmsTableHandler () <RootTableViewDelegate,BannerCellDelegate>
{
    UITableView *m_table ;
}
@property (nonatomic,strong) NSMutableArray     *dataList ;
@property (nonatomic,strong) NSMutableArray     *topList ;
@property (nonatomic,strong) NSMutableArray     *slideList ;
@property (nonatomic,strong) dispatch_queue_t   myQueue ;

@property (nonatomic,strong) Kind *kind ;

@end

@implementation CmsTableHandler
@synthesize dataList = _dataList ,
            topList = _topList ,
            slideList = _slideList ;


#pragma mark - life
- (void)dealloc
{
    _dataList = nil ;
    _topList = nil ;
    _slideList = nil ;
}

- (instancetype)initWithKind:(Kind *)kind
{
    self = [super init];
    if (self)
    {
        self.kind = kind ;
    }
    return self;
}

#pragma mark - public func
- (BOOL)hasDataSource
{
    BOOL dataNotNull = _dataList != nil && _topList != nil && _slideList != nil ;
    BOOL dataHasCount = _dataList.count || _topList.count || _slideList.count ;
    return dataNotNull && dataHasCount ;
}

#pragma mark - prop
- (dispatch_queue_t)myQueue
{
    if (!_myQueue) {
        _myQueue = dispatch_queue_create("mySyncQueue", DISPATCH_QUEUE_CONCURRENT) ;
    }
    return _myQueue ;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [@[] mutableCopy] ;
    }
    return _dataList ;
    
    __block NSMutableArray *list ;
    dispatch_sync(self.myQueue, ^{
        list = _dataList ;
    }) ;
    return list ;
}

- (void)setDataList:(NSMutableArray *)dataList
{
    dispatch_barrier_async(self.myQueue, ^{
        _dataList = dataList ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_table reloadData] ;
        }) ;
    }) ;
}

- (NSMutableArray *)topList
{
    if (!_topList) {
        _topList = [@[] mutableCopy] ;
    }
    return _topList ;
    
    __block NSMutableArray *list ;
    dispatch_sync(self.myQueue, ^{
        list = _topList ;
    }) ;
    return list ;
}

- (void)setTopList:(NSMutableArray *)topList
{
    dispatch_barrier_async(self.myQueue, ^{
        _topList = topList ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_table reloadData] ;
        }) ;
    }) ;
}

- (NSMutableArray *)slideList
{
    if (!_slideList) {
        _slideList = [@[] mutableCopy] ;
    }
    return _slideList ;
    
    __block NSMutableArray *list ;
    dispatch_sync(self.myQueue, ^{
        list = _slideList ;
    }) ;
    return list ;
}

- (void)setSlideList:(NSMutableArray *)slideList
{
    dispatch_barrier_async(self.myQueue, ^{
        _slideList = slideList ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_table reloadData] ;
        }) ;
    }) ;
}


#pragma mark - RootTableViewDelegate
- (void)loadNewData:(UITableView *)table
{
    m_table = table ;
    
    NSMutableArray*tmpList_data = [@[] mutableCopy] ;
    NSMutableArray*tmpList_slide = [@[] mutableCopy] ;
    NSMutableArray*tmpList_top = [@[] mutableCopy] ;
    
    [ServerRequest getContentListWithKindID:self.kind.kindId
                                   sendtime:0
                                       size:kPageSize
                                    success:^(id json) {
                                        
                                        ResultParsered *result = [ResultParsered yy_modelWithJSON:json] ;
                                        if (result.errCode == 1001)
                                        {
                                            NSDictionary *retDic = result.info ;
                                            NSArray *retlist = retDic[@"list"] ;
                                            NSArray *retSlide = retDic[@"slide"] ;
                                            NSArray *retTop = retDic[@"top"] ;
                                            for (NSDictionary *dic in retlist) {
                                                Content *aContent = [Content yy_modelWithJSON:dic] ;
                                                [tmpList_data addObject:aContent] ;
                                            }
                                            for (NSDictionary *dic in retSlide) {
                                                Content *aContent = [Content yy_modelWithJSON:dic] ;
                                                [tmpList_slide addObject:aContent] ;
                                            }
                                            for (NSDictionary *dic in retTop) {
                                                Content *aContent = [Content yy_modelWithJSON:dic] ;
                                                [tmpList_top addObject:aContent] ;
                                            }
                                        }
                                        
                                        self.dataList = tmpList_data ;
                                        self.topList = tmpList_top ;
                                        self.slideList = tmpList_slide ;
                                        
                                    } fail:^{
                                        
                                    }] ;
    
}

- (void)loadMoreData
{
    if (!self.dataList.count) {
        return ;
    }
    
    Content *lastContent = [self.dataList lastObject] ;
    
    NSMutableArray*tmpList_data = self.dataList ;
    
    [ServerRequest getContentListWithKindID:self.kind.kindId
                                   sendtime:lastContent.sendtime
                                       size:kPageSize
                                    success:^(id json) {
                                        
                                        ResultParsered *result = [ResultParsered yy_modelWithJSON:json] ;
                                        if (result.errCode == 1001)
                                        {
                                            NSDictionary *retDic = result.info ;
                                            NSArray *retlist = retDic[@"list"] ;
                                            for (NSDictionary *dic in retlist) {
                                                Content *aContent = [Content yy_modelWithJSON:dic] ;
                                                [tmpList_data addObject:aContent] ;
                                            }
                                            self.dataList = tmpList_data ;
                                        }
                                        
                                    } fail:^{
                                        
                                    }] ;
}




#pragma mark - tableView datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // banner
    if (section == 0) {
        return (!self.slideList.count) ? 0 : 1 ;
    }
    // top
    else if (section == 1) {
        return (!self.topList.count) ? 0 : self.topList.count ;
    }
    // content
    else if (section == 2) {
        return (!self.dataList.count) ? 0 : self.dataList.count ;
    }
    
    return 0 ;
}

- (UITableViewCell *)getCellWithContent:(Content *)aContent table:(UITableView *)tableView
{
    if (aContent.displayType == 0) {
        NormalContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_normalContentcell] ;
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:identifier_normalContentcell bundle:nil] forCellReuseIdentifier:identifier_normalContentcell] ;
            cell = [tableView dequeueReusableCellWithIdentifier:identifier_normalContentcell] ;
        }
        cell.aContent = aContent ;
        return cell ;
    }
    else if (aContent.displayType == 1) {
        BigImgContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_BigImgContentCell] ;
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:identifier_BigImgContentCell bundle:nil] forCellReuseIdentifier:identifier_BigImgContentCell] ;
            cell = [tableView dequeueReusableCellWithIdentifier:identifier_BigImgContentCell] ;
        }
        cell.aContent = aContent ;
        return cell ;
    }
    else if (aContent.displayType == 2) {
        MultiPictureContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_MultiPictureContentCell] ;
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:identifier_MultiPictureContentCell bundle:nil] forCellReuseIdentifier:identifier_MultiPictureContentCell] ;
            cell = [tableView dequeueReusableCellWithIdentifier:identifier_MultiPictureContentCell] ;
        }
        cell.aContent = aContent ;
        return cell ;
    }
    return nil ;
}

- (CGFloat)getHeightWithContent:(Content *)aContent
{
    if (aContent.displayType == 0) {
        return [NormalContentCell getHeight] ;
    }
    else if (aContent.displayType == 1) {
        return [BigImgContentCell getHeightWithTitle:aContent.title] ;
    }
    else if (aContent.displayType == 2) {
        return [MultiPictureContentCell getHeightWithTitle:aContent.title] ;
    }
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // banner
    if (indexPath.section == 0)
    {
        BannerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_bannercell] ;
        if (!cell) {
            cell = [[BannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_bannercell] ;
        }
        [cell setupLoopInfo:self.slideList
                     kindID:self.kind.kindId] ;
        cell.delegate = self ;
        return cell ;
    }
    // top
    else if (indexPath.section == 1)
    {
        Content *aContent = (!self.topList.count) ? nil : self.topList[indexPath.row] ;
        return [self getCellWithContent:aContent table:tableView] ;
    }
    // content
    else if (indexPath.section == 2)
    {
        Content *aContent = (!self.dataList.count) ? nil : self.dataList[indexPath.row] ;
        return [self getCellWithContent:aContent table:tableView] ;
    }
    
    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return (!self.slideList.count) ? 0 : [BannerCell getHeight] ;
    }
    else if ( indexPath.section == 1 ) {
        Content *aContent = (!self.topList.count) ? nil : self.topList[indexPath.row] ;
        return [self getHeightWithContent:aContent] ;
    }
    else if ( indexPath.section == 2 ) {
        Content *aContent = (!self.dataList.count) ? nil : self.dataList[indexPath.row] ;
        return [self getHeightWithContent:aContent] ;
    }
    
    return 0. ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return ;
    
    NSLog(@"click row : %@",indexPath) ;
    if (self.handlerDelegate && [self.handlerDelegate respondsToSelector:@selector(didSelectRowWithContent:)])
    {
        Content *aContent = nil ;
        if (indexPath.section == 1) {
            // top
            aContent = self.topList[indexPath.row] ;
        }
        else if (indexPath.section == 2) {
            // data
            aContent = self.dataList[indexPath.row] ;
        }
        [self.handlerDelegate didSelectRowWithContent:aContent] ;
    }
}


#pragma mark - func 

- (void)handleTableDatasourceAndDelegate:(UITableView *)table
{
    if ([table isKindOfClass:[RootTableView class]]) {
        ((RootTableView *)table).xt_Delegate = self ;
    }
    
    [super handleTableDatasourceAndDelegate:table] ;
}

- (void)centerHandlerRefreshing
{
    [self.handlerDelegate handlerRefreshing:self] ;
}

- (void)table:(UITableView *)table IsFromCenter:(BOOL)isFromCenter
{
    // get banner cell
    BannerCell *bannerCell = (BannerCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    // deal with loop timer .
    if (isFromCenter)
        [bannerCell start] ;
    else
        [bannerCell stop] ;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CenterTableView *table = (CenterTableView *)scrollView ;

    if (table.mj_header.isRefreshing) {
        return ;
    }
    
    float offsetY = scrollView.contentOffset.y ;
    
    BannerCell *cell = [(UITableView *)scrollView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    [cell layoutHeaderViewForScrollViewOffset:scrollView.contentOffset scrollView:scrollView] ;
    
    if ([scrollView isKindOfClass:[CenterTableView class]])
    {
        NSString *imgStr = [cell fetchCenterImageStr] ;
        [(CenterTableView *)scrollView refreshImage:imgStr] ;
    }
    
    if (self.handlerDelegate != nil && [self.handlerDelegate respondsToSelector:@selector(tableDidScrollWithOffsetY:)])
    {
        [self.handlerDelegate tableDidScrollWithOffsetY:offsetY] ;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    float offsetY = scrollView.contentOffset.y ;
    
    if (self.handlerDelegate != nil && [self.handlerDelegate respondsToSelector:@selector(tablelWillEndDragWithOffsetY:WithVelocity:)]) {
        [self.handlerDelegate tablelWillEndDragWithOffsetY:offsetY WithVelocity:velocity] ;
    }
    
    //nav 吸附性
    //    NSLog(@"velocity : %@",NSStringFromCGPoint(velocity)) ;
    if (velocity.y > 0.) {
        if (velocity.y > 1.8) return ; // 超速 .
        // 上推
        float overLength = [BannerCell getHeight] - 40. - 20. ;
        float offsetY = scrollView.contentOffset.y ;
        if (offsetY < overLength && offsetY > 0 ) {
            targetContentOffset -> y = [BannerCell getHeight] - 40. - 20. ;
        }
    }
    //    else {
    //        // 下拉 加速
    //    }
    
//    BannerCell *cell = [(UITableView *)scrollView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
//    NSString *imgStr = [cell fetchCenterImageStr] ;
//    if ([scrollView isKindOfClass:[CenterTableView class]]) {
//        [(CenterTableView *)scrollView refreshImage:imgStr] ;
//    }
}


#pragma mark - BannerCellDelegate
- (void)selectContentInBanner:(Content *)content
{
    [self.handlerDelegate bannerSelected:content] ;
}

@end
