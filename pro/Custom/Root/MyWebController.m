//
//  MyWebController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-10.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "MyWebController.h"
#import "YXSpritesLoadingView.h"
#import "WordsHeader.h"
#import "CommonFunc.h"
#import "DigitInformation.h"
#import "XTTickConvert.h"


@interface MyWebController () <UIWebViewDelegate>

@end

@implementation MyWebController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark --
- (void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr ;
    
    [self startLoadingWebview] ;
}

- (UIWebView *)webView
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds] ;
        _webView.autoresizesSubviews = YES ;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
        _webView.delegate = self ;
        if (![_webView superview])
        {
            [self.view addSubview:_webView] ;
        }
    }
    
    return _webView ;
}
- (void)startLoadingWebview
{
//    [YXSpritesLoadingView showWithText:WD_NONE_STR andShimmering:NO andBlurEffect:NO] ;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]] ;
    [self.webView loadRequest:request];
}

#pragma mark --
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [self.view sendSubviewToBack:self.webView] ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
//    [YXSpritesLoadingView dismiss] ;
}

#pragma mark --
#pragma mark - web view delegate
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidFinishLoad");
//    [YXSpritesLoadingView dismiss] ;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"didFailLoadWithError:%@", error);
//    [YXSpritesLoadingView dismiss] ;
}

//判断用户点击类型
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    /*
    NSURL *tempUrl = request.URL ;
    NSString *absoluteStr = [tempUrl absoluteString] ;
    NSLog(@"url str : %@", absoluteStr) ;

    if ([absoluteStr isEqualToString:@"http://m.jgb.cn/"])
    {
        //去登录, app登录成功后, 登录h5
        if (G_TOKEN == nil || [G_TOKEN isEqualToString:@""])
        {
            [NavRegisterController goToLoginFirstWithCurrentController:self AppLoginFinished:YES] ;
        }
        
        return NO ;
    }
    
    switch (navigationType)
    {
            //点击连接
        case UIWebViewNavigationTypeLinkClicked:
        {
            NSLog(@"clicked");
            
            if (!tempUrl) return YES ;
            
            NSString *sepStr = @"?sku=" ;
            
            if ([[absoluteStr componentsSeparatedByString:sepStr] count] <= 1) {
                return YES ;
            }
            
            NSString *goodsCode = [[absoluteStr componentsSeparatedByString:sepStr] lastObject];
            
            [self goIntoGoodsDetail:goodsCode] ;

            return NO ;
        }
            break ;
            //提交表单
        case UIWebViewNavigationTypeFormSubmitted:
        {
            NSLog(@"submitted");
        }
            break ;
        default:
            break;
    }
    
    return YES;
*/
    return YES ;
}

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
