//
//  AppDelegate.m
//  DESK
//
//  Created by xingweihuang on 15/5/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "AppDelegate.h"
#import "SetServiceURLController.h"
#import "DeskCommonConfig.h"
#import "DDMenuController.h"
#import "MainViewController.h"
#import "LeftMainViewController.h"
#import "MLNavigationController.h"
#import "MainTableViewController.h"

@interface AppDelegate ()
{
  WarmView *_wv;
}

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
 
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 
    // Override point for customization after application launch.
    SetServiceURLController * viewc = [[SetServiceURLController  alloc] init];
    
    
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:viewc];
      viewc.title=@"Sign In";
       UIColor * color = [UIColor whiteColor];
       NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey: NSForegroundColorAttributeName];
      nav.navigationBar.titleTextAttributes = dict;

    
    
    self.window.rootViewController=nav;
    
    
       _wv =[[WarmView alloc] init];
    

    
    [self.window makeKeyAndVisible];
    
    return YES;
}



-(void)AppdelegateLogIn
{
    

  
    MainViewController  *main=[[MainViewController alloc] init];

    MainTableViewController *c1=[[MainTableViewController alloc] init];
    MainTableViewController *c2=[[MainTableViewController alloc] init];

    
    c1.TabIndex=1;
    c2.TabIndex=2;

   
    main.viewControls=[NSMutableArray arrayWithObjects:c1,c2, nil];
    
 
    [main setControlsTitles:[NSArray arrayWithObjects:@"Dashbroad",@"Sales", nil]];
    [main selectControlViewAtIndex:0];
    [main setTabButtonsFrame:CGRectMake(0,  0, SCREEN_WIDTH, 44) withColor:[PublicMethods getAlphaColor:@"#93ce69" alpha:1.0]];
    
    
    
    main.title=@"51Desk Analytics";
    MLNavigationController *nav=[[MLNavigationController alloc] initWithRootViewController:main];
    
    nav.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18],NSFontAttributeName, nil];

    nav.navigationBar.translucent=NO;
    DDMenuController *ddm=[[DDMenuController alloc] initWithRootViewController:nav];
    [ddm setPanEnable:YES];

    LeftMainViewController *left=[[LeftMainViewController alloc] init];
    [ddm setLeftViewController:left];

    self.window.rootViewController=ddm;
    [self.window makeKeyAndVisible];

    
    
    
}



+(DDMenuController *)getDDMCTR
{
    AppDelegate *ap=( AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return (DDMenuController *)ap.window.rootViewController;
}
+(MLNavigationController *)getMLNavcation
{
    AppDelegate *ap=( AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *root=(DDMenuController *)ap.window.rootViewController;
    return (MLNavigationController *)root.rootViewController;
}

-(void)AppLogInOut
{
    
    SetServiceURLController * viewc = [[SetServiceURLController  alloc] init];
    
    
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:viewc];
      viewc.title=@"Sign In";
    nav.navigationBar.translucent=NO;
    
        UIColor * color = [UIColor whiteColor];
        NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey: NSForegroundColorAttributeName];
        nav.navigationBar.titleTextAttributes = dict;
    self.window.rootViewController=nav;
    
    
    

    
    [self.window makeKeyAndVisible];
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
