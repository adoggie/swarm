//
//  SetServiceURLController.m
//  DESK
//
//  Created by 51desk on 15/6/5.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "SetServiceURLController.h"
#import "LoginViewController.h"
#import "OauthWebViewController.h"



@interface SetServiceURLController ()

@end

@implementation SetServiceURLController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initScrollView];

    if ([self.navigationController.navigationBar  respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        // UIBarMetricsLandscapePhone
        [self.navigationController.navigationBar setBackgroundImage:[PublicMethods createImageWithColor:DESKCOLOR(0x2f3545)] forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    [self.view setBackgroundColor:[PublicMethods getAlphaColor:@"353c4e" alpha:1.0f ] ];

    [self.contentView addSubview: self.ServiceField ];
    [self.contentView  addSubview: self.SaveBtn ];
    [self.contentView  addSubview: self.EmailLable ];
    [self.contentView addSubview: self.ExplanationLable ];
    [self.contentView addSubview: self.HeadImage ];
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"urlkey"];
    _ServiceField.text=url;
    
    

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];


    _HeadImage.frame=CGRectMake(50,0,SCREEN_WIDTH-100,_HeadImage.image.size.height);
    _EmailLable.frame=CGRectMake(SCREEN_WIDTH-120,0,100,30);
    [_EmailLable top:0  FromView:_HeadImage];
    _ServiceField.frame=CGRectMake(20,0,SCREEN_WIDTH-140,30);
    [_ServiceField top:0  FromView:_HeadImage];
    _ExplanationLable.frame=CGRectMake(20,0,SCREEN_WIDTH-40,80);
    [_ExplanationLable top:5  FromView:_ServiceField];
    _SaveBtn.frame=CGRectMake(20,0,SCREEN_WIDTH-40,44);
    [_SaveBtn top:20  FromView:_ExplanationLable];
    
    
    PNTToolbar *toolbar = [PNTToolbar defaultToolbar];
    toolbar.navigationButtonsTintColor = [UIColor grayColor];
    toolbar.mainScrollView = self.scrollViewForm;
    toolbar.inputFields = @[_ServiceField];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SaveBtnClick:(id )btn
{
    
    if ([_ServiceField.text isEqualToString:@""]) {
        [AlertMessageCenter showWaittingView:@"域名不能为空" during:0.7];
        return;
    }
    
    [self waitViewShow];
    DeskHttpRequest *deskhttp=[[DeskHttpRequest alloc]initWithDelegate:self];
    NSString *STR=  URL_GET_DOMAIN(_ServiceField.text);
    [deskhttp startGet: STR tag:@"getdomain"];
    
    
}

#pragma HTTP delegate

-(void)getFinished:(NSDictionary *)msg tag:(NSString*)tag;
{
    
    
    
    [self waitViewHidden];
    if ([[msg objectForKey:@"status" ] intValue]==0 ) {
        LoginViewController * loginctr=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginctr animated:YES];
        loginctr.title=@"Sign In";
        
        [[NSUserDefaults standardUserDefaults] setObject:_ServiceField.text forKey:@"urlkey"];
        
    }else if ([[msg objectForKey:@"status" ] intValue]==1 )
    {
        
        
        [AlertMessageCenter showWaittingView:[msg objectForKey:@"errmsg" ] during:0.7];
        
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

- (UITextFieldEx *)ServiceField
{
    if (_ServiceField == nil) {
        _ServiceField = [[UITextFieldEx alloc] init];
        _ServiceField.textColor=[UIColor whiteColor];
        _ServiceField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _ServiceField.backgroundColor=[UIColor clearColor];
        _ServiceField.font = [UIFont systemFontOfSize:12];
    }
    return _ServiceField;
}

- (UIButton *)SaveBtn
{
    if (_SaveBtn == nil) {
        _SaveBtn = [[UIButton  alloc] init];
        _SaveBtn.backgroundColor=[PublicMethods getAlphaColor:@"93ce69" alpha:1.0];
        [_SaveBtn.layer setMasksToBounds:YES];
        [_SaveBtn.layer setCornerRadius:20.0]; //设置矩形四个圆角半径
        [_SaveBtn setTitle:@"NEXT" forState:UIControlStateNormal];
        [_SaveBtn addTarget:self action: @selector(SaveBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
    }
    return _SaveBtn;
}

-(UIImageView*)HeadImage
{
    if (_HeadImage == nil) {
        _HeadImage = [[UIImageView  alloc] init];
        _HeadImage.backgroundColor=[UIColor clearColor];
        _HeadImage.contentMode=UIViewContentModeCenter;
            _HeadImage.image= [UIImage imageNamed:@"set_service_url"];
        
    }
    return _HeadImage;
}

-(UILabel*)ExplanationLable
{
    if (_ExplanationLable == nil) {
        _ExplanationLable = [[UILabel  alloc] init];
        _ExplanationLable.textColor=[UIColor whiteColor];
        _ExplanationLable.numberOfLines=3;
        _ExplanationLable.font=[UIFont systemFontOfSize:14];
        _ExplanationLable.text=@"Your site name is your 51Desk.com web address (eg:my company 51desk.com,the sitename is my company)";
        
    }
    return _ExplanationLable;
}

-(UILabel*)EmailLable
{
    if (_EmailLable == nil) {
        _EmailLable = [[UILabel  alloc] init];
        _EmailLable.text=@"@51Desk.cn";
        _EmailLable.textColor=[UIColor whiteColor];
    }
    return _EmailLable;
}




@end


@implementation UITextFieldEx


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
}

@end
