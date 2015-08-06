//
//  ModuleDataErrorControl.m
//  DESK
//
//  Created by 51desk on 15/7/16.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "ModuleDataErrorControl.h"

@implementation ModuleDataErrorControl


-(void)DataTryingError
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView * image=[[UIImageView alloc ]initWithFrame: CGRectMake(20, 80, self.frame.size.width-40, 40)];
    image.contentMode=UIViewContentModeCenter;
    image.image= [UIImage imageNamed:@"set_service_url"];
    [self addSubview:image];
    
    UILabel * descriptionlabel=[[UILabel alloc ]initWithFrame: CGRectMake(20, 80, self.frame.size.width-40, 60)];
    [descriptionlabel top:0  FromView:image];
    descriptionlabel.text=@"We are trying our best to analyze date for you please wait a moment";
    descriptionlabel.numberOfLines=0;
    descriptionlabel.textAlignment=NSTextAlignmentCenter;
     [self addSubview:descriptionlabel];
    

}


-(void)DataOuthError
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   UIImage * image= [UIImage imageNamed:@"set_service_url"];
    UIImageView * imageview=[[UIImageView alloc ]initWithFrame: CGRectMake(20, 0, self.frame.size.width-40, image.size.height)];
    imageview.image= image;
      imageview.contentMode = UIViewContentModeCenter;
    [self addSubview:imageview];
    
    UILabel * descriptionlabel=[[UILabel alloc ]initWithFrame: CGRectMake(20, 80, self.frame.size.width-40, 60)];
    [descriptionlabel top:0  FromView:imageview];
    descriptionlabel.numberOfLines=0;
    descriptionlabel.text=@"Sorry,we can't show the result for you,You need finish";
    descriptionlabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:descriptionlabel];
    
    
    UITableView *_appTableView=[[UITableView alloc]initWithFrame: CGRectMake(10, 140, self.frame.size.width-20, self.frame.size.height-descriptionlabel.frame.size.height+self.frame.size.height-descriptionlabel.frame.origin.y)];
    _appTableView.delegate=self;
    _appTableView.dataSource=self;
    _appTableView.backgroundColor=[UIColor clearColor];
    [_appTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_appTableView];
    
    [_appTableView top:0  FromView:descriptionlabel];

    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(60, cellHeight-1, SCREEN_WIDTH-60, 1)];
        [cell addSubview:line];
        
//        line.backgroundColor=[PublicMethods getAlphaColor:@"#a4a4a4" alpha:1.0];
        
        
        UIImageView *headimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, cellHeight-20, cellHeight-20)];
        [cell addSubview:headimg];
        headimg.backgroundColor=[UIColor clearColor];
        headimg.image=[UIImage imageNamed:@"secondsales"];
        
        
        UIImageView *goimg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-cellHeight, 10, cellHeight-20, cellHeight-20)];
        [cell addSubview:goimg];
        goimg.backgroundColor=[UIColor clearColor];
        goimg.image=[UIImage imageNamed:@"secondsales"];
        
        UILabel * name=[[UILabel alloc]initWithFrame:CGRectMake(headimg.frame.origin.x+headimg.frame.size.width+10, 10, SCREEN_WIDTH-headimg.frame.origin.x-headimg.frame.size.width, cellHeight-20)];
        [cell addSubview:name];
        name.backgroundColor=[UIColor clearColor];
        name.textColor=[UIColor blueColor];
        name.font=[UIFont systemFontOfSize:18];
        name.tag=1001;
        
        
        
        cell.backgroundColor=[UIColor clearColor];
        
    }
    
    
    if (indexPath.row==0) {
        ((UILabel*)  [cell viewWithTag:1001]  ).text=@"salesforce";
    }else if (indexPath.row==1) {
        ((UILabel*)  [cell viewWithTag:1001]  ).text=@"desk";
        
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



@end
