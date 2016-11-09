//
//  ShopWebCtrller.m
//  pro
//
//  Created by TuTu on 16/8/9.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "ShopWebCtrller.h"

#define kURL_wemart  @"http://www.wemart.cn/mobile/?chanId=&shelfNo=1889&sellerId=126&a=shelf&m=index&isHome=true"

@interface ShopWebCtrller ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ShopWebCtrller

- (IBAction)backbtOnClick:(id)sender
{
    [self.tabBarController setSelectedIndex:0] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0) ;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:kURL_wemart]] ;
    [self.webView loadRequest:request] ;
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
