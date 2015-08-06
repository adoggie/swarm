//
//  FunnelViewController.h
//  DESK
//
//  Created by 51desk on 15/6/17.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "BaseViewController.h"
  #import "CloseDataSelectController.h"

@interface FunnelViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * ContentTableView;
@end
