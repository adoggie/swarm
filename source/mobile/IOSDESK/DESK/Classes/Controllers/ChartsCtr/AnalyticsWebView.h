//
//  AnalyticsWebView.h
//  DESK
//
//  Created by 51desk on 15/7/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//


#import "BaseViewController.h"

@interface AnalyticsWebView : BaseViewController<UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicatorView;
}

@property (nonatomic,strong)  UIWebView *webView;


@end