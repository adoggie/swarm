//
//  InitOauthViewController.m
//  DESK
//
//  Created by 51desk on 15/7/1.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "InitOauthViewController.h"
#import "OauthWebViewController.h"
#import "OauthViewController.h"

#define cellHeight 60

@interface InitOauthViewController ()

@end

@implementation InitOauthViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OAUTH_SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oauthSuccess:) name:@"OAUTH_SUCCESS" object:nil];

    [self.view setBackgroundColor: DESKCOLOR( 0xe353c4e) ] ;
    [self.view addSubview:self.nextbtn];
    [self.view addSubview:self.descriptionlabel];
    
    [self.view addSubview:self.appTableView];
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([self.navigationController.navigationBar  respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        // UIBarMetricsLandscapePhone
        [self.navigationController.navigationBar setBackgroundImage:[PublicMethods createImageWithColor:DESKCOLOR(0x2f3545)] forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton=YES;
    
    _descriptionlabel.frame=CGRectMake(20,10, SCREEN_WIDTH-40, 60);
    _appTableView.frame=CGRectMake(0,10,SCREEN_WIDTH, VIEW_SCREEN_HEIGHT-  _descriptionlabel.frame.origin.y-_descriptionlabel.frame.size.height-70);
    [_appTableView top:0  FromView:_descriptionlabel];
    _nextbtn.frame=CGRectMake( 40,VIEW_SCREEN_HEIGHT-70, SCREEN_WIDTH-80, 40);
    
}

-(void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OAUTH_SUCCESS" object:nil];

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


-(void)sfBtnClick
{
    
    
    OauthWebViewController * oauth=[[OauthWebViewController alloc]init];
    [self.navigationController pushViewController:oauth animated:YES];
    NSString *STR =@"https://172.20.0.213:8443/desk/ap/sflogin.do";
    
    oauth. outLink =[NSString stringWithFormat:@"%@?SESSION-TOKEN=%@",STR, [UserManager shareMainUser].session_token] ;
   oauth.  oauthType=@"Salesforce";
    oauth.title=@"Salesforce 授权";
    
}

-(void)DeskBtnClick
{
    //    OauthViewController * ctr=[[OauthViewController alloc]init];
    //    NSString *STR =@"https://172.20.0.181:8443/desk/ap/sflogin.do";
    //
    //    loginctr.outLink =[NSString stringWithFormat:@"%@?SESSION-TOKEN=%@",STR, [UserManager shareMainUser].session_token] ;
    //    [self.navigationController pushViewController:ctr animated:YES];
    //    ctr.title=@"Desk 授权";
    
    OauthWebViewController * oauth=[[OauthWebViewController alloc]init];
    [self.navigationController pushViewController:oauth animated:YES];
    NSString *STR =@"https://172.20.0.213:8443/desk/ap/desklogin.do";
      oauth.  oauthType=@"desk";
    oauth. outLink =[NSString stringWithFormat:@"%@?SESSION-TOKEN=%@&site=%@",STR, [UserManager shareMainUser].session_token,@"yy002"] ;
    oauth.title=@"Desk 授权";
    
    
}


-(void)oauthSuccess:(NSNotification*) notification
{
   NSString * type= notification.object;
    
    if ([type isEqualToString:@"desk"]) {
        [[UserManager shareMainUser].oauthStatus  setObject: [NSNumber numberWithBool:YES] forKey:@"desk"];
    }else
        [[UserManager shareMainUser].oauthStatus   setObject: [NSNumber numberWithBool:YES] forKey:@"salesforce"];
    
    
    [_appTableView reloadData];
}

-(void)NextBtnClick:(id)btn
{
    [[self getAppDelegate ] AppdelegateLogIn];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(60, cellHeight-1, SCREEN_WIDTH-60, 1)];
        [cell addSubview:line];
        
        line.backgroundColor=[PublicMethods getAlphaColor:@"#a4a4a4" alpha:1.0];
        
        
        UIImageView *headimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, cellHeight-20, cellHeight-30)];
        [cell addSubview:headimg];
        headimg.tag=1002;
        headimg.backgroundColor=[UIColor clearColor];
        headimg.image=[UIImage imageNamed:@"secondsales"];
        
        
        UIImageView *goimg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-cellHeight, 15, cellHeight-20, cellHeight-30)];
        [cell addSubview:goimg];
        goimg.tag=1003;
        goimg.backgroundColor=[UIColor clearColor];

        
        UILabel * name=[[UILabel alloc]initWithFrame:CGRectMake(headimg.frame.origin.x+headimg.frame.size.width+10, 10, SCREEN_WIDTH-headimg.frame.origin.x-headimg.frame.size.width, cellHeight-20)];
        [cell addSubview:name];
        name.backgroundColor=[UIColor clearColor];
        name.textColor=[UIColor whiteColor];
        name.font=[UIFont systemFontOfSize:18];
        name.tag=1001;
        
        cell.backgroundColor=[UIColor clearColor];
        
    }
    

    UIImageView * goimage= (UIImageView*)  [cell viewWithTag:1003];
    goimage.image=[UIImage imageNamed:@"oauth_u"];
    if (indexPath.row==0) {
        ((UILabel*)  [cell viewWithTag:1001]  ).text=@"salesforce";
        ((UIImageView*)  [cell viewWithTag:1002]  ).image=[UIImage imageNamed:@"salesforce"];
        DLog(@"%@",[UserManager shareMainUser].oauthStatus);
        if ([[[UserManager shareMainUser].oauthStatus objectForKey:@"salesforce"] boolValue]==YES) {
          goimage.image=[UIImage imageNamed:@"oauth_s"];
        }
    
        
    }else if (indexPath.row==1) {
        ((UILabel*)  [cell viewWithTag:1001]  ).text=@"desk";
        ((UIImageView*)  [cell viewWithTag:1002]  ).image=[UIImage imageNamed:@"desk"];
        if (([[[UserManager shareMainUser].oauthStatus objectForKey:@"desk"] boolValue]==YES)) {
            goimage.image=[UIImage imageNamed:@"oauth_s"];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self sfBtnClick];
    }else if (indexPath.row==1) {
        [self DeskBtnClick];
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(UITableView*)appTableView
{
    
    if (_appTableView==nil) {
        _appTableView=[[UITableView alloc]init];
        _appTableView.delegate=self;
        _appTableView.dataSource=self;
        _appTableView.backgroundColor=[UIColor clearColor];
        [_appTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _appTableView;
}

- (UIButton *)nextbtn
{
    if (_nextbtn == nil) {
        _nextbtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        _nextbtn.backgroundColor=[PublicMethods getAlphaColor:@"93ce69" alpha:1.0];
        [_nextbtn.layer setMasksToBounds:YES];
        [_nextbtn.layer setCornerRadius:20.0]; //设置矩形四个圆角半径
        [_nextbtn setTitle:@"next" forState:UIControlStateNormal];
        [_nextbtn addTarget:self action: @selector(NextBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextbtn;
}
- (UILabel *)descriptionlabel
{
    if (_descriptionlabel == nil) {
        _descriptionlabel = [[UILabel  alloc]init];
        _descriptionlabel.backgroundColor=[UIColor clearColor];
        _descriptionlabel.text=@"Deployed those tow application authentication";
        _descriptionlabel.textColor=DESKCOLOR(0xe7e3e2);
        _descriptionlabel.numberOfLines=2;
        
    }
    return _descriptionlabel;
}


@end
