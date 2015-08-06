//
//  AnalyticsWebView.m
//  DESK
//
//  Created by 51desk on 15/7/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "AnalyticsWebView.h"

@implementation AnalyticsWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
 
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
       [super viewWillDisappear:animated];
    self.navigationController.navigationBar .hidden=NO;

    
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
           self.navigationController.navigationBar .hidden=YES;
    [self initbackBarItem];
    _webView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [_webView setUserInteractionEnabled:YES];
    
 
//    
//    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [_webView loadHTMLString:html baseURL:baseURL];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
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
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
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
