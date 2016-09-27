//
//  LiveViewController.m
//  pro
//
//  Created by TuTu on 16/9/19.
//  Copyright © 2016年 teason. All rights reserved.

//  sdkid:10016
//  sdk_secret:sbj&()^$@%^



//static NSString *const kYZB_sdkid   = @"10016" ;
//static NSString *const kYZB_secret  = @"sbj&()^$@%^" ;
//static const NSInteger kPageSize    = 30 ;

#import "LiveViewController.h"
#import "XTTickConvert.h"
//#import "NSString+MD5.h"
//#import "YzbListItem.h"
#import "YYModel.h"
//#import "BigImgContentCell.h"
#import "Content.h"
#import "DetailCtrller.h"
#import "CmsTableHandler.h"
#import "Kind.h"
#import "CenterTableView.h"


@interface LiveViewController () <CmsTableHandlerDelegate>

@property (weak, nonatomic) IBOutlet CenterTableView *table ;
//@property (nonatomic,strong) NSArray *datalist ;
@property (nonatomic,strong) CmsTableHandler *handler ;

@end

@implementation LiveViewController

#pragma mark - prop
//- (NSArray *)datalist
//{
//    if (!_datalist) {
//        _datalist = @[] ;
//    }
//    return _datalist ;
//}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [_table registerNib:[UINib nibWithNibName:identifier_BigImgContentCell bundle:nil] forCellReuseIdentifier:identifier_BigImgContentCell] ;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    Kind *kind = [[Kind alloc] init] ;
    kind.kindId = 10 ;
    kind.name = @"直播" ;
    self.handler = [[CmsTableHandler alloc] initWithKind:kind] ;
    self.handler.handlerDelegate = self ;
    
    [self.handler handleTableDatasourceAndDelegate:_table] ;
    [self.handler centerHandlerRefreshing] ;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
    [self.navigationController setNavigationBarHidden:YES] ;
}


#pragma mark - CmsTableHandlerDelegate
- (void)tableDidScrollWithOffsetY:(float)offsetY
{
    
}

- (void)tablelWillEndDragWithOffsetY:(float)offsetY WithVelocity:(CGPoint)velocity
{
    
}

- (void)handlerRefreshing:(id)handler
{
    
}

- (void)didSelectRowWithContent:(Content *)content
{
    DetailCtrller *detailVC = (DetailCtrller *)[[self class] getCtrllerFromStory:@"Index" controllerIdentifier:@"DetailCtrller"] ;
    detailVC.content = content ;
    [detailVC setHidesBottomBarWhenPushed:YES] ;
    [self.navigationController pushViewController:detailVC animated:YES] ;
}

- (void)bannerSelected:(Content *)content
{
    DetailCtrller *detailVC = (DetailCtrller *)[[self class] getCtrllerFromStory:@"Index" controllerIdentifier:@"DetailCtrller"] ;
    detailVC.content = content ;
    [detailVC setHidesBottomBarWhenPushed:YES] ;
    [self.navigationController pushViewController:detailVC animated:YES] ;

}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
