//
//  SelectMiddleView.m
//  DESK
//
//  Created by 51desk on 15/6/11.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "SelectMiddleView.h"

#define btTagAdd 100

@interface SelectMiddleView ()
{
    NSInteger _lastedClick;
    Class _classIsa;

    UIColor *_selColor;
    UIColor *_deSelColor;
}
@end
@implementation SelectMiddleView
@synthesize selectmiddledelegate=_selectmiddledelegate;
@synthesize selectedAtIndex=_selectedAtIndex;


-(id)initWithFrame:(CGRect)frame withCounts:(NSInteger)counts
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        for (int i=0; i<counts; i++) {
            //
            MiddleButton *bt=[MiddleButton buttonWithType:UIButtonTypeCustom];
            bt.frame=CGRectMake(i*SCREEN_WIDTH/3, 1, SCREEN_WIDTH/3, frame.size.height-2);
            bt.tag=i+btTagAdd;
            [bt addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:bt];
            _lastedClick=-1;
        }

    }
    return self;
}


-(void)setCounts:(NSInteger)counts
{
    for (int i=0; i<counts; i++) {
        MiddleButton *bt=[MiddleButton buttonWithType:UIButtonTypeCustom];
        bt.frame=CGRectMake(40+i*( SCREEN_WIDTH-80)/counts, 1,( SCREEN_WIDTH-80)/counts, self.frame.size.height-2);
        bt.tag=i+btTagAdd;
        
        if (i!=counts-1) {
            UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake( bt.frame.origin.x+  bt.frame.size.width, 4, 1,  self.frame.size.height-8)];
            lineview.backgroundColor=DESKCOLOR(0x4d4c4c);
            [self addSubview:lineview];
           
        }

        
        
        [bt addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        _lastedClick=-1;
    }

}

-(id)initWithFrame:(CGRect)frame withCounts:(NSInteger)counts canShowGratLine:(BOOL)canShow
{
    return [self initWithFrame:frame withCounts:counts];
}

-(void)selectAtIndex:(NSInteger)index
{
    [self btClick_2:index];
}

-(void)setSelectMiddleDelegate:(id<SelectMiddleDelegate>)delegate
{
    _selectmiddledelegate=delegate;

}

-(void)setTitles:(NSArray *)source Images:(NSArray*)images selectColor:(UIColor *)color
{
    for (int i=0; i<[source count]; i++) {
        MiddleButton *bt=(MiddleButton *)[self viewWithTag:i+btTagAdd];
    
        
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
    MiddleButton *bt=(MiddleButton *)sender;
    MiddleButton *lastBt=(MiddleButton *)[self viewWithTag:_lastedClick+btTagAdd];
    if ([bt isEqual:lastBt]) {
        return;
    }
    if (bt==nil) {
        bt=(MiddleButton *)[self viewWithTag:(NSInteger)sender+btTagAdd];
    }
    int index=(int)bt.tag-btTagAdd;
    if (_selectmiddledelegate!=nil&&[_selectmiddledelegate respondsToSelector:@selector(SelectMiddleClickAtIndext:)])    {

        if (index!=_lastedClick) {
            [bt onClick:YES];
            
            if (lastBt!=nil) {
                [lastBt onClick:NO];
            }
            _lastedClick=index;
        }
        [_selectmiddledelegate SelectMiddleClickAtIndext:index];
    }
}

-(void)btClick_2:(int)i
{
    MiddleButton *bt=(MiddleButton *)[self viewWithTag:i+btTagAdd];
    int index=(int)bt.tag-btTagAdd;
    if (_selectmiddledelegate!=nil&&
     [_selectmiddledelegate respondsToSelector:@selector(SelectMiddleClickAtIndext:)])
    {
        bt.backgroundColor=[UIColor clearColor];
        if (index!=_lastedClick) {
            [bt onClick:YES];
            MiddleButton *lastBt=(MiddleButton *)[self viewWithTag:_lastedClick+btTagAdd];
            if (lastBt!=nil) {
                [lastBt onClick:NO];
            }
            _lastedClick=index;
        }
        [_selectmiddledelegate SelectMiddleClickAtIndext:index];
    }
}

-(void)resetStatus
{
    NSArray *arr=self.subviews;
    for (int i=0;i<arr.count; i++) {
        id obj=[arr objectAtIndex:i];
        if ([obj isKindOfClass:[UIButton class]]) {
            MiddleButton *btn=(MiddleButton *)obj;
            [btn onClick:NO];
            _lastedClick=-1;
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, DESKCOLOR(0x4d4c4c).CGColor);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    CGContextSetStrokeColorWithColor(context, DESKCOLOR(0x4d4c4c).CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextStrokePath(context);
    
}


@end




#define btnTag 990
@implementation MiddleButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        selFlag=NO;
        self.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        [self setTitleColor:DESKCOLOR(0x4d4c4c) forState:UIControlStateNormal];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)selectColor:(UIColor *)color
{
    if (_selectColorLine!=color) {
        _selectColorLine =nil;
        _selectColorLine=color;
    }
}


-(void)onClick:(BOOL)click
{
    selFlag=click;
    self.backgroundColor=[UIColor clearColor];
    [self setSelected:selFlag];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (selFlag) {
        float fw = rect.size.width;
        float fh = rect.size.height;
        CGContextSetFillColorWithColor(context, _selectColorLine.CGColor);
        CGContextFillRect(context,CGRectMake(4, 4, fw-8, fh-8));//填充框
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }else     if (!selFlag) {
        [self setTitleColor:DESKCOLOR(0x4d4c4c) forState:UIControlStateNormal];
    }
    CGContextStrokePath(context);

}


@end