//
//  ShopWeiMaoCtrller.m
//  pro
//
//  Created by TuTu on 16/11/21.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "ShopWeiMaoCtrller.h"
#import "LoginManager.h"
#import "ServerRequest.h"
#import "YYModel.h"
#import "NSString+Extend.h"


static NSString *kAPP_ID = @"62" ;

static NSString *kURL_Shop = @"http://www.wemart.cn/mobile/?chanId=124&sellerId=126&a=shelf&m=index" ;

static NSString *kPayNative = @"&payNative=true&native=false" ;


@interface ShopWeiMaoCtrller ()
@property (nonatomic,copy) NSString *sign ;
@end

@implementation ShopWeiMaoCtrller

- (NSString *)makeCompleteUrl
{
    if (!self.sign) return nil  ; //server sign fail .
    
    // sign success .
    NSString *resultString = kURL_Shop ;
    resultString = [[[[[resultString stringByAppendingString:@"&scenType=1"]
                                    stringByAppendingString:[NSString stringWithFormat:@"&appId=%@",kAPP_ID]]
                                    stringByAppendingString:[NSString stringWithFormat:@"&userId=%@",[self userID]]]
                                    stringByAppendingString:[NSString stringWithFormat:@"&sign=%@",self.sign]]
                                    stringByAppendingString:kPayNative] ;
    NSLog(@"url : %@",resultString) ;
    return resultString ;
}

- (NSString *)sign
{
    if (!_sign) {
        NSString *originalString = [NSString stringWithFormat:@"appId=%@&userId=%@",kAPP_ID,[self userID]] ;
        NSString *encodedURL = [NSString encodeString:originalString] ;
        id jsonObj = [ServerRequest getRSASha1SignWithhOriginalString:encodedURL] ;
        ResultParsered *result = [ResultParsered yy_modelWithJSON:jsonObj] ;
        if (result.errCode == 1001) {
            _sign = result.info[@"sign"] ; // success .
        }
    }
    return _sign ;
}

- (NSString *)userID
{
    return [NSString stringWithFormat:@"sbjn%@", @([LoginManager userOnDevice].userId)] ;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder] ;
    if (self) {
        self.appScheme = @"wmSubao" ;
        self.wechatAppId = @"wx392fcae86a27eb66" ;
        self.shopUrl = [self makeCompleteUrl] ;
        self.WMHidden = YES ;
    }
    return self ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [self resetWebsFrame] ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
    [self.navigationController setNavigationBarHidden:YES] ;
    
    if (!self.sign) { // if sign is nil . get it from server agiain and load URL .
        self.shopUrl = [self makeCompleteUrl] ;
    }
}

- (void)resetWebsFrame
{
    UIWebView *webView = [self valueForKey:@"wkWebView"] ;
    CGRect rect = self.view.frame ;
    CGFloat navHeight = APP_NAVIGATIONBAR_HEIGHT + APP_STATUSBAR_HEIGHT ;
    rect.origin.y = navHeight ;
    rect.size.height -= navHeight ;
    webView.frame = rect ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationView.backgroundColor = [UIColor xt_nav] ;
    self.navigationTitle.textColor = [UIColor whiteColor] ;
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
