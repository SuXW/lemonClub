//
//  WWRegisterViewController.m
//  newsmyEye
//
//  Created by songs on 16/9/6.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWRegisterViewController.h"
#import "HyLoginButton.h"

@interface WWRegisterViewController (){
    UITextField *phoneTextField;
    UITextField *VerifyCodeField;
    UITextField *pwdTextField;
    int timerNum;
    NSTimer *timer;
}

@end

@implementation WWRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 恢复导航条
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font_nonr_size(19),NSForegroundColorAttributeName:WWOrganText}];
    if (self.is_register == YES) {
        self.title = @"找回密码";
    }else{
        self.title = @"账户注册";
    }
    
    UIButton * goBack = [[UIButton alloc]init];
    goBack.frame=CGRectMake(0, 0, 22, 22);
    [goBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(backGoLogin:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:goBack];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)creatUI{
    //输入框
    //手机号
    UIView * viewPhone = [[UIView alloc]init];
    [viewPhone setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewPhone];
    [viewPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.top.mas_equalTo(64+30);
        make.height.equalTo(@44);
    }];
    
    phoneTextField = [[UITextField alloc]init];
    phoneTextField.placeholder = @"输入手机号";
    [phoneTextField setFont:font_nonr_size(15)];
    [phoneTextField setValue:WWPlaceTextColor forKeyPath:@"_placeholderLabel.textColor"];
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [phoneTextField addTarget:self action:@selector(phoneTextChange) forControlEvents:UIControlEventEditingChanged];
    [viewPhone addSubview:phoneTextField];

    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    UILabel *phoneLine = [[UILabel alloc]init];
    phoneLine.backgroundColor = RGBCOLOR(214, 215, 219);
    [viewPhone addSubview:phoneLine];
    
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(viewPhone.mas_width);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(viewPhone.mas_bottom);
        make.left.equalTo(viewPhone.mas_left);
    }];
    
    // 验证码
    UIView * viewVerifyCode = [[UIView alloc]init];
    [viewVerifyCode setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewVerifyCode];
    [viewVerifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.top.equalTo(viewPhone.mas_bottom);
        make.height.equalTo(@44);
    }];
    
    VerifyCodeField = [[UITextField alloc]init];
    VerifyCodeField.placeholder = @"输入验证码";
    [VerifyCodeField setFont:font_nonr_size(15)];
    [VerifyCodeField setValue:WWPlaceTextColor forKeyPath:@"_placeholderLabel.textColor"];
    VerifyCodeField.keyboardType = UIKeyboardTypePhonePad;
    [viewVerifyCode addSubview:VerifyCodeField];
    
    [VerifyCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    UILabel *VerifyCodeLine = [[UILabel alloc]init];
    VerifyCodeLine.backgroundColor = RGBCOLOR(214, 215, 219);
    [viewVerifyCode addSubview:VerifyCodeLine];
    
    [VerifyCodeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(viewVerifyCode.mas_width);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(viewVerifyCode.mas_bottom);
        make.left.equalTo(viewVerifyCode.mas_left);
    }];
    // 获取验证码
    self.codeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.codeButton.titleLabel.font = font_nonr_size(11);
    self.codeButton.layer.cornerRadius = 3;
    self.codeButton.layer.masksToBounds = YES;
    [self.codeButton setBackgroundColor:RGBCOLOR(201, 201, 201)];
//    [self.codeButton setBackgroundColor:RGBCOLOR(237, 200, 30)];
    [self.codeButton addTarget:self action:@selector(codeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [viewVerifyCode addSubview:self.codeButton];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
        make.right.equalTo(viewVerifyCode.mas_right);
        make.centerY.equalTo(viewVerifyCode.mas_centerY);
    }];
    
    //密码
    UIView * viewPwd = [[UIView alloc]init];
    [viewPwd setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewPwd];
    
    [viewPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.top.equalTo(viewVerifyCode.mas_bottom);
        make.height.equalTo(@44);
    }];
    
    UIButton * btnSwitch = [[UIButton alloc]init];
    [btnSwitch setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [btnSwitch addTarget:self action:@selector(switchSercu) forControlEvents:UIControlEventTouchUpInside];
    
    [viewPwd addSubview:btnSwitch];
    
    [btnSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewPwd.mas_right).offset(-10);
        make.width.equalTo(@23);
        make.height.equalTo(@14);
        make.centerY.equalTo(viewPwd.mas_centerY);
    }];
    
    pwdTextField = [[UITextField alloc]init];
    if (self.is_register == YES) {
        [pwdTextField setPlaceholder:@"设置新密码"];
    }else{
        [pwdTextField setPlaceholder:@"输入密码"];
    }
    [pwdTextField setValue:WWPlaceTextColor forKeyPath:@"_placeholderLabel.textColor"];
    [pwdTextField setFont:font_nonr_size(15)];
    [pwdTextField setSecureTextEntry:YES];
    [pwdTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [viewPwd addSubview:pwdTextField];
    
    [pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(viewPwd).offset(0);
        make.right.equalTo(btnSwitch.mas_left).offset(-10);
    }];
    
    UILabel *pwdLine = [[UILabel alloc]init];
    pwdLine.backgroundColor = RGBCOLOR(214, 215, 219);
    [viewPwd addSubview:pwdLine];
    
    [pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(viewPwd.mas_width);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(viewPwd.mas_bottom);
        make.left.equalTo(viewPwd.mas_left);
    }];
    
    //  确认/// 注册
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (self.is_register ==YES) {
        [submitButton setTitle:@"确  认" forState:UIControlStateNormal];
        submitButton.tag = 1000;        // 找回密码
    }else{
        [submitButton setTitle:@"注  册" forState:UIControlStateNormal];
        submitButton.tag = 1001;        // 注册用户
    }
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = font_nonr_size(15);
    submitButton.layer.cornerRadius = 3;
    submitButton.layer.masksToBounds = YES;
    [submitButton setBackgroundColor:RGBCOLOR(237, 200, 30)];
    [submitButton addTarget:self action:@selector(submitClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.equalTo(@44);
        make.top.equalTo(viewPwd.mas_bottom).offset(60);
    }];
    
    
}

