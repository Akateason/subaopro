//
//  DetailCtrller.m
//  pro
//
//  Created by TuTu on 16/8/23.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "DetailCtrller.h"
#import "ShareUtils.h"
#import "ParallaxHeaderView.h"
#import "DetailParallaxHeader.h"
#import "Content.h"
#import "TagListCtrller.h"
#import "ShareAlertV.h"
#import "UIImage+AddFunction.h"

@interface DetailCtrller () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,DetailParallaxHeaderDelegate,UIWebViewDelegate,ShareAlertVDelegate>
{
    UIWebView *_webView ;
}
@property (nonatomic,strong) UIButton *backButton ;
@property (nonatomic,strong) UIButton *shareButton ;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,strong) ParallaxHeaderView *paralaxHeader ;
@property (nonatomic,strong) DetailParallaxHeader *detaiHeader ;


@end

@implementation DetailCtrller

#pragma mark - DetailParallaxHeaderDelegate

- (void)tagSelected:(Tag *)atag
{
    [self performSegueWithIdentifier:@"detail2taglist" sender:atag] ; //  send tag .
}


#pragma mark - prop

- (void)setContent:(Content *)content
{
    _content = content ;
    
    self.detaiHeader.aContent = content ;
    
    [ServerRequest addReadWithContentID:content.contentId
                                success:nil
                                   fail:nil] ;
}

+ (CGSize)getHeaderSize
{
    return CGSizeMake(APP_WIDTH, APP_WIDTH * 3. / 4.) ;
}

- (DetailParallaxHeader *)detaiHeader
{
    if (!_detaiHeader) {
        CGRect rect = CGRectZero ;
        rect.size = [[self class] getHeaderSize] ;
        _detaiHeader = [[[NSBundle mainBundle] loadNibNamed:@"DetailParallaxHeader" owner:self options:nil] lastObject] ;
        _detaiHeader.frame = rect ;
        _detaiHeader.delegate = self ;
    }
    return _detaiHeader ;
}

static float kflex_backbutton = 30. ;
static float klength_backbutton = 44. ;

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init] ;
        CGRect rect = CGRectMake(kflex_backbutton - 10., kflex_backbutton, klength_backbutton, klength_backbutton) ;
        _backButton.frame = rect ;
        [_backButton setImage:[UIImage imageNamed:@"btback"] forState:0] ;
        [_backButton addTarget:self action:@selector(backButtonOnclick) forControlEvents:UIControlEventTouchUpInside] ;
    }
    return _backButton ;
}

- (void)backButtonOnclick
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init] ;
        CGRect rect = CGRectMake(APP_WIDTH - klength_backbutton - kflex_backbutton, APP_HEIGHT - klength_backbutton - kflex_backbutton, klength_backbutton, klength_backbutton) ;
        _shareButton.frame = rect ;
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"btshare"] forState:0] ;
        [_shareButton addTarget:self action:@selector(shareButtonOnClick) forControlEvents:UIControlEventTouchUpInside] ;
    }
    return _shareButton ;
}

- (void)shareButtonOnClick
{
    NSLog(@"分享") ;
    ShareAlertV *shareAlert = [[ShareAlertV alloc] initWithController:self] ;
    shareAlert.aDelegate = self ;
}

#pragma mark - func
- (UIImage *)thumbnail
{
    UIImage *originalImg = self.detaiHeader.imageView.image ;
    UIImage *thumbnail = [UIImage thumbnailWithImage:originalImg size:CGSizeMake(80, 80)] ;
    return thumbnail ;
}


#pragma mark - ShareAlertVDelegate
- (void)clickIndex:(NSInteger)index
{
    // share call back
    switch (index)
    {
        case 0:
        {
            //@"新浪微博" ;
            [ShareUtils wb_sendTitleAndUrl:self.content.link
                                thumbImage:[self thumbnail]] ;
        }
            break;
        case 1:
        {
            //@"微信" ;
            [ShareUtils wx_sendLinkURL:self.content.link
                               TagName:nil
                                 Title:self.content.title
                           Description:nil
                            ThumbImage:[self thumbnail]
                               InScene:WXSceneSession] ;
        }
            break;
        case 2:
        {
            //@"朋友圈" ;
            [ShareUtils wx_sendLinkURL:self.content.link
                               TagName:nil
                                 Title:self.content.title
                           Description:nil
                            ThumbImage:[self thumbnail]
                               InScene:WXSceneTimeline] ;

        }
            break;
        default:
            break;
    }
}



#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.paralaxHeader = ({
        ParallaxHeaderView *header = [ParallaxHeaderView parallaxHeaderViewWithSubView:self.detaiHeader] ;
        header ;
    }) ;
    
    _table.delegate = self ;
    _table.dataSource = self ;
    _table.separatorStyle = 0 ;
    _table.tableHeaderView = self.paralaxHeader ;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
    [self.view addSubview:self.backButton] ;
    [self.view addSubview:self.shareButton] ;
    
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 1)] ;
    _webView.delegate = self ;
    _webView.scrollView.scrollEnabled = NO ;
    NSString *strUrl = self.content.link ;
    if (![strUrl hasPrefix:@"http"]) {
        strUrl = [@"http://" stringByAppendingString:strUrl] ;
    }
    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]]] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [(ParallaxHeaderView *)self.table.tableHeaderView refreshBlurViewForNewImage] ;
    [super viewDidAppear:animated] ;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
        [cell.contentView addSubview:_webView] ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone] ;
    }
    return cell ;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _webView.frame.size.height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.paralaxHeader layoutHeaderViewForScrollViewOffset:scrollView.contentOffset] ;
}


#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"") ;
    if ([webView.request.URL.absoluteString containsString:@"http://www.yizhibo.com"]) {
        _webView.frame = APPFRAME ;
        _webView.delegate = nil ;
        [_table reloadData] ;
        return ;
    }
    
    CGFloat height = _webView.scrollView.contentSize.height ;
    height += 20. ;
    _webView.frame = CGRectMake(_webView.frame.origin.x,_webView.frame.origin.y, APP_WIDTH, height) ;
    [_table reloadData] ;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detail2taglist"]) {
        TagListCtrller *tagListCtrller = [segue destinationViewController] ;
        tagListCtrller.atag = sender ;
    }
}


@end
