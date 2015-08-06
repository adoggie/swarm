//
//  DeskLabelEX.m
//  DESK
//
//  Created by 51desk on 15/6/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "DeskLabelEX.h"

@interface DeskLabelEX (){
    

    
}


@end

@implementation DeskLabelEX

-(id)init
{
   
    if (self=[super init]) {
        _LeftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0,100, 44)];
        [self addSubview:_LeftLabel];
        _RightLabel=[[UILabel alloc]initWithFrame:CGRectMake(110,0,SCREEN_WIDTH-110, 44)];
        [self addSubview:_RightLabel];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    _LeftLabel.frame=CGRectMake(10, 0, 120, frame.size.height);
    _RightLabel.frame=CGRectMake(130, 0, frame.size.width-140, frame.size.height);
    [super setFrame:frame];
}


-(void)setLeftLabelWidth:(CGFloat)width
{
    _LeftLabel.frame=CGRectMake(10, 0, width, self.frame.size.height);
    _RightLabel.frame=CGRectMake(width+10, 0,self. frame.size.width- width-20, self.frame.size.height);

}


-(void)setLeftLabelText:(NSString *) textstring color:(UIColor*)textcolor
{
     _LeftLabel.textColor=textcolor;
      _LeftLabel.text=textstring;

}

-(void)setRightLabelText:(NSString *) textstring color:(UIColor*)textcolor
{
    _RightLabel.textColor=textcolor;
    _RightLabel.text=textstring;
    
}

-(void)setLeftLabelTextFont:(CGFloat)size
{
    _LeftLabel.font=[UIFont systemFontOfSize:size];
}


-(void)setRightLabelTextFont:(CGFloat)size
{
    _RightLabel.font=[UIFont systemFontOfSize:size];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
 
    if (_labelstyle==DeskLabelEXStyleBTLine) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, DESKCOLOR(0x4d4c4c).CGColor);
        CGContextMoveToPoint(context, 0, rect.size.height);
        CGContextAddLineToPoint(context, rect.size.width,  rect.size.height);
        CGContextStrokePath(context);
    }

    
}

@end
