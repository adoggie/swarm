//
//  MessageCenter.h
//  eisookom
//
//  Created by eisoo on 13-12-11.
//  Copyright (c) 2013年 eisoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeskCommonConfig.h"


// 提示框 nofification regist key
#define NOTIFICATION_SHOWMESSAGESERVICE  @"NOTIFICATION_SHOWMESSAGESERVICE"

#define NOTIFICATION_SHOWWITHWINDOW @"NOTIFICATION_SHOWWITHWINDOW"
#define NOTIFICATION_HIDDENWITHWINDOW @"NOTIFICATION_HIDDENWITHWINDOW"

#define NOTIFICATION_SHOWINWINDOW @"NOTIFICATION_SHOWINWINDOW"
#define NOTIFICATION_HIDDENINWINDOW @"NOTIFICATION_HIDDENINWINDOW"

#define NOTIFICATION_SHOWCUSTOMVIEW @"NOTIFICATION_SHOWCUSTOMVIEW"
#define NOTIFICATION_HIDDENCUSTOMVIEW @"NOTIFICATION_HIDDENCUSTOMVIEW"

#define NOTIFICATION_SHOWCUSTOMVIEWCONTROLLER @"NOTIFICATION_SHOWCUSTOMVIEWCONTROLLER"
#define NOTIFICATION_HIDDENCUSTOMVIEWCONTROLLER @"NOTIFICATION_HIDDENCUSTOMVIEWCONTROLLER"

#define NOTIFICATION_HIDDENMESSAGEVIEW  @"NOTIFICATION_HIDDENMESSAGEVIEW"

#define NOTIFICATION_SHOWINWINDOW_BELOW @"NOTIFICATION_SHOWINWINDOW_BELOW"
#define NOTIFICATION_HIDDENINWINDOW_BELOW @"NOTIFICATION_HIDDENINWINDOW_BELOW"


@interface WarmView : NSObject
{
    NSString *message;
    float duringTime;
    /*show with window*/
    UIWindow *window;
    UIViewController *vCTR;
    UIWindow *kepWindow;
    BOOL *isShowing;
    CGRect _rect;
    /*show in window*/
    UIView *msgView;
    UIView *bgView;
    /*custom view*/
    UIView *customView;
}


-(void)showWithWindow:(NSNotification *)note;
-(void)hiddenWithWindow;

-(void)showInWindow:(NSNotification *)note;
-(void)hiddenInWindow;

-(void)showCustomView:(NSNotification *)note;
-(void)hiddenCustomView;

-(void)showCustomViewController:(NSNotification *)note;
-(void)hiddenCustomViewController;

@property (nonatomic,retain)NSDictionary *userInfo;
@end



@interface AlertMessageCenter : NSObject
+(void)showWaittingWindow:(NSString *)message during:(float)time;
+(void)hiddenMessageWindow;

+(void)showWaittingView:(NSString *)message during:(float)time;
+(void)hiddenMessageView;


+(void)showWaittingViewbelow:(NSString *)message during:(float)time;
+(void)hiddenMessageBelowView;

+(void)showCustomView:(UIView *)view;
+(void)hiddenCustomView;

+(void)showCustomViewController:(id)viewController;
+(void)hiddenCustomViewController;
@end