- (void)submitClickEvent:(UIButton *)sender{
    if (VerifyCodeField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (pwdTextField.text.length == 0) {
        if (self.is_register == YES) {
            [SVProgressHUD showErrorWithStatus:@"请设置新密码"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        }
        return;
    }
//    [SMSSDK commitVerificationCode:VerifyCodeField.text phoneNumber:phoneTextField.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
//        {
//            if (!error){
//                NSLog(@"验证成功");
//                if (self.is_register == YES) {  // 找回密码
//                    
//                }else{      // 注册用户
                    [self registerUser];
//                }
//            }else{
//                NSLog(@"错误信息:%@",error);
//            }
//        }
//    }];
}

- (void)registerUser{
    [SVProgressHUD show];
    NSMutableDictionary *dic = [WWUtilityClass getParametersDic:@"addRegister"];
    [dic setObject:phoneTextField.text forKey:@"phone"];
    [dic setObject:[WWUtilityClass md5HexDigest:[NSString stringWithFormat:@"%@%@",[WWUtilityClass md5HexDigest:pwdTextField.text],@"\"Lemon\""]] forKey:@"password"];
    [RestManager requestWithJson:dic requestMethod:requestMethodPOST withUrl:@"" success:^(NSDictionary *responseDic) {
        [SVProgressHUD dismiss];
        WWLog(@"注册成功");
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)phoneTextChange{
    if (phoneTextField.text.length == 11) {
        self.codeButton.userInteractionEnabled = YES;
        [self.codeButton setBackgroundColor:RGBCOLOR(237, 200, 30)];
    }else{
        self.codeButton.backgroundColor = RGBCOLOR(201, 201, 201);
        self.codeButton.userInteractionEnabled = NO;
    }
}

- (void)codeButtonClick:(UIButton *)sender{
    if (phoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确手机号码"];
        return;
    }
    [SVProgressHUD show];
    /**
     *  @from                    v1.1.1
     *  @brief                   获取验证码(Get verification code)
     *
     *  @param method            获取验证码的方法(The method of getting verificationCode)
     *  @param phoneNumber       电话号码(The phone number)
     *  @param zone              区域号，不要加"+"号(Area code)
     *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
     *  @param result            请求结果回调(Results of the request)
     */
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:phoneTextField.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error) {
                                     if (!error) {
                                         NSLog(@"获取验证码成功");
                                         [SVProgressHUD dismiss];
                                         timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(passWorkTimerFireMethod:) userInfo:nil repeats:YES];
                                         timerNum = 60;

                                     } else {
                                         [SVProgressHUD showErrorWithStatus:@"发送失败，请重新发送"];
                                         NSLog(@"错误信息：%@",error);
                                     }
                                 }];
    
}

- (void)passWorkTimerFireMethod:(NSTimer *)passWordtimer{
    if (timerNum == 1) {
        [passWordtimer invalidate];
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeButton.userInteractionEnabled = YES;
        [self.codeButton setBackgroundColor:RGBCOLOR(237, 200, 30)];
        
    }else{
        timerNum --;
        NSString *title = [NSString stringWithFormat:@"%ds",timerNum];
        [self.codeButton setTitle:title forState:UIControlStateNormal];
        self.codeButton.backgroundColor = RGBCOLOR(201, 201, 201);
        self.codeButton.userInteractionEnabled = NO;
    }
}

//密文切换
-(void)switchSercu{
    [pwdTextField setSecureTextEntry:!pwdTextField.secureTextEntry];
}


- (void)backGoLogin:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
