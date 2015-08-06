//
//  MessageCenter.m
//  eisookom
//
//  Created by eisoo on 13-12-11.
//  Copyright (c) 2013年 eisoo. All rights reserved.
//

#import "AlertMessageCenter.h"
Class object_getClass(id object);
@implementation WarmView
@synthesize userInfo=_userInfo;

- (id)init
{
    self = [super init];
    if (self) {
#ifdef NOTIFICATION_SHOWMESSAGESERVICE
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SHOWWITHWINDOW object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWithWindow:) name:NOTIFICATION_SHOWWITHWINDOW object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_HIDDENWITHWINDOW object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenWithWindow) name:NOTIFICATION_HIDDENWITHWINDOW object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SHOWINWINDOW object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInWindow:) name:NOTIFICATION_SHOWINWINDOW object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_HIDDENINWINDOW object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenInWindow) name:NOTIFICATION_HIDDENINWINDOW object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SHOWCUSTOMVIEW object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCustomView:) name:NOTIFICATION_SHOWCUSTOMVIEW object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_HIDDENCUSTOMVIEW object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenCustomView) name:NOTIFICATION_HIDDENCUSTOMVIEW object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SHOWCUSTOMVIEWCONTROLLER object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCustomViewController:) name:NOTIFICATION_SHOWCUSTOMVIEWCONTROLLER object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_HIDDENCUSTOMVIEWCONTROLLER object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenCustomViewController) name:NOTIFICATION_HIDDENCUSTOMVIEWCONTROLLER object:nil];
        

        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SHOWINWINDOW_BELOW object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInWindowbelow:) name:NOTIFICATION_SHOWINWINDOW_BELOW object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_HIDDENINWINDOW_BELOW object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenInWindowbelow) name:NOTIFICATION_HIDDENINWINDOW_BELOW object:nil];
#endif
    }
    return self;
}

-(void)dealloc
{
#ifdef NOTIFICATION_SHOWMESSAGESERVICE
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SHOWWITHWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_HIDDENWITHWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SHOWINWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_HIDDENINWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SHOWCUSTOMVIEW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_HIDDENCUSTOMVIEW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SHOWCUSTOMVIEWCONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_HIDDENCUSTOMVIEWCONTROLLER object:nil];
    

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SHOWINWINDOW_BELOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_HIDDENINWINDOW_BELOW object:nil];
#endif
    [msgView release];msgView=nil;
    [kepWindow release];kepWindow=nil;
    [message release];message=nil;
    [window release];window=nil;
    [vCTR release];vCTR=nil;
    [_userInfo release];_userInfo=nil;
    [super dealloc];
}


-(void)setUserInfo:(NSDictionary *)userInfo
{
    if (userInfo!=_userInfo) {
        [_userInfo release];
        _userInfo=[userInfo retain];
        message=[userInfo objectForKey:@"MESSAGE"];
        duringTime = [[userInfo objectForKey:@"TIME"] floatValue];
    }
}

#pragma mark show with window--

