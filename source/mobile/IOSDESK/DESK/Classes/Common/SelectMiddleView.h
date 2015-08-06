//
//  SelectMiddleView.h
//  DESK
//
//  Created by 51desk on 15/6/11.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeskUIConstantDefine.h"
#import "UIView+AEBHandyAutoLayout.h"
#import "UIView+LayoutMethods.h"
#import "DeskCommonConfig.h"




@protocol SelectMiddleDelegate <NSObject>
-(void)SelectMiddleClickAtIndext:(int)index;
@end

@interface SelectMiddleView : UIView

@property (nonatomic,assign)id<SelectMiddleDelegate> selectmiddledelegate;
@property (nonatomic,assign)NSInteger selectedAtIndex;
-(void)setTitles:(NSArray *)source Images:(NSArray*)images selectColor:(UIColor *)color;
-(id)initWithFrame:(CGRect)frame withCounts:(NSInteger)counts;
-(id)initWithFrame:(CGRect)frame withCounts:(NSInteger)counts canShowGratLine:(BOOL)canShow;
-(void)selectAtIndex:(NSInteger)index;
-(void)resetStatus;
-(void)setCounts:(NSInteger)counts;

@end


@interface MiddleButton : UIButton
{
    BOOL selFlag;
    UIColor *_selectColorLine;
}
-(void)onClick:(BOOL)click;
-(void)selectColor:(UIColor *)color;
@property (nonatomic,assign)BOOL canShowGrayLine;
@end