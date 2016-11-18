//
//  LoginCtrller.m
//  pro
//
//  Created by TuTu on 16/11/18.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "LoginCtrller.h"
#import "UIImage+AddFunction.h"
#import "UIButton+Countdown.h"
#import "SVProgressHUD.h"
#import "UserPhone.h"
#import "LoginManager.h"

@interface LoginCtrller ()

@property (weak, nonatomic) IBOutlet UITextField *tf_phone;
@property (weak, nonatomic) IBOutlet UITextField *tf_checkCode;
@property (weak, nonatomic) IBOutlet UIButton *btSendCheckCode;
@property (weak, nonatomic) IBOutlet UIButton *btFinish;
@property (weak, nonatomic) IBOutlet UIImageView *imgBG;
@property (weak, nonatomic) IBOutlet UIButton *btCancel;

@end


@interface LoginCtrller ()
@property (nonatomic,copy) NSString *recievedCheckCode ;
@end

@implementation LoginCtrller

- (IBAction)btSendCheckCodeOnClick:(id)sender
{
    if (_tf_phone.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的手机号码"] ;
        return ;
    }
    
    [ServerRequest sendCMSCheckCode:_tf_phone.text
                            success:^(id json) {
                                
                                ResultParsered *result = [ResultParsered yy_modelWithJSON:json] ;
                                if (result.errCode == 1001)
                                {
                                    self.recievedCheckCode = result.info[@"checkCode"] ;
                                    
                                    [sender startWithTime:59
                                                    title:@"获取验证码"
                                           countDownTitle:@"(s)"
                                                mainColor:[UIColor xt_mainhalf]
                                               countColor:[UIColor xt_mainhalf]] ;
                                }
                                
                            } fail:^{
                                
                            }] ;
}

- (IBAction)btFinishOnClick:(id)sender
{
    if (_tf_phone.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的手机号码"] ;
        return ;
    }
    else if (_tf_checkCode.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的手机号码"] ;
        return ;
    }
    else if (![_tf_checkCode.text isEqualToString:self.recievedCheckCode]) {
        [SVProgressHUD showErrorWithStatus:@"验证码不正确"] ;
        return ;
    }
    
    [ServerRequest loginWithPhone:_tf_phone.text
                          success:^(id json) {
                              
                              ResultParsered *result = [ResultParsered yy_modelWithJSON:json] ;
                              if (result.errCode == 1001)
                              {
                                  int userId = [result.info[@"userId"] intValue] ;
                                  UserPhone *user = [[UserPhone alloc] initWithPhone:_tf_phone.text userId:userId] ;
                                  [LoginManager cacheUser:user] ;
                                  
                                  [self dismissViewControllerAnimated:YES
                                                           completion:^{
                                  }] ;
                              }
                              
                          } fail:^{
                              
                          }] ;
    
    
}

- (IBAction)btCancelOnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
    }] ;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _btSendCheckCode.backgroundColor = [UIColor xt_mainhalf] ;
    _btSendCheckCode.layer.cornerRadius = 5. ;
    
    _btFinish.backgroundColor = [UIColor xt_mainhalf] ;
    _btFinish.layer.cornerRadius = 5. ;
    
    _btCancel.layer.cornerRadius = 5. ;
    
    [self.view sendSubviewToBack:_imgBG] ;
    
    if (_screenShot) {
        UIImage *image = [UIImage getImageFromView:self.screenShot] ;
        self.imgBG.image = [image blur] ;
        self.imgBG.alpha = 0.6 ;
    }
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
