//
//  ViewController.m
//  DESK
//
//  Created by xingweihuang on 15/5/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    if ([self.navigationController.navigationBar  respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        // UIBarMetricsLandscapePhone
        [self.navigationController.navigationBar setBackgroundImage:[PublicMethods createImageWithColor:DESKCOLOR(0x93ce69)] forBarMetrics:UIBarMetricsDefault];
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];        
    }
     [self.view setBackgroundColor: DESKCOLOR(0xf2f1f1)  ];
  
    

}

-(void)initScrollView
{
    [self.view  addSubview: self.scrollViewForm ];
    [self.scrollViewForm addSubview: self.contentView ];
    _scrollViewForm.contentSize =CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _scrollViewForm.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _contentView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(AppDelegate *)getAppDelegate
{
   return [UIApplication sharedApplication].delegate ;
}

-(void)initbackBarItem
{
    UIButton *left_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    left_btn.frame=CGRectMake(0, 0, 33, 33);
    [left_btn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [left_btn addTarget:self action:@selector(backAndCancelNet) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bbi1=[[UIBarButtonItem alloc] initWithCustomView:left_btn];
    self.navigationItem.leftBarButtonItem=bbi1;

}

-(void)initLeftBaritem:(NSString*)imagename
{

    
    UIButton *left_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    left_btn.frame=CGRectMake(0, 0, 33, 33);
    [left_btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [left_btn addTarget:self action:@selector(leftBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bbi1=[[UIBarButtonItem alloc] initWithCustomView:left_btn];
    self.navigationItem.leftBarButtonItem=bbi1;

}

-(void)leftBarButtonItemClick
{

}

-(void)backAndCancelNet
{
    // [super backAndCancelNet];
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)waitViewShow
{
    UIView *_v=[[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 416+def_addHeight)];
    //    _v.backgroundColor=[UIColor purpleColor];
    UIView *v1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 61.8, 61.8)];
    v1.backgroundColor=[UIColor blackColor];
    v1.alpha=0.9;
    v1.layer.cornerRadius=5.0f;
    v1.center=CGPointMake(320/2, (416+def_addHeight)/2);
    [_v addSubview:v1];
  
    UIActivityIndicatorView *ind=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    ind.center=CGPointMake(320/2, (416+def_addHeight)/2);;
    [_v addSubview:ind];
 
    [ind startAnimating];
    [AlertMessageCenter showCustomView:_v];
 
}
-(void)waitViewHidden
{
    [AlertMessageCenter hiddenCustomView];
}


-(UIScrollView*)scrollViewForm
{
    if (_scrollViewForm == nil) {
        _scrollViewForm = [[UIScrollView  alloc] init];
    }
    return _scrollViewForm;
}

-(UIView*)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView  alloc] init];
    }
    return _contentView;
}


@end
