//
//  OauthWebViewController.m
//  DESK
//
//  Created by 51desk on 15/6/23.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "OauthWebViewController.h"

@interface OauthWebViewController ()

@end

@implementation OauthWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self initbackBarItem];
    _webView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [_webView setUserInteractionEnabled:YES];
    
    
//    NSString *STR=@"3MVG9ZL0ppGP5UrB2Y_hVvDwIhz11aaTxV2fW7zZQ3cJh8CAKU59YBK_eFlgJSQTzVVGqcgbx_tzPy.KuYHfE";
//    NSString *cb=@"https://172.20.0.192:8443/desk/ap/sfcallback.do";
    
   
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:  _outLink] ];
    
    [_webView loadRequest:request];
    
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    
    [activityIndicatorView setCenter: self.view.center] ;
    
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    
    [self.view addSubview : activityIndicatorView] ;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



-(void)dealloc
{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView

{
    
    [activityIndicatorView startAnimating] ;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView

{
    
    [activityIndicatorView stopAnimating];
    
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *str=[request.URL absoluteString];
    DLog(@"urlstr=%@",str);
    
    NSArray *urlComps = [str componentsSeparatedByString:@"://"];
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps
                                                       objectAtIndex:1] componentsSeparatedByString:@"/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        if (1 == [arrFucnameAndParameter count])
        {
            
            [self JsToObjectmethod:funcStr ];
            
        }
        else if(2 == [arrFucnameAndParameter count])
        {
            if([arrFucnameAndParameter objectAtIndex:1])
            {
                
                NSDictionary *dict=[NSDictionary dictionaryWithDictionary:
                                    [[[arrFucnameAndParameter objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] objectFromJSONString]];
                
                [self JsToObjectmethod:funcStr Paramet:dict];
                
                
            }
        }
        
        return false;
    }
    
    NSString* scheme = [[request URL] scheme];
    //    NSLog(@"scheme = %@",scheme);
    //判断是不是https
    NSLog(@"host = %@",[[request URL] host]);
    
    if ([scheme isEqualToString:@"https"]&&[[[request URL] host] isEqualToString:@"172.20.0.213"])
    {
        
        if (([str isEqualToString:_authurl]&&_authedl==YES))
        {
            return YES;
        }
        _authurl=[[NSString alloc]initWithString:str];
        _authedl=NO;
        NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://172.20.0.213:8443"]] delegate:self];
        [conn start];
        [webView stopLoading];
        return NO;
    }
    return YES;
}

#pragma js交互
-(void)JsToObjectmethod:(NSString*)funname
{
    if ([funname isEqualToString:@"goback"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)JsToObjectmethod:(NSString*)funname Paramet:(NSDictionary*)dit
{
    
    if ([[dit objectForKey:@"status"]intValue]==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"OAUTH_SUCCESS" object:_oauthType];

        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

#pragma NSURLConnection
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount]== 0)
    {
        _authedl=YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    return request;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _authedl=YES;
    //webview 重新加载请求。
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_authurl]]];
    [connection cancel];
}

-(UIWebView *)webView
{
    if (_webView== nil) {
        _webView= [[UIWebView alloc] init];
        _webView.scrollView.bounces=NO;
    }
    return _webView;
}



@end