-(void)showWithWindow:(NSNotification *)note
{
    @synchronized(self)
    {
        NSDictionary *dict=[NSDictionary dictionaryWithDictionary:note.userInfo];
        self.userInfo=dict;
        dispatch_async(dispatch_get_main_queue(), ^{
            window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            UIViewController *vCTRs=[[UIViewController alloc] init];
            window.rootViewController=vCTRs;
            Release(vCTRs);
            kepWindow=[UIApplication sharedApplication].keyWindow;
            
            [window makeKeyAndVisible];
            window.windowLevel+=kepWindow.windowLevel;
            vCTRs.view.backgroundColor=[UIColor clearColor];
            CGRect frame=CGRectMake((kepWindow.frame.size.width-kepWindow.frame.size.width/3)/2, 100, kepWindow.frame.size.width/3, 0.618*(kepWindow.frame.size.width/3));
            
            UIView *_v=[[UIView alloc] initWithFrame:frame];
            [vCTRs.view addSubview:_v];
            _v.center=window.center;
            [_v release];
            
            UIView *v1=[[UIView alloc] initWithFrame:_v.bounds];
            v1.backgroundColor=[UIColor blackColor];
            v1.alpha=0.9;
            v1.layer.cornerRadius=5.0f;
            [vCTRs.view addSubview:v1];
            v1.center=window.center;
            [v1 release];
            
            UILabel *label=[[UILabel alloc] initWithFrame:_v.bounds];
            label.backgroundColor=[UIColor clearColor];
            label.textAlignment=UITextAlignmentCenter;
            label.text=message;
            label.textColor=[UIColor whiteColor];
            [vCTRs.view addSubview:label];
            label.center=window.center;
            [label release];
            
            CGAffineTransform trans=CGAffineTransformMakeScale(0.3, 0.3);
//            vCTR.view.transform=trans;
//            __block UIViewController *selfvCtr=vCTR;
            __block UIWindow *selfW=window;
            CGAffineTransform trans2=CGAffineTransformMakeScale(0.5, 0.5);
//            selfvCtr.view.transform=trans2;
            selfW.transform=trans2;
            [UIView animateWithDuration:0.2 animations:^{
//                if (selfvCtr!=nil&&object_getClass(selfvCtr)==object_getClass(vCTR)) {
//                    selfvCtr.view.transform=CGAffineTransformMakeScale(1.2, 1.2);
//                }
                if (window!=nil&&object_getClass(selfW)==object_getClass(window)) {
                    selfW.transform=CGAffineTransformMakeScale(1.2, 1.2);
                }
                
            } completion:^(BOOL flag){
                [UIView animateWithDuration:0.1 animations:^{
//                    if (selfvCtr!=nil&&object_getClass(selfvCtr)==object_getClass(vCTR)) {
//                        selfvCtr.view.transform=CGAffineTransformIdentity;
//                    }
                    if (window!=nil&&object_getClass(selfW)==object_getClass(window)) {
                        selfW.transform=CGAffineTransformIdentity;
                    }
                    
                } completion:^(BOOL finish){
                    if (duringTime!=0.0f) {
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            if (selfvCtr!=nil&&object_getClass(selfvCtr)==object_getClass(vCTR)) {
//                                [self performSelector:@selector(hiddenWithWindow) withObject:nil afterDelay:duringTime];
//                            }
                            if (window!=nil&&object_getClass(selfW)==object_getClass(window)) {
                                [self performSelector:@selector(hiddenWithWindow) withObject:nil afterDelay:duringTime];
                            }
                            
                        });
                    }
                }];
            }];
        });
    }
}

-(void)hiddenWithWindow
{
    @synchronized(self)
    {
//        [vCTR release];vCTR=nil;
        window.rootViewController=nil;
        [window resignKeyWindow];
        [kepWindow makeKeyAndVisible];
        [window release];window=nil;
    }
    
//    __block UIWindow *selfW=window;//b0
//    __block UIViewController *selfvCtr=vCTR;//40
//    __block UIWindow *keyW=kepWindow;//30
//    [selfvCtr dismissModalViewControllerAnimated:NO];
//    [selfvCtr release];selfvCtr=nil;
//    [selfW resignKeyWindow];
//    [keyW makeKeyAndVisible];
//    [selfW release];selfW=nil;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:0.1 animations:^{
//            CGAffineTransform trans2=CGAffineTransformMakeScale(1.2, 1.2);
//            selfvCtr.view.transform=trans2;
//        } completion:^(BOOL flag){
//            [UIView animateWithDuration:0.2 animations:^{
//                CGAffineTransform trans2=CGAffineTransformMakeScale(0.3, 0.3);
//                selfvCtr.view.alpha=0.1;
//                selfvCtr.view.transform=trans2;
//            } completion:^(BOOL flag){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [selfvCtr dismissModalViewControllerAnimated:NO];
//                    [selfvCtr release];selfvCtr=nil;
//                    [selfW resignKeyWindow];
//                    [keyW makeKeyAndVisible];
//                    [selfW release];selfW=nil;
//                });
//            }];
//        }];
//    });
}

