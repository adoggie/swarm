//
//  OauthViewController.m
//  DESK
//
//  Created by 51desk on 15/7/1.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "OauthViewController.h"

@interface OauthViewController ()

@end

@implementation OauthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       [self initbackBarItem];
      
    [self.view addSubview:self.NameField];
       [self.view addSubview:self.PassWordField];
       [self.view addSubview:self.oauthBtn];
     [self.view addSubview:self.siteField];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
  
    _NameField.frame=CGRectMake(20,80,SCREEN_WIDTH-40,44);
    _PassWordField.frame=CGRectMake(20,0,SCREEN_WIDTH-40,44);
    [_PassWordField top:20  FromView:_NameField];
    
    _siteField.frame=CGRectMake(20,0,SCREEN_WIDTH-40,44);
    [_siteField top:20  FromView:_PassWordField];
    
    _oauthBtn.frame=CGRectMake(20,0,SCREEN_WIDTH-40,44);
    [_oauthBtn top:20  FromView:_siteField];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)OauthBtnClick:(id)btn
{
     [self waitViewShow];
    DeskHttpRequest *deskhttp=[[DeskHttpRequest alloc]initWithDelegate:self];
    NSString *STR= @"http://172.20.0.192:8800/desk/ap/deskcheck.do";
    [deskhttp addHeaderKey:@"SESSION-TOKEN" Value:[UserManager shareMainUser].session_token];
    NSMutableDictionary *reqDict=[NSMutableDictionary dictionary];

    [reqDict setObject:_siteField.text forKey:@"desk_site"];
    [reqDict setObject:_NameField.text forKey:@"desk_uid"];
    [reqDict setObject:_PassWordField.text forKey:@"desk_pwd"];

    [deskhttp startPost:STR params:reqDict  tag:@"desk" postType:PostDataStyleDictionary];
   
//        [self.navigationController popViewControllerAnimated:YES];

}


-(void)getFinished:(NSDictionary *)msg tag:(NSString*)tag;
{
 
       [self waitViewHidden];
    if ([[msg objectForKey:@"status"]intValue]==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
        [AlertMessageCenter showWaittingView:[msg objectForKey:@"errmsg" ] during:0.7];
    
    
}
-(void)getError:(NSDictionary *)msg tag:(NSString*)tag;
{
    [self waitViewHidden];
    [AlertMessageCenter showWaittingView:@"网络失败,稍后再试" during:0.7];
}
- (UITextField *)NameField
{
    if (_NameField == nil) {
        _NameField = [[UITextField alloc] init];
        _NameField.text=@"24509826@qq.com";
        _NameField.backgroundColor=[UIColor whiteColor];
        [_NameField.layer setMasksToBounds:YES];
        [_NameField.layer setCornerRadius:20.0]; //设置矩形四个圆角半径
        _NameField.font = [UIFont systemFontOfSize:12];
    }
    return _NameField;
}

- (UITextField *)PassWordField
{
    if (_PassWordField == nil) {
        _PassWordField = [[UITextField alloc] init];
        _PassWordField.text=@"!QAZ2wsx";
        _PassWordField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _PassWordField.backgroundColor=[UIColor whiteColor];
        
        [_PassWordField.layer setMasksToBounds:YES];
        [_PassWordField.layer setCornerRadius:20.0]; //设置矩形四个圆角半径
        _PassWordField.font = [UIFont systemFontOfSize:12];
    }
    return _PassWordField;
}


- (UITextField *)siteField
{
    if (_siteField == nil) {
        _siteField = [[UITextField alloc] init];
        _siteField.text=@"51deskex";
        _siteField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _siteField.backgroundColor=[UIColor whiteColor];
        
        [_siteField.layer setMasksToBounds:YES];
        [_siteField.layer setCornerRadius:20.0]; //设置矩形四个圆角半径
        _siteField.font = [UIFont systemFontOfSize:12];
    }
    return _siteField;
}
- (UIButton *)oauthBtn
{
    if (_oauthBtn== nil) {
        _oauthBtn = [[UIButton  alloc] init];
        _oauthBtn.backgroundColor=[PublicMethods getAlphaColor:@"93ce69" alpha:1.0];
        [_oauthBtn.layer setMasksToBounds:YES];
        [_oauthBtn.layer setCornerRadius:20.0]; //设置矩形四个圆角半径
        [_oauthBtn setTitle:@"授权" forState:UIControlStateNormal];
        [_oauthBtn addTarget:self action: @selector(OauthBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
    }
    return _oauthBtn;
}



@end
