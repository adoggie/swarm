//
//  InitOauthViewController.h
//  DESK
//
//  Created by 51desk on 15/7/1.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "BaseViewController.h"

@interface InitOauthViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIButton * nextbtn;
@property  (nonatomic,strong) UILabel * descriptionlabel;
@property(nonatomic,strong)UITableView * appTableView;
@end
