//
//  DeskBottomView.m
//  DESK
//
//  Created by 51desk on 15/6/10.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "DeskBottomView.h"

#define btTagAdd 100
@interface DeskBottomView ()
{
    NSInteger _lastedClick;
    Class _classIsa;
    BOOL _canShowGrayLine;
    UIColor *_selColor;
    UIColor *_deSelColor;
}
@end

@implementation DeskBottomView
@synthesize delegate=_delegate;



-(id)initWithFrame:(CGRect)frame withCounts:(NSInteger)counts
{
    if (self=[super initWithFrame:frame]) {
        _lastedClick=-1;
        self.backgroundColor=[UIColor whiteColor];
        for (int i=0; i<counts; i++) {
            //
            UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
            bt.frame=CGRectMake(i*SCREEN_WIDTH/counts, 0, SCREEN_WIDTH/counts, frame.size.height-1);
            bt.tag=i+btTagAdd;
            [bt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:bt];
        }
        
    }
    return self;
}

-(void)setTabviewdelegate:(id<DeskBottomDelegate>)delegate
{
    _delegate=delegate;
    
}

-(void)setCounts:(NSInteger)counts
{
    _lastedClick=-1;
    for (int i=0; i<counts; i++) {
        //
        UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
        bt.frame=CGRectMake(i*SCREEN_WIDTH/counts, 0, SCREEN_WIDTH/counts,self. frame.size.height-1);
        bt.tag=i+btTagAdd;
        [bt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
    }
    
}

-(void)setTitles:(NSArray *)source Images:(NSArray*)images
{
    if (source!=nil) {
        for (int i=0; i<[source count]; i++) {
            UIButton *bt=(UIButton *)[self viewWithTag:i+btTagAdd];
            
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
            
        }
        
    }else if (images.count>0) {
        
        for (int i=0; i<[images count]; i++) {
            UIButton *bt=(UIButton *)[self viewWithTag:i+btTagAdd];
            [bt setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
            
        }
        
    }
    
    
}

-(void)buttonClick:(id)sender
{
    UIButton *bt=(UIButton *)sender;
//    UIButton *lastBt=(UIButton *)[self viewWithTag:_lastedClick+btTagAdd];
//    if ([bt isEqual:lastBt]) {
//        return;
//    }
    if (bt==nil) {
        bt=(UIButton *)[self viewWithTag:(NSInteger)sender+btTagAdd];
    }
    NSInteger index=bt.tag-btTagAdd;
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(DeskBottomClickAtIndext:)])// object_getClass(_delegate) == _classIsa
    {
//        if (index!=_lastedClick) {
            [_delegate DeskBottomClickAtIndext:index];
            _lastedClick=index;
//        }
        
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, 0,0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextStrokePath(context);
    
}


@end
