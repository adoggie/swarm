//
//  ViewController.h
//  DESK
//
//  Created by xingweihuang on 15/5/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//


#import "DeskHttpRequest.h"
#import "DeskUIConstantDefine.h"
#import "UIView+AEBHandyAutoLayout.h"
#import "UIView+LayoutMethods.h"
#import "PublicMethods.h"
#import "DeskCommonConfig.h"
#import "AppDelegate.h"
#import "URLScheme.h"
#import "UserDataModel.h"
#import "AlertMessageCenter.h"
#import "UserDataModel.h"
#import "PNTToolbar.h"


@interface BaseViewController : UIViewController<DeskHttpRequestDelegate>{



}
@property ( nonatomic,strong)  UIScrollView *scrollViewForm;
@property ( nonatomic,strong)  UIView *contentView;
-(void)initScrollView;
-(AppDelegate *)getAppDelegate;
-(void)waitViewShow;
-(void)waitViewHidden;
-(void)initbackBarItem;
-(void)initLeftBaritem:(NSString*)imagename;


@end

