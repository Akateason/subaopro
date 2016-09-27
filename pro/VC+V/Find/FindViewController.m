//
//  FindViewController.m
//  pro
//
//  Created by TuTu on 16/8/29.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "FindViewController.h"
#import "NormalContentCell.h"
#import "ServerRequest.h"
#import "ResultParsered.h"
#import "YYModel.h"
#import "Content.h"
#import "DetailCtrller.h"


@interface FindViewController () <UITableViewDataSource,UITableViewDelegate>
{
    BOOL    typeTitleOrTag ; // false - > title , true tag .
}


@property (weak, nonatomic) IBOutlet UITableView *table;


@property (nonatomic,strong) NSArray *dataList ;

@end

@implementation FindViewController

#pragma mark - action

#pragma mark - prop


#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"发现" ;

    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
    [self.navigationController setNavigationBarHidden:YES] ;
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
