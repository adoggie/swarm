//
//  DeskLabelEX.h
//  DESK
//
//  Created by 51desk on 15/6/29.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeskUIConstantDefine.h"

typedef NS_ENUM(NSUInteger, DeskLabelEXStyle) {
    
    DeskLabelEXStyledefault,
    DeskLabelEXStyleBTLine,
    
};

@interface DeskLabelEX : UIView


@property (nonatomic,strong) UILabel * LeftLabel;
@property(nonatomic,strong)  UILabel *RightLabel;
@property(nonatomic,assign)  DeskLabelEXStyle labelstyle;

-(void)setLeftLabelText:(NSString *) textstring color:(UIColor*)textcolor;
-(void)setRightLabelText:(NSString *) textstring color:(UIColor*)textcolor;
-(void)setLeftLabelTextFont:(CGFloat)size;
-(void)setRightLabelTextFont:(CGFloat)size;
-(void)setLeftLabelWidth:(CGFloat)width;
@end