#pragma mark show in window--
-(void)showInWindow:(NSNotification *)note
{
    
    @synchronized(self)
    {
        NSDictionary *dict=[NSDictionary dictionaryWithDictionary:note.userInfo];
        self.userInfo=dict;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (msgView==nil) {
                UIWindow *currentWindow=[UIApplication sharedApplication].keyWindow;
                CGRect frame=CGRectMake((currentWindow.frame.size.width-currentWindow.frame.size.width/3)/2, 100, currentWindow.frame.size.width/3, 0.618*(currentWindow.frame.size.width/3));
                bgView=[[UIView alloc]initWithFrame:CGRectMake(0, IOS_7?64:44, 320, 416+def_addHeight)];
                msgView=[[UIView alloc] initWithFrame:frame];
                msgView.center=currentWindow.center;
                [currentWindow addSubview:bgView];
                [currentWindow addSubview:msgView];
                
            }
            msgView.backgroundColor=[UIColor clearColor];
            
            UIView *v1=[[UIView alloc] initWithFrame:msgView.bounds];
            v1.backgroundColor=[UIColor blackColor];
            v1.alpha=0.9;
            v1.layer.cornerRadius=5.0f;
            [msgView addSubview:v1];
            [v1 release];
            
            UILabel *label=[[UILabel alloc] initWithFrame:msgView.bounds];
            label.backgroundColor=[UIColor clearColor];
            label.textAlignment=UITextAlignmentCenter;
            label.text=message;
            label.textColor=[UIColor whiteColor];
            label.numberOfLines=0;
            label.lineBreakMode=UILineBreakModeTailTruncation;
            label.adjustsFontSizeToFitWidth=YES;
            label.font=[UIFont systemFontOfSize:15];
            [msgView addSubview:label];
            [label release];
            
            
            __block UIView *bloclView=msgView;
            [UIView animateWithDuration:0.2 animations:^{
                CGAffineTransform trans=CGAffineTransformMakeScale(1.2, 1.2);
                if (bloclView!=nil&&object_getClass(bloclView)==object_getClass(msgView)) {
                     bloclView.transform=trans;
                }
               
            } completion:^(BOOL finish){
                [UIView animateWithDuration:0.2 animations:^{
                    if (bloclView!=nil&&object_getClass(bloclView)==object_getClass(msgView)) {
                        bloclView.transform=CGAffineTransformIdentity;
                    }
                    
                } completion:^(BOOL finish){
                    if (duringTime!=0) {
                        if (bloclView!=nil&&object_getClass(bloclView)==object_getClass(msgView)) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self performSelector:@selector(hiddenInWindow) withObject:nil afterDelay:duringTime];
                            });
                        }
                       
                    }
                }];
            }];
        });
    }
    
}

-(void)hiddenInWindow
{
    @synchronized(self)
    {
        [bgView removeFromSuperview];
        [bgView release];bgView=nil;
        [msgView removeFromSuperview];
        [msgView release];msgView=nil;
    }
    
}

#pragma mark show custom view
-(void)showCustomView:(NSNotification *)note
{
    @synchronized(customView)
    {
        UIView *view=note.object;
        customView=[[UIView alloc] initWithFrame:view.frame];
        view.frame=view.bounds;
        [customView addSubview:view];
        CGRect frame=customView.frame;
        kepWindow=[UIApplication sharedApplication].keyWindow;
        frame=kepWindow.frame;
        [kepWindow addSubview:customView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGAffineTransform trans2=CGAffineTransformMakeScale(0.5, 0.5);
            
            customView.transform=trans2;
            [UIView animateWithDuration:0.2 animations:^{
                customView.transform=CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL flag){
                [UIView animateWithDuration:0.1 animations:^{
                    customView.transform=CGAffineTransformIdentity;
                } completion:^(BOOL finish){
                    
                }];
            }];
        });
    }

}

