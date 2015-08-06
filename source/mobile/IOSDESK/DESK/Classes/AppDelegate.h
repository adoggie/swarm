//
//  AppDelegate.h
//  DESK
//
//  Created by xingweihuang on 15/5/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "DDMenuController.h"
#import "MLNavigationController.h"
#import "AlertMessageCenter.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

-(void)AppdelegateLogIn;
-(void)AppLogInOut;
+(DDMenuController *)getDDMCTR;
+(MLNavigationController *)getMLNavcation;
@end

