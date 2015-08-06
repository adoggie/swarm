//
//  TabViewController.m
//  DESK
//
//  Created by 51desk on 15/6/9.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "TabViewController.h"

Class object_getClass(id object);

#define TabButtonViewCenterTag 700
#define ContentViewTag 800

@interface TabViewController ()
{
    CGRect _selfFrame;
    NSArray *_titleArray;
    NSArray *_imageArray;
    NSMutableArray *showIngCtr;
    UIViewController *_lastedCtr;
    //
    CGRect FRAME;
    CGFloat _height;
    BOOL _canAnimation;
    BOOL _IsPop;
    BOOL _canPop;
    BOOL _canShowGrayLine;
}
@end

@implementation TabViewController
@synthesize viewControls=_viewControls;
@synthesize currentIndex=_currentIndex;
@synthesize delegate=_delegate;
@synthesize color=_color;



#pragma mark use as viewcontroller---
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (int i=0; i<[showIngCtr count]; i++) {
        NSInteger index=[[showIngCtr objectAtIndex:i] integerValue];
        UIViewController *ctr=[_viewControls objectAtIndex:index];
        [ctr viewWillAppear:animated];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    for (int i=0; i<[showIngCtr count]; i++) {
        NSInteger index=[[showIngCtr objectAtIndex:i] integerValue];
        UIViewController *ctr=[_viewControls objectAtIndex:index];
        [ctr viewDidAppear:animated];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


-(void)setContentView1:(CGRect)frame
{
    UIView *contentview=(UIView *)[self.view viewWithTag:ContentViewTag];
    if (contentview==nil) {
        contentview=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height+frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-64-FRAME.size.height+def_addHeight-frame.size.height-frame.origin.y)];
        [self.view addSubview:contentview];
        contentview.tag=ContentViewTag;
    }
}

