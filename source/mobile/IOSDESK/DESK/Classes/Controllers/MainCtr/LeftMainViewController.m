//
//  LeftMainViewController.m
//  DESK
//
//  Created by 51desk on 15/6/8.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "LeftMainViewController.h"

@interface LeftMainViewController ()

@end

@implementation LeftMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[PublicMethods getAlphaColor:@"353c4e" alpha:1.0f ] ];
    [self.view addSubview:self.SettingBtn];
    [self.view addSubview:self.LoginOutBtn];
    [self.view addSubview:self.UserName];
    [self.view addSubview:self.UserPosition];
    [self.view addSubview:self.UserHeadImg];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    _UserHeadImg.frame=CGRectMake(10,SCREEN_HEIGHT/10,50,50);
    _UserName.frame=CGRectMake(0,SCREEN_HEIGHT/10,100,30);
    [_UserName right:5 FromView:_UserHeadImg];
    _UserPosition.frame=CGRectMake(0,0,100,30);
    [_UserPosition right:5 FromView:_UserHeadImg];
    [_UserPosition top:0 FromView:_UserName];
    _SettingBtn.frame=CGRectMake(0,0,SCREEN_WIDTH/2,40);
    [_SettingBtn top:10  FromView:_UserHeadImg];
    _LoginOutBtn.frame=CGRectMake(0,0,SCREEN_WIDTH/2,40);
    [_LoginOutBtn top:5  FromView:_SettingBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)SettingClick:(id )btn
{
    
    
}

-(void)LoginOutClick:(id )btn
{
    
    [[self getAppDelegate] AppLogInOut];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (UIButton *)SettingBtn
{
    if (_SettingBtn == nil) {
        _SettingBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        _SettingBtn.backgroundColor=[PublicMethods getAlphaColor:@"#2b313f" alpha:1.0];
        [_SettingBtn setTitle:@"Setting" forState:UIControlStateNormal];
        [_SettingBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
   
       [_SettingBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];

       [_SettingBtn addTarget:self action:@selector(SettingClick:) forControlEvents:UIControlEventTouchUpInside];
        [_SettingBtn setTitleColor:[PublicMethods getAlphaColor:@"#bebcc1" alpha:1.0]  forState:UIControlStateNormal];
     
        
        
    }
    return _SettingBtn;
}

- (UIButton *)LoginOutBtn
{
    if (_LoginOutBtn == nil) {
        _LoginOutBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        _LoginOutBtn.backgroundColor=[PublicMethods getAlphaColor:@"#2b313f" alpha:1.0];
        [_LoginOutBtn setTitle:@"Login Out" forState:UIControlStateNormal];
        [_LoginOutBtn setImage:[UIImage imageNamed:@"loginout"] forState:UIControlStateNormal];
        [_LoginOutBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [_LoginOutBtn addTarget:self action:@selector(LoginOutClick:) forControlEvents:UIControlEventTouchUpInside];
        [_LoginOutBtn setTitleColor:[PublicMethods getAlphaColor:@"#bebcc1" alpha:1.0]  forState:UIControlStateNormal];
        
    }
    return _LoginOutBtn;
}

- (UILabel *)UserName
{
    if (_UserName == nil) {
        _UserName = [[UILabel alloc] init];
        _UserName.text=[UserManager shareMainUser].mainUser.Username;
        _UserName.backgroundColor=[UIColor clearColor];
        _UserName.textColor=[PublicMethods getAlphaColor:@"#ededed" alpha:1.0];
        
    }
    return _UserName;
}

- (UIImageView *)UserHeadImg
{
    if (_UserHeadImg == nil) {
        _UserHeadImg = [[UIImageView alloc] init];
        _UserHeadImg.backgroundColor=[UIColor clearColor];
       _UserHeadImg.layer.borderWidth = 2;
      _UserHeadImg.layer.borderColor = [UIColor whiteColor].CGColor;
       _UserHeadImg.layer.cornerRadius = 25;
        _UserHeadImg.clipsToBounds = YES;
        
    }
    return _UserHeadImg;
}

- (UILabel *)UserPosition
{
    if (_UserPosition == nil) {
        _UserPosition = [[UILabel alloc] init];
        _UserPosition.backgroundColor=[UIColor clearColor];
        _UserPosition.text=[UserManager shareMainUser].mainUser.Position;
        _UserPosition.textColor=[PublicMethods getAlphaColor:@"#bebcc1" alpha:1.0];
        
    }
    return _UserPosition;
}


@end
