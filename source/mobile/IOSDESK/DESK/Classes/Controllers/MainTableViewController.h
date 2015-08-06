//
//  MainTableViewController.h
//  DESK
//
//  Created by 51desk on 15/6/9.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "BaseViewController.h"
#include "SalesAnalyticsViewCtr.h"

@interface MainTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign) NSInteger  TabIndex;
@property(nonatomic,strong)UITableView * ContentTableView;

@end
