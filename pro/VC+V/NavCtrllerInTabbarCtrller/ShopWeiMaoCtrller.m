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
static NSString *kAPP_SECRET = @"-----BEGIN PRIVATE KEY-----\nMIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAIWR6rmb7S0jfe2e5hWWIsqHzpiMcytgKKGCbvxNSrgKD3F7gcFQH17BsHwksaI1kCOhjHpp2zdSTv4b/7tGF3xTuKT2U1q5xdzvUYeougGI5xgNh9jWnhxFHrk92O29oco5fdIOkpC68FVGnGfbS9TI0JqgWQgALrwPYWLhat49AgMBAAECgYA08X6hrZ2YS74phtdabRVDRAtuyhUId2gDhMjrNtPMGSi/6Z2n+1ND4vBKdNz4F9UXWnxtNTJQPk7TSFPYblL2O+WGqCJX8TJYqOKvqg5bk/ZStOkuirnRZ+d4L2BToO7OL9Gs7ar1VCKbR3DQwleJ9MFa/3wCG38p1Q0MTC4LfQJBAPII82f1qZN1lpgONx0MA1tbxDqTehwYRF5rAVv6CZUCbwodimS6UAyZ434ndbICYy8OIPhWDObHr7nT961vGYsCQQCNRtocvUOHUnRAn3ZNW3O7x9Rq/yMO6pkob2xTl0GSCSgriz1kLAJeI62NZ86zr46XO9ckJL9nPlWfbPuiQZBXAkAoxotDS2bbOec6DMMKOLjkDky71Zav3wK9qWdcOH6exP8yBBIJsD3GMbLa0QkKCU7uYYH6dHzN8HxRYT2L0XjLAkAiMpxpiIboItVxLyh74T9KnTyWCdx6p98bIp2ePmbo6r6Gi9X4gY6xKwG/0PkAFeb2RM33Oc37N+OSC9d9l1FRAkAcscpIsHc4K7Q4sIWxkET+BbwDFVQYhQLuNXHhAlZm0XpgAK8wDD5z2b6VoGY89Fnq5nIEv2Wn8C+Fk4CocQeo\n-----END PRIVATE KEY-----" ;


static NSString *kURL_Shop = @"http://www.wemart.cn/mobile/?chanId=124&sellerId=126&a=shelf&m=index" ;


@interface ShopWeiMaoCtrller ()
@property (nonatomic,copy) NSString *sign ;
@end

@implementation ShopWeiMaoCtrller

- (NSString *)makeCompleteUrl
{
    if (!self.sign) return nil  ; //server sign fail .
    
    // sign success .
    NSString *resultString = kURL_Shop ;
    resultString = [[[[resultString stringByAppendingString:@"&scenType=1"]
                                    stringByAppendingString:[NSString stringWithFormat:@"&appId=%@",kAPP_ID]]
                                    stringByAppendingString:[NSString stringWithFormat:@"&userId=%@",[self userID]]]
                                    stringByAppendingString:[NSString stringWithFormat:@"&sign=%@",self.sign]] ;
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
        self.appScheme = @"Wemart" ;
        self.wechatAppId = @"wxcfc0cac5ea95bff5" ;
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