-(void)hiddenCustomView
{
    
    @synchronized(customView)
    {
        [customView setHidden:YES];
        [customView removeFromSuperview];
        [customView release];
        customView=nil;
    }
    

    
    
    /*
//    __block UIWindow *selfW=window;//b0
//    __block UIViewController *selfvCtr=vCTR;//40
//    __block UIWindow *keyW=kepWindow;//30
    if (customView==nil) {
        return;
    }
    __block UIView *cusV=customView;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            CGAffineTransform trans2=CGAffineTransformMakeScale(1.2, 1.2);
            customView.transform=trans2;
//            selfvCtr.view.transform=trans2;
        } completion:^(BOOL flag){
            [UIView animateWithDuration:0.2 animations:^{
                CGAffineTransform trans2=CGAffineTransformMakeScale(0.0, 0.0);
                customView.transform=trans2;
//                selfvCtr.view.transform=trans2;
            } completion:^(BOOL flag){
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [customView removeFromSuperview];
//                    [customView release];
//                    customView=nil;
//                    [selfvCtr dismissModalViewControllerAnimated:NO];
//                    [selfvCtr release];selfvCtr=nil;
//                    [selfW resignKeyWindow];
//                    [keyW makeKeyAndVisible];
//                    [selfW release];selfW=nil;
                    
                });
            }];
        }];
    });
     */
}

#pragma mark show custom viewcontroller--

-(void)showCustomViewController:(NSNotification *)note
{
    @synchronized(window)
    {
        UIViewController *viewController=note.object;
        dispatch_async(dispatch_get_main_queue(), ^{
            window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            UIViewController *ctr=viewController;
            window.rootViewController=ctr;
            if (IOS_7) {
                ctr.automaticallyAdjustsScrollViewInsets=NO;
            }
            kepWindow=[UIApplication sharedApplication].keyWindow;
//            window.windowLevel+=kepWindow.windowLevel+1;
            [window makeKeyAndVisible];
            __block UIWindow *selfvCtr=window;
            CGAffineTransform trans2=CGAffineTransformMakeScale(0.5, 0.5);
            selfvCtr.transform=trans2;
            [UIView animateWithDuration:0.2 animations:^{
//                selfvCtr.transform=CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL flag){
                [UIView animateWithDuration:0.1 animations:^{
                    selfvCtr.transform=CGAffineTransformIdentity;
                } completion:^(BOOL finish){
                    
                }];
            }];
        });
    }
    
}

-(void)hiddenCustomViewController
{
    @synchronized(window)
    {
        [kepWindow makeKeyAndVisible];
        [window resignKeyWindow];
        Dealloc(window);
        
        
//        __block UIWindow *selfW=window;//b0
//        __block UIViewController *selfvCtr=window.rootViewController;//40
//        __block UIWindow *keyW=kepWindow;//30
        /*
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.1 animations:^{
                CGAffineTransform trans2=CGAffineTransformMakeScale(1.2, 1.2);
                selfvCtr.view.transform=trans2;
            } completion:^(BOOL flag){
                [UIView animateWithDuration:0.2 animations:^{
                    CGAffineTransform trans2=CGAffineTransformMakeScale(0.0, 0.0);
                    selfvCtr.view.transform=trans2;
                } completion:^(BOOL flag){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [selfW resignKeyWindow];
                        [keyW makeKeyAndVisible];
                        [selfW release];selfW=nil;
                    });
                }];
            }];
        });
         */
    }
    
}



