//
//  ModuleDataErrorControl.h
//  DESK
//
//  Created by 51desk on 15/7/16.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AEBHandyAutoLayout.h"
#import "UIView+LayoutMethods.h"
#define cellHeight 60

@interface ModuleDataErrorControl : UIControl<UITableViewDelegate,UITableViewDataSource>
-(void)DataTryingError;
-(void)DataOuthError;

@end
