//
//  LoginViewController.m
//  DESK
//
//  Created by 51desk on 15/6/8.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "LoginViewController.h"
#import "OauthWebViewController.h"
#import "InitOauthViewController.h"

#define FIELD_H (isRetina?36:44)

@interface LoginViewController ()

@end

@implementation LoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initbackBarItem];
        [self initScrollView];
    if ([self.navigationController.navigationBar  respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        // UIBarMetricsLandscapePhone
        [self.navigationController.navigationBar setBackgroundImage:[PublicMethods createImageWithColor:DESKCOLOR(0x2f3545)] forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    [self.view setBackgroundColor:[PublicMethods getAlphaColor:@"353c4e" alpha:1.0f ] ];

    [self.contentView  addSubview: self.NameField ];
    [self.contentView  addSubview: self.PassWordField ];
    [self.contentView  addSubview: self.LoginBtn ];
    [self.contentView  addSubview: self.HeadImage ];
    [self.contentView  addSubview: self.Selectbtn ];
    NSDictionary *userdit = [[NSUserDefaults standardUserDefaults] objectForKey:@"userdit"];
    BOOL isremember=  [[userdit objectForKey:@"isremember"] boolValue];
    NSString *str=  [[NSUserDefaults standardUserDefaults] objectForKey:@"urlkey"];
    
    if (isremember&&  [str isEqualToString:[userdit  objectForKey:@"serurl"]] ) {
        _NameField.text=[userdit objectForKey:@"username"];
        _PassWordField.text=[userdit objectForKey:@"userpassword"];
        _Selectbtn.selected=YES;
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    

    _HeadImage.frame=CGRectMake(50,SCREEN_HEIGHT/20,SCREEN_WIDTH-100,120);
    _NameField.frame=CGRectMake(20,30,SCREEN_WIDTH-40,FIELD_H);
    [_NameField top:20  FromView:_HeadImage];
    _PassWordField.frame=CGRectMake(20,0,SCREEN_WIDTH-40,FIELD_H);
    [_PassWordField top:20  FromView:_NameField];
    _Selectbtn.frame=CGRectMake(20,0,SCREEN_WIDTH-40,20);
    [_Selectbtn top:10  FromView:_PassWordField];
    _LoginBtn.frame=CGRectMake(20,0,SCREEN_WIDTH-40,FIELD_H);
    [_LoginBtn top:20  FromView:_Selectbtn];
    
    
    PNTToolbar *toolbar = [PNTToolbar defaultToolbar];
    toolbar.navigationButtonsTintColor = [UIColor grayColor];
    toolbar.mainScrollView = self.scrollViewForm;
    toolbar.inputFields = @[_NameField,_PassWordField];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoginBtnClick:(id )btn
{
    [self waitViewShow];
    
    DeskHttpRequest *deskhttp=[[DeskHttpRequest alloc]initWithDelegate:self];
    NSString *STR=  URL_POST_LOGIN_IN;
    NSMutableDictionary *reqDict=[NSMutableDictionary dictionary];
    [reqDict setObject:_NameField.text forKey:@"user"];
    [reqDict setObject:_PassWordField.text forKey:@"password"];
    [reqDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"urlkey"] forKey:@"domain"];
    [reqDict setObject:@"ylm" forKey:@"platform"];
    [reqDict setObject:@"ylm" forKey:@"device_id"];
    [deskhttp startPost:STR params:reqDict  tag:@"loggin" postType:PostDataStyleDictionary];

    
    
}

-(void)getUserinfo
{

    DeskHttpRequest *deskhttp=[[DeskHttpRequest alloc]initWithDelegate:self];
    NSString *STR=  URL_GET_USERINFO;
    [deskhttp addHeaderKey:@"SESSION-TOKEN" Value:[UserManager shareMainUser].session_token];
    [deskhttp startGet: STR tag:@"getuserinfo"];
  
    
}




-(void)SelectBtnClick:(UIButton*)btn
{
    
    btn.selected=!btn.selected;
    
}
#pragma HTTP delegate



-(void)getFinished:(NSDictionary *)msg tag:(NSString*)tag;
{
    
   
    
    if ([[msg  objectForKey:@"status"] intValue]==0) {
        
        // 设置用户信息
        if ([tag isEqualToString:@"loggin"]) {
            
            NSMutableDictionary *dict=[NSMutableDictionary dictionary];
            [dict setValue:[NSNumber numberWithBool:_Selectbtn.selected]  forKey:@"isremember"];
            [dict setValue:_NameField.text  forKey:@"username"];
            [dict setValue:_PassWordField.text  forKey:@"userpassword"];
            [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"urlkey"]  forKey:@"serurl"];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userdit"];
            
            
            [UserManager shareMainUser].session_token=[[msg  objectForKey:@"result"] objectForKey:@"token"];
            
            [self getUserinfo];
            
        }else if([tag isEqualToString:@"getuserinfo"])
        {
            
              [self waitViewHidden];
            NSDictionary * userdict=   [[msg  objectForKey:@"result"]objectForKey:@"user"];
            
            UserDataModel  *userdata=     [[UserDataModel alloc] initWithUserData:0 userName:[userdict objectForKey:@"user_name"] ava:[userdict objectForKey:@"avatar"] email:[userdict objectForKey:@"email"] position:[userdict objectForKey:@"position"]];
            
                        [UserManager shareMainUser].mainUser=userdata;
                         if ( ![[[NSUserDefaults standardUserDefaults] objectForKey:@"initoauth"]boolValue] ) {
                InitOauthViewController * loginctr=[[InitOauthViewController alloc]init];
                [self.navigationController pushViewController:loginctr animated:YES];
                loginctr.title=@"InitOauth";
             
//                [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithBool:YES] forKey:@"initoauth"];
            }else
            {
                
                
                            [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithBool:NO] forKey:@"initoauth"];
                [[self getAppDelegate ] AppdelegateLogIn];
                
            }
         
        
        }
        
    }else  // status!=0
    {
        [self waitViewHidden];
        [AlertMessageCenter showWaittingView:[msg  objectForKey:@"errmsg"] during:0.7];
    
    }
    
}
-(void)getError:(NSDictionary *)msg tag:(NSString*)tag;
{
    [self waitViewHidden];
    [AlertMessageCenter showWaittingView:@"网络失败,稍后再试" during:0.7];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



- (UITextField *)NameField
{
    if (_NameField == nil) {
        _NameField = [[UITextField alloc] init];
        
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
        
        _PassWordField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _PassWordField.backgroundColor=[UIColor whiteColor];
        [_PassWordField.layer setMasksToBounds:YES];
        [_PassWordField.layer setCornerRadius:20.0]; //设置矩形四个圆角半径
        _PassWordField.font = [UIFont systemFontOfSize:12];
    }
    return _PassWordField;
}

- (UIButton *)LoginBtn
{
    if (_LoginBtn == nil) {
        _LoginBtn = [[UIButton  alloc] init];
        _LoginBtn.backgroundColor=[PublicMethods getAlphaColor:@"93ce69" alpha:1.0];
        [_LoginBtn.layer setMasksToBounds:YES];
        [_LoginBtn.layer setCornerRadius:20.0]; //设置矩形四个圆角半径
        [_LoginBtn setTitle:@"Login in" forState:UIControlStateNormal];
        [_LoginBtn addTarget:self action: @selector(LoginBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
    }
    return _LoginBtn;
}

-(UIImageView*)HeadImage
{
    if (_HeadImage == nil) {
        _HeadImage = [[UIImageView  alloc] init];
        _HeadImage.image= [UIImage imageNamed:@"logo"];
        _HeadImage.backgroundColor=[UIColor clearColor];
        _HeadImage.contentMode=UIViewContentModeCenter;
    }
    return _HeadImage;
}

-(UIButton*)Selectbtn
{
    if (_Selectbtn == nil) {
        _Selectbtn = [[UIButton  alloc] init];
        _Selectbtn.backgroundColor=[UIColor clearColor];
        _Selectbtn.contentMode=UIViewContentModeCenter;
        [_Selectbtn addTarget:self action: @selector(SelectBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
        [_Selectbtn setTitle:@"remember name&password" forState:UIControlStateNormal];
        [_Selectbtn setImage:[UIImage imageNamed:@"funnel"] forState:UIControlStateNormal];
        [_Selectbtn setImage:[UIImage imageNamed:@"home"] forState:UIControlStateSelected];
        [_Selectbtn setImageEdgeInsets:UIEdgeInsetsMake(0,-20,0,0)];
    }
    return _Selectbtn;
}



@end
