//
//  OauthWebViewController.h
//  DESK
//
//  Created by 51desk on 15/6/23.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "BaseViewController.h"

@interface OauthWebViewController : BaseViewController<UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicatorView;
}

@property (nonatomic,strong)  UIWebView *webView;
@property (nonatomic ,strong)NSString * authurl ;
@property (nonatomic ,assign) BOOL  authedl ;
@property (nonatomic ,strong)NSString * outLink;
@property (nonatomic,strong) NSString * oauthType;

@end