-(void)setTabButtonsFrame:(CGRect)frame withColor:(UIColor *)color
{
    FRAME=frame;
    self.color=color;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    showIngCtr=[[NSMutableArray alloc] init];
    
    
    self.view.userInteractionEnabled=YES;
    if (IOS_7) {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self setContentView1:FRAME];
    if (_viewControls) {
        CGRect frame=FRAME;
        TabButtonsView *_viewCenter=[[TabButtonsView alloc] initWithFrame:frame withCounts:[_viewControls count] canShowGratLine:YES];
        _viewCenter.tag=TabButtonViewCenterTag;
        _viewCenter.tabviewdelegate=self;
        [self.view addSubview:_viewCenter];
        [_viewCenter setTitles:_titleArray Images:_imageArray selectColor:_color];
        [_viewCenter selectAtIndex:_currentIndex];
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectControlViewAtIndex:(NSInteger)index
{
    self.currentIndex=index;
}

-(void)setControlsTitles:(NSArray *)titles
{
    _titleArray=[[NSArray alloc]initWithArray:titles];
}

-(void)setControlsImages:(NSArray *)images
{
    _imageArray=[[NSArray alloc]initWithArray:images];
}

-(void)TabButtonClickAtIndext:(NSInteger)index
{
    UIView *contentview=(UIView *)[self.view viewWithTag:ContentViewTag];
    UIViewController *current_ctr=(UIViewController *)[_viewControls objectAtIndex:index];
    if (_lastedCtr) {
        _lastedCtr.view.hidden=YES;
    }
    current_ctr.view.hidden=NO;
    if (![contentview.subviews containsObject:current_ctr.view])
    {
        [contentview addSubview:current_ctr.view];
        CGRect rect= current_ctr.view.frame;
        rect.origin.y-=IOS_7?0:20;
        current_ctr.view.frame=rect;
        [showIngCtr addObject:[NSNumber numberWithInteger:index]];
    }
    self.currentIndex=index;
    _lastedCtr=current_ctr;
}





@end


#define btTagAdd 100
@interface TabButtonsView ()
{
    NSInteger _lastedClick;
    Class _classIsa;
    BOOL _canShowGrayLine;
    UIColor *_selColor;
    UIColor *_deSelColor;
}
@end

@implementation TabButtonsView
@synthesize tabviewdelegate=_tabviewdelegate;
@synthesize selectedAtIndex=_selectedAtIndex;

-(id)initWithFrame:(CGRect)frame withCounts:(NSInteger)counts
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        for (int i=0; i<counts; i++) {
            //
            ButtonEx *bt=[ButtonEx buttonWithType:UIButtonTypeCustom];
            bt.frame=CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, frame.size.height-1);
            bt.canShowGrayLine=_canShowGrayLine;
            bt.tag=i+btTagAdd;
            [bt addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:bt];
            _lastedClick=-1;
        }
        if (counts>3) {
            self.contentSize = CGSizeMake(SCREEN_WIDTH/3*counts,  frame.size.height);
            self.showsHorizontalScrollIndicator = FALSE;
        }
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame withCounts:(NSInteger)counts canShowGratLine:(BOOL)canShow
{
    _canShowGrayLine=canShow;
    return [self initWithFrame:frame withCounts:counts];
}

-(void)selectAtIndex:(NSInteger)index
{
    [self btClick_2:index];
}

-(void)setTabviewdelegate:(id<TabButtonDelegate>)delegate
{
    _tabviewdelegate=delegate;
    _classIsa=object_getClass(_tabviewdelegate);
}

-(void)setTitles:(NSArray *)source Images:(NSArray*)images selectColor:(UIColor *)color
{
    for (int i=0; i<[source count]; i++) {
        ButtonEx *bt=(ButtonEx *)[self viewWithTag:i+btTagAdd];
        
        NSString *text=[[source objectAtIndex:i] isKindOfClass:[NSString class]]?[source objectAtIndex:i]:@"";
        [bt setTitle:text forState:UIControlStateNormal];
        CGSize titleSize=[text sizeWithFont:[UIFont boldSystemFontOfSize:12]];
        
        
        if (images.count>0) {
            [bt setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
            
            [bt setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                                    0.0,
                                                    0.0,
                                                    -titleSize.width)];
            
            [bt setTitleEdgeInsets:UIEdgeInsetsMake(35.0,
                                                    -[UIImage imageNamed:@"Tab_Review_Icon"].size.width,
                                                    0.0,
                                                    0.0)];
        }
        
       [bt selectColor:color];
    }
}

-(void)btClick:(id)sender
{
    ButtonEx *bt=(ButtonEx *)sender;
    ButtonEx *lastBt=(ButtonEx *)[self viewWithTag:_lastedClick+btTagAdd];
    if ([bt isEqual:lastBt]) {
        return;
    }
    if (bt==nil) {
        bt=(ButtonEx *)[self viewWithTag:(NSInteger)sender+btTagAdd];
    }
    NSInteger index=bt.tag-btTagAdd;
    if (_tabviewdelegate!=nil&&[_tabviewdelegate respondsToSelector:@selector(TabButtonClickAtIndext:)])// object_getClass(_delegate) == _classIsa
    {
        bt.backgroundColor=[UIColor whiteColor];
        if (index!=_lastedClick) {
            [bt onClick:YES];
            
            if (lastBt!=nil) {
                [lastBt onClick:NO];
            }
            _lastedClick=index;
        }
        [_tabviewdelegate TabButtonClickAtIndext:index];
    }
}

-(void)btClick_2:(NSInteger)i
{
    ButtonEx *bt=(ButtonEx *)[self viewWithTag:i+btTagAdd];
    NSInteger index=bt.tag-btTagAdd;
    if (_tabviewdelegate!=nil&&
        object_getClass(_tabviewdelegate) == _classIsa
        &&[_tabviewdelegate respondsToSelector:@selector(TabButtonClickAtIndext:)])
    {
        bt.backgroundColor=[UIColor whiteColor];
        if (index!=_lastedClick) {
            [bt onClick:YES];
            ButtonEx *lastBt=(ButtonEx *)[self viewWithTag:_lastedClick+btTagAdd];
            if (lastBt!=nil) {
                [lastBt onClick:NO];
            }
            _lastedClick=index;
        }
        [_tabviewdelegate TabButtonClickAtIndext:index];
    }
}

-(void)resetStatus
{
    NSArray *arr=self.subviews;
    for (int i=0;i<arr.count; i++) {
        id obj=[arr objectAtIndex:i];
        if ([obj isKindOfClass:[UIButton class]]) {
            ButtonEx *btn=(ButtonEx *)obj;
            [btn onClick:NO];
            _lastedClick=-1;
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    
}


@end




#define btnTag 990
@implementation ButtonEx
@synthesize canShowGrayLine=_canShowGrayLine;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        selFlag=NO;
        self.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}


-(void)onClick:(BOOL)click
{
    selFlag=click;
    self.backgroundColor=[UIColor whiteColor];
    [self setSelected:selFlag];
    [self setNeedsDisplay];
}


-(void)selectColor:(UIColor *)color
{
    if (_selectColorLine!=color) {
        _selectColorLine=nil;
        _selectColorLine=color;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    if (selFlag) {
        CGContextSetStrokeColorWithColor(context, _selectColorLine.CGColor);
        
        CGContextMoveToPoint(context, 0, rect.size.height);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
        CGContextSetLineWidth(context, 5.0);
        [self setTitleColor:_selectColorLine forState:UIControlStateNormal];
    }else        if (!selFlag&&_canShowGrayLine) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    
    CGContextStrokePath(context);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
}


@end

