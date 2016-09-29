//
//  FindViewController.m
//  pro
//
//  Created by TuTu on 16/8/29.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "FindViewController.h"
#import "ServerRequest.h"
#import "ResultParsered.h"
#import "YYModel.h"
#import "SearchCtrller.h"


@interface FindViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *schbarbg;
@property (weak, nonatomic) IBOutlet UIView *schbarbg2;
@property (weak, nonatomic) IBOutlet UIView *navbar;
@property (weak, nonatomic) IBOutlet UILabel *labelFind;
@property (weak, nonatomic) IBOutlet UITableView *table;


@end

@implementation FindViewController

#pragma mark - action

- (IBAction)schbarOnClick:(id)sender
{
    SearchCtrller *searchVC = (SearchCtrller *)[[self class] getCtrllerFromStory:@"Find" controllerIdentifier:@"SearchCtrller"] ;
    
    [self presentViewController:searchVC animated:YES completion:^{
        
    }] ;
}

#pragma mark - prop


#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"发现" ;
    
    [self configureUIs] ;
}

- (void)configureUIs
{
    _navbar.backgroundColor = [UIColor xt_nav] ;
    _schbarbg.backgroundColor = [UIColor xt_nav] ;
    _schbarbg2.backgroundColor = [UIColor whiteColor] ;
    _schbarbg2.layer.cornerRadius = 5. ;
    _schbarbg2.layer.masksToBounds = true ;
    _labelFind.textColor = [UIColor whiteColor] ;
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
