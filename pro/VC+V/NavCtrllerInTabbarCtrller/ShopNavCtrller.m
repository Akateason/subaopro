//
//  ShopNavCtrller.m
//  GroupBuying
//
//  Created by TuTu on 16/7/27.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "ShopNavCtrller.h"
//#import <WemartSDK/WemartViewController.h>
#import "ShopWebCtrller.h"
#import "ServerRequest.h"

/*
static NSString *const URL_SHOP_WEMART = @"http://www.wemart.cn/mobile/?chanId=&shelfNo=1889&sellerId=126&a=shelf&m=index&scenType=1" ;

static NSString *const URL_WEMART_SHOP_TAIL = @"#gl/shop000201505295985/0" ;

static NSString *const WEMART_APPID = @"7da6bc5e80124415b32ca3d7389b6f44" ;

static NSString *const kAppScheme = @"pro" ;

//static NSString *const kWechatAppId1 = @"wx8bd99b6cd5081f40" ;

static NSString *const kPrivateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALCj6yzAdHgYJybkBV6BnUz6iSn5afSUHmTeeXUkEu/ofUpB/qnfElV4at+dFTQ9cPRLrrlJxrYrFNUenukz3Q4zpQzExlxwD6PF17qEiOGfVp81ZLrYqP8/utGtqQaWRLqC2uobpQRJpB+CPXaSaMZoO1/qmi6F9SKFED9yqAjxAgMBAAECgYAK/yl078ZQc7B8S1XKPGd+k1pWsqBWCaKaxP7qvAQxy1eBd/pSuQB7MbP1l+HqDqkpjEykXGNyk9wIKI/cFM5+KVyXYhX0rhPwFmJ9HggJ6Dd1mkhjiEzG4ZZHnmP8Nts8DsrRWlIHNSjg7rYybjdsLRxNmFipk+4eXE8l02GsAQJBANoKTu+znd4K2ASv8aiX6djE0TiY1ZCJoNjtT0pOFvPNj0ffbTgxKOMkTXvpVE62BfK69lw47Ug/i1XNUuripUkCQQDPZHuoEE/iy7AAPaaxc/vGe9rt3RlxQ4+yRmf+PCcsig9+0VBkvw4mPi7pxYFcLZUBhMKdC8z//Lmq5m3gpk5pAkEAuI0HGS5PzfQhuX3uroO+pAKbECuUgF1tbo8WkM8d8EgqIWyEdo5tjCxbBSmOeXzp9fS3t4Fbnc5jMkGzECq8OQJAW2W7ITvfGOIPNGv3FGk64iQfPYic98+Ael6Q4ff8g6JsZcU1GtEgGTZ6UkfaVJc5/atWYQOcWowz/t8COWjRUQJAVQmvnaG+n8a3BcNA7T/nDaO115L0m3MgQdItb1CDyEv/vRqX7ez7FLVBR6h1YAvNqEc8g3o240YjGZZPFgRGsA==" ;
*/

@interface ShopNavCtrller ()
/*
@property (nonatomic, copy) NSString *sign ;
@property (nonatomic, copy) NSString *userIDStr ;
*/
@end

@implementation ShopNavCtrller

#pragma mark --

- (void)pushShopCtllerFromSelectedCtrller:(id)ctrller
{
    ShopWebCtrller *shopCtrller = [[ShopWebCtrller alloc] init] ;
//    shopCtrller.urlStr = @"http://www.wemart.cn/mobile/?chanId=&shelfNo=1889&sellerId=126&a=shelf&m=index" ;
    [shopCtrller setHidesBottomBarWhenPushed:YES] ;
    [ctrller pushViewController:shopCtrller animated:YES] ;
    
/*
    WemartViewController *wemartVC = [[WemartViewController alloc] init] ;
    wemartVC.appScheme = kAppScheme ;
    wemartVC.shopUrl = [self prepareForUrl] ;
    wemartVC.WMShareHidden = YES ;
    wemartVC.bottomHeight = 0. ;
    wemartVC.WMCustomShare = YES ;
    [wemartVC setHidesBottomBarWhenPushed:YES] ;
    [ctrller pushViewController:wemartVC animated:YES] ;
*/
    
}

#pragma mark --
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}



/*
#pragma mark --
- (NSString *)sign
{
    if (!_sign) {
        ResultParsered *result = [ServerRequest getWemartRsaSignWithUserID:self.userIDStr appID:WEMART_APPID] ;
        _sign = (NSString *)result.info ;
        NSLog(@"wei mao sign : %@", _sign) ;
    }
    
    return _sign ;
}


- (NSString *)userIDStr
{
    //    return [NSString stringWithFormat:@"%d",[[CurrentUser shareInstance] getCurrentUser].u_id] ;
    return @"0" ;
}


- (NSString *)prepareForUrl
{
    NSString *url = [NSString stringWithFormat:@"%@&appId=%@&userId=%@&sign=%@%@",URL_SHOP_WEMART,WEMART_APPID,self.userIDStr,self.sign,URL_WEMART_SHOP_TAIL] ;
    NSLog(@"url : %@",url) ;
    return url ;
}
*/


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
