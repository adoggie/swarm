//
//  FunnelViewController.m
//  DESK
//
//  Created by 51desk on 15/6/17.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "FunnelViewController.h"
#define cellHeight 44

@interface FunnelViewController ()

@end

@implementation FunnelViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
       [self initbackBarItem];
    [self.view setBackgroundColor:[PublicMethods getAlphaColor:@"353c4e" alpha:1.0f ] ];
    [self.view  addSubview: self.ContentTableView ];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    _ContentTableView.frame=CGRectMake(0,0,self.view.frame.size.width,VIEW_SCREEN_HEIGHT);
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark table delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(5, cellHeight-1, SCREEN_WIDTH-10, 1)];
        [cell addSubview:line];
      
        line.backgroundColor=[PublicMethods getAlphaColor:@"#a4a4a4" alpha:1.0];
        
        
        UILabel * name=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH/3, cellHeight-20)];
        [cell addSubview:name];
        name.backgroundColor=[UIColor clearColor];
        name.textColor=[PublicMethods getAlphaColor:@"#a4a4a4" alpha:1.0];
        name.font=[UIFont systemFontOfSize:16];
        name.text=@"Close Data";

        
        UILabel * time=[[UILabel alloc]initWithFrame:CGRectMake(10, 10,  SCREEN_WIDTH/2, cellHeight-20)];
        [cell addSubview:time];
        time.backgroundColor=[UIColor clearColor];
        time.textColor=[PublicMethods getAlphaColor:@"#4d4c4c" alpha:1.0];
        time.font=[UIFont systemFontOfSize:14];
        time.text=@"2014/05/01-2014/05/01";
        [time right:10 FromView:name];
    
        
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        CloseDataSelectController * ctr=[[CloseDataSelectController alloc]init];
        ctr.title=@"Close Date";
        [self.navigationController pushViewController:ctr animated:YES];
   
      
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

-(UITableView*)ContentTableView
{
    
    if (_ContentTableView==nil) {
        _ContentTableView=[[UITableView alloc]init];
        _ContentTableView.delegate=self;
        _ContentTableView.dataSource=self;
        [_ContentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _ContentTableView;
}

@end