#pragma mark show in window--
-(void)showInWindowbelow:(NSNotification *)note
{
    
    @synchronized(self)
    {
        NSDictionary *dict=[NSDictionary dictionaryWithDictionary:note.userInfo];
        self.userInfo=dict;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (msgView==nil) {
                UIWindow *currentWindow=[UIApplication sharedApplication].keyWindow;
                CGRect frame=CGRectMake((currentWindow.frame.size.width-currentWindow.frame.size.width/3)/2, 416+def_addHeight, currentWindow.frame.size.width-50, 0.618*(currentWindow.frame.size.width/3));
                bgView=[[UIView alloc]initWithFrame:CGRectMake(0, IOS_7?64:44, 320, 416+def_addHeight)];
                msgView=[[UIView alloc] initWithFrame:frame];
                msgView.center=CGPointMake(320/2,416+def_addHeight-50);
                [currentWindow addSubview:bgView];
                [currentWindow addSubview:msgView];
                
            }
            msgView.backgroundColor=[UIColor clearColor];
            
            UIView *v1=[[UIView alloc] initWithFrame:msgView.bounds];
            v1.backgroundColor=[UIColor blackColor];
            v1.alpha=0.9;
            v1.layer.cornerRadius=5.0f;
            [msgView addSubview:v1];
            [v1 release];
            
            UILabel *label=[[UILabel alloc] initWithFrame:msgView.bounds];
            label.backgroundColor=[UIColor clearColor];
            label.textAlignment=UITextAlignmentCenter;
            label.text=message;
            label.textColor=[UIColor whiteColor];
            label.numberOfLines=0;
            label.lineBreakMode=UILineBreakModeTailTruncation;
            label.adjustsFontSizeToFitWidth=YES;
            label.font=[UIFont systemFontOfSize:15];
            [msgView addSubview:label];
            [label release];
            
            
            __block UIView *bloclView=msgView;
            [UIView animateWithDuration:0.2 animations:^{
                CGAffineTransform trans=CGAffineTransformMakeScale(1.2, 1.2);
                if (bloclView!=nil&&object_getClass(bloclView)==object_getClass(msgView)) {
                    bloclView.transform=trans;
                }
                
            } completion:^(BOOL finish){
                [UIView animateWithDuration:0.2 animations:^{
                    if (bloclView!=nil&&object_getClass(bloclView)==object_getClass(msgView)) {
                        bloclView.transform=CGAffineTransformIdentity;
                    }
                    
                } completion:^(BOOL finish){
                    if (duringTime!=0) {
                        if (bloclView!=nil&&object_getClass(bloclView)==object_getClass(msgView)) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self performSelector:@selector(hiddenInWindow) withObject:nil afterDelay:duringTime];
                            });
                        }
                        
                    }
                }];
            }];
        });
    }
    
}

-(void)hiddenInWindowbelow
{
    @synchronized(self)
    {
        [bgView removeFromSuperview];
        [bgView release];bgView=nil;
        [msgView removeFromSuperview];
        [msgView release];msgView=nil;
    }
    
}



@end

///////////////////////////////////////////////////
@implementation AlertMessageCenter

+(void)showWaittingWindow:(NSString *)message during:(float)time
{
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:message,@"MESSAGE",[NSNumber numberWithFloat:time],@"TIME", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOWWITHWINDOW object:nil userInfo:dict];
}

+(void)hiddenMessageWindow
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDDENWITHWINDOW object:nil];
}


/**/
+(void)showWaittingView:(NSString *)message during:(float)time
{
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:message,@"MESSAGE",[NSNumber numberWithFloat:time],@"TIME", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOWINWINDOW object:nil userInfo:dict];
}

+(void)hiddenMessageView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDDENINWINDOW object:nil];
}
/**/
+(void)showCustomView:(id)view
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOWCUSTOMVIEW object:view userInfo:nil];
}
+(void)hiddenCustomView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDDENCUSTOMVIEW object:nil];
}
+(void)showCustomViewController:(id)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOWCUSTOMVIEWCONTROLLER object:viewController userInfo:nil];
}
+(void)hiddenCustomViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDDENCUSTOMVIEWCONTROLLER object:nil];
}


/**/
+(void)showWaittingViewbelow:(NSString *)message during:(float)time
{
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:message,@"MESSAGE",[NSNumber numberWithFloat:time],@"TIME", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOWINWINDOW_BELOW object:nil userInfo:dict];
}

+(void)hiddenMessageBelowView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDDENINWINDOW_BELOW object:nil];
}
/**/

@end



